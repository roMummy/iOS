//
//  denoiseTask.m
//  denoiseCore
//
//  Created by test on 2021/11/30.
//

#import "DenoiseTask.h"


#define DR_WAV_IMPLEMENTATION

#include "dr_wav.h"
#include "noise_suppression.h"

#ifndef nullptr
#define nullptr 0
#endif

#ifndef MIN
#define MIN(A, B)        ((A) < (B) ? (A) : (B))
#endif


@interface DenoiseTaskManager : NSObject
+ (instancetype)manager;
- (void)appendTask:(DenoiseTask *)task;
- (void)removeTask:(DenoiseTask *)task;
@end
@interface DenoiseTaskManager ()
@property (nonatomic, strong) NSMutableSet *taskSet;
@end
@implementation DenoiseTaskManager
//创建该类的单例
+ (instancetype)manager {
	static id instace = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instace = [[self alloc] init];
	});
	return instace;
}
- (instancetype)init {
	self = [super init];
	if (self) {
		_taskSet = [NSMutableSet setWithCapacity:0];
	}
	return self;
}
- (void)appendTask:(DenoiseTask *)task {
	if (task == nil) {
		return;
	}
	[_taskSet addObject:task];
}
- (void)removeTask:(DenoiseTask *)task {
	if (task == nil) {
		return;
	}
	[_taskSet removeObject:task];
}
@end

@interface DenoiseTask ()
@property (nonatomic, assign) DenoiseLevel level;
@property (nonatomic, assign) BOOL cancelFlag;
@property (nonatomic, assign) int channels;
@property (nonatomic, copy) void (^progressCall)(float);
@property (nonatomic, copy) void (^finishCall)(BOOL);
@end
@implementation DenoiseTask
- (void)dealloc {
    printf("DenoiseTask Dealloc\n");
}
+ (instancetype)taskWithLevel:(DenoiseLevel)level inputPath:(NSString *)input outputPath:(NSString *)output queue:(dispatch_queue_t)queue progress:(void (^)(float progress)) progress complete:(void (^)(BOOL success))complete {
	DenoiseTask *task = [[DenoiseTask alloc] init];
	task.progressCall = progress;
	task.finishCall = complete;
	task.cancelFlag = NO;
    task.level = level;

	if (queue) {
		dispatch_async(queue, ^{
			[task denoiseWithInputFilePath:input outPath:output];
		});
	} else {
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_async(queue, ^{
			[task denoiseWithInputFilePath:input outPath:output];
		});
	}
//	[DenoiseTaskManager.manager appendTask:task];
	return task;

}

+ (instancetype)taskWithLevel:(DenoiseLevel)level
                   sampleRate:(Float64)sampleRate
           atChannelsPerFrame:(UInt32)channelsPerFrame
              atAudioFormatID:(NSInteger)formatID
                atFormatFlags:(UInt32)formatFlags
                 sampleBuffer:(AVAudioPCMBuffer *)sampleBuffer {
    DenoiseTask *task = [[DenoiseTask alloc] init];
    task.cancelFlag = NO;
    task.level = level;
    
    [task nsProcessRTC:sampleBuffer];
    
    [DenoiseTaskManager.manager appendTask:task];
    return task;
}
/// 实时处理降噪
- (BOOL)nsProcessRTC:(AVAudioPCMBuffer *)sampleBuffer {
    uint32_t sampleRate = sampleBuffer.format.sampleRate;
    int64_t *buffer = sampleBuffer.int16ChannelData;
    int samplesCount = sampleBuffer.frameLength;
    
    if (buffer == nullptr) {
        return NO;
    }
    if (samplesCount == 0) {
        return NO;
    }
    size_t samples = MIN(160, sampleRate / 100);
    if (samples == 0) {
        return NO;
    }
    uint32_t num_bands = 1;
    int16_t *input = buffer;
    size_t nTotal = (samplesCount / samples);
    NsHandle *nsHandle = WebRtcNs_Create();
    int status = WebRtcNs_Init(nsHandle, sampleRate);
    if (status != 0) {
        printf("WebRtcNs_Init fail\n");
        return NO;
    }
    status = WebRtcNs_set_policy(nsHandle, (int)_level);
    if (status != 0) {
        printf("WebRtcNs_set_policy fail\n");
        return NO;
    }
    /// 记录进度值
    int last = 0;
    
    for (int i = 0; i < nTotal; i++) {
        int16_t *nsIn[1] = {input}; //ns input[band][data]
        int16_t *nsOut[1] = {input}; //ns output[band][data]
        WebRtcNs_Analyze(nsHandle, nsIn[0]);
        WebRtcNs_Process(nsHandle, (const int16_t *const *) nsIn, num_bands, nsOut);
        input += samples;
        float progress = i /(float)nTotal;
        int tmpProgress = (int)(progress * 100);
        /// 防止频繁调用
        if (last != tmpProgress) {
            !_progressCall?:_progressCall(tmpProgress);
            last = tmpProgress;
        }
        /// 如果是取消了，进度回调为nil,完成回调为NO
        if (_cancelFlag) {
            WebRtcNs_Free(nsHandle);
            printf("User cancel\n");
            return NO;
        }
    }
    !_progressCall?:_progressCall(100);
    WebRtcNs_Free(nsHandle);
    return YES;
    
    return false;
}

- (void)cancel {
	_cancelFlag = YES;
	_progressCall = nil;
	[DenoiseTaskManager.manager removeTask:self];
}


- (void)denoiseWithInputFilePath:(NSString *)inPath outPath:(NSString *)outPath {
	const char *in_file  = [inPath  UTF8String];
	const char *out_file = [outPath UTF8String];

	char in_f[1024];
	//把从src地址开始且含有'\0'结束符的字符串复制到以dest开始的地址空间，返回值的类型为char*
	strcpy(in_f,in_file);

	char out_f[1024];
	strcpy(out_f,out_file);

	[self noise_suppression:in_f and:out_f];
}
- (void)noise_suppression:(char *)in_file and:(char *)out_file {
	//音频采样率
	uint32_t sampleRate = 0;
	//总音频采样数
	uint64_t inSampleCount = 0;

	int16_t *inBuffer = [self wavRead_int16:in_file :&sampleRate :&inSampleCount];
	//如果加载成功
	if (inBuffer != nullptr) {
		BOOL b = [self nsProcess:inBuffer :sampleRate :(int)inSampleCount :_level];
		if (b) {
			[self wavWrite_int16:out_file :inBuffer :sampleRate :inSampleCount];
		} else {
            /// 写入失败
            !_finishCall?:_finishCall(NO);
        }
		free(inBuffer);
	} else {
        /// 读取失败
        !_finishCall?:_finishCall(NO);
    }
    /// 写入完成之后直接移除
    [DenoiseTaskManager.manager removeTask:self];
}

//写wav文件
- (void)wavWrite_int16:(char *)filename :(int16_t *)buffer :(size_t)sampleRate :(size_t)totalSampleCount {
	drwav_data_format format = {};
	format.container = drwav_container_riff; // <-- drwav_container_riff = normal WAV files, drwav_container_w64 = Sony Wave64.
	format.format = DR_WAVE_FORMAT_PCM;  // <-- Any of the DR_WAVE_FORMAT_* codes.
	format.channels = self.channels;
	format.sampleRate = (drwav_uint32)sampleRate;
	format.bitsPerSample = 16;
	drwav *pWav = drwav_open_file_write(filename, &format);
	if (pWav) {
		drwav_uint64 samplesWritten = drwav_write(pWav, totalSampleCount, buffer);
		drwav_uninit(pWav);
		if (samplesWritten != totalSampleCount) {
			/// 写入失败
			!_finishCall?:_finishCall(NO);
		} else {
			///  正常结束
			!_finishCall?:_finishCall(!_cancelFlag);
		}
    } else {
        /// 写入失败
        !_finishCall?:_finishCall(NO);
    }
}

//读取wav文件
- (int16_t *)wavRead_int16:(char *)filename :(uint32_t *)sampleRate :(uint64_t *)totalSampleCount {
	unsigned int channels;
	int16_t *buffer = drwav_open_and_read_file_s16(filename, &channels, sampleRate, totalSampleCount);
	if (buffer == nullptr) {
		printf("ERROR.");
	}
    self.channels = channels;
	return buffer;
}

- (BOOL)nsProcess:(int16_t *)buffer :(uint32_t)sampleRate :(int)samplesCount :(DenoiseLevel)level {
	if (buffer == nullptr) {
		return NO;
	}
	if (samplesCount == 0) {
		return NO;
	}
	size_t samples = MIN(160, sampleRate / 100);
	if (samples == 0) {
		return NO;
	}
	uint32_t num_bands = 1;
	int16_t *input = buffer;
	size_t nTotal = (samplesCount / samples);
	NsHandle *nsHandle = WebRtcNs_Create();
	int status = WebRtcNs_Init(nsHandle, sampleRate);
	if (status != 0) {
		printf("WebRtcNs_Init fail\n");
		return NO;
	}
	status = WebRtcNs_set_policy(nsHandle, (int)level);
	if (status != 0) {
		printf("WebRtcNs_set_policy fail\n");
		return NO;
	}
    /// 记录进度值
    int last = 0;
    
	for (int i = 0; i < nTotal; i++) {
		int16_t *nsIn[1] = {input}; //ns input[band][data]
		int16_t *nsOut[1] = {input}; //ns output[band][data]
		WebRtcNs_Analyze(nsHandle, nsIn[0]);
		WebRtcNs_Process(nsHandle, (const int16_t *const *) nsIn, num_bands, nsOut);
		input += samples;
		float progress = i /(float)nTotal;
        int tmpProgress = (int)(progress * 100);
        /// 防止频繁调用
        if (last != tmpProgress) {
            !_progressCall?:_progressCall(tmpProgress);
            last = tmpProgress;
        }
		/// 如果是取消了，进度回调为nil,完成回调为NO
		if (_cancelFlag) {
			WebRtcNs_Free(nsHandle);
            printf("User cancel\n");
			return NO;
		}
	}
    !_progressCall?:_progressCall(100);
	WebRtcNs_Free(nsHandle);
	return YES;
}
@end
