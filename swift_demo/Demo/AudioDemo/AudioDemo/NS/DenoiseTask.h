//
//  denoiseTask.h
//  denoiseCore
//
//  Created by test on 2021/11/30.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/// 降噪等级
typedef NS_ENUM (NSUInteger, DenoiseLevel) {
	kLow = 0,
	kModerate,
	kHigh,
	kVeryHigh,
};

@interface DenoiseTask : NSObject

/// 创建降噪任务，目前测试wav格式没有问题
/// @param level 降噪等级
/// @param input 文件输入路径
/// @param output 文件输出路径
/// @param queue 执行降噪所在的队列
/// @param progress 执行进度[0-100]
/// @param complete 完成执行；true正常结束；false执行错误
+ (instancetype)taskWithLevel:(DenoiseLevel)level inputPath:(NSString *)input outputPath:(NSString *)output queue:(dispatch_queue_t)queue progress:(void (^)(float progress)) progress complete:(void (^)(BOOL success))complete;


+ (instancetype)taskWithLevel:(DenoiseLevel)level
                   sampleRate:(Float64)sampleRate
           atChannelsPerFrame:(UInt32)channelsPerFrame
              atAudioFormatID:(NSInteger)formatID
                atFormatFlags:(UInt32)formatFlags
                 sampleBuffer:(AVAudioPCMBuffer *)sampleBuffer;

/// 取消降噪操作
- (void)cancel;
@end
