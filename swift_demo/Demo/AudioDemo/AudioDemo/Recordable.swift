//
//  Recordable.swift
//  AudioDemo
//
//  Created by FSKJ on 2022/4/2.
//

import AVFoundation
import Foundation

protocol RecordableDelegate: AnyObject {
    func recorderDidBegin(_ recorder: Recordable)
    func recorder(_ recorder: Recordable, output buffer: AVAudioPCMBuffer)
    func recorderDidFinished(_ recorder: Recordable)
    func recorder(_ recorder: Recordable, error: Error)
}

protocol Recordable {
    var delegate: RecordableDelegate? { get set }

    /// 设置声道数 默认为1
    func set(channelsPerFrame: Int)
    /// 设置采样率 默认为44100
    func set(sampleRate: Double)
    /// 设置变声
    func set(voiceChanger: Int)
    /// 设置降噪等级
    func set(noise level: Int)
    /// 保存文件夹路径(caf格式)
    func set(outputPath: String)
    /// 获取输出文件路径 默认"NSTemporaryDirectory() + "record.caf"
    func getOutputPath() -> String

    func start()
    func stop()
    func pause()
}

class Recorder: Recordable {
    private var channelsPerFrame: Int = 1
    private var sampleRate: Double = 44100
    /// 采样间隔
    private let ioBufferDuration = 0.1
    private var voiceChanger: Int = 0
    private var noise: Int = 0
    private var outputPath: String = NSTemporaryDirectory() + "record.caf"

    private var inputNode: AVAudioInputNode!
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile?
    /// 输入音频默认信息
    private var audioFormat: AVAudioFormat?
    /// 重采样信息
    private var resampleFormat: AVAudioFormat? {
        return AVAudioFormat(settings: [
            AVSampleRateKey: sampleRate,
            AVChannelLayoutKey: channelsPerFrame,
            AVEncoderBitRateKey: 32000
        ])
        return AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: Double(sampleRate), channels: AVAudioChannelCount(channelsPerFrame), interleaved: false)
    }

    weak var delegate: RecordableDelegate?

    init() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode

        let audiosession = AVAudioSession.sharedInstance()
        do {
            try audiosession.setPreferredSampleRate(sampleRate)
            try audiosession.setPreferredIOBufferDuration(ioBufferDuration)
            try audiosession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            try audiosession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetoothA2DP,.defaultToSpeaker])
        } catch {
            print(error)
        }

        var setting = audioEngine.inputNode.inputFormat(forBus: 0).settings
        setting[AVNumberOfChannelsKey] = channelsPerFrame

        // 录音信息
        audioFormat = AVAudioFormat(settings: setting)

//        let pitchNode = AVAudioUnitTimePitch()
//        audioEngine.attach(pitchNode)
//
//        audioEngine.connect(inputNode, to: pitchNode, format: inputNode.inputFormat(forBus: 0))
        
        audioEngine.prepare()

        inputNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(0.1 * sampleRate), format: audioFormat, block: outputTapBlocck)

        prepareWriteAudioToFile(resampleFormat!.settings)
    }

    func start() {
        do {
            try audioEngine.start()
            delegate?.recorderDidBegin(self)
        } catch {
            delegate?.recorder(self, error: error)
        }
    }

    func stop() {
        audioEngine.stop()
        delegate?.recorderDidFinished(self)
    }

    func pause() {
        audioEngine.pause()
    }

    func getOutputPath() -> String {
        return outputPath
    }

    /// 准备输出文件
    private func prepareWriteAudioToFile(_ settings: [String: Any]) {
        do {
            audioFile = try AVAudioFile(forWriting: URL(fileURLWithPath: outputPath), settings: settings, commonFormat: .pcmFormatInt16, interleaved: false)
        } catch {
            print("创建AVAudioFile失败 - \(error.localizedDescription)")
            delegate?.recorder(self, error: error)
        }
    }

    /// 输出tap
    private func outputTapBlocck(_ buffer: AVAudioPCMBuffer, _ time: AVAudioTime) {
        print("write buffer")
        guard let audioFormat = audioFormat, let resampleFormat = resampleFormat else {return}
        
        let formatConverter = AVAudioConverter(from: audioFormat, to: resampleFormat)

        let frameCapacity = AVAudioFrameCount(resampleFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(buffer.format.sampleRate)
        guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: resampleFormat, frameCapacity: frameCapacity) else {
            return
        }
        // 输出block
        let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
            outStatus.pointee = AVAudioConverterInputStatus.haveData
            return buffer
        }
        // 重采样
        var error: NSError?
        formatConverter?.convert(to: pcmBuffer, error: &error, withInputFrom: inputBlock)
        
        // ns
//        DenoiseTask.init(level: .high,
//                         sampleRate: sampleRate,
//                         atChannelsPerFrame: UInt32(channelsPerFrame),
//                         atAudioFormatID: 0,
//                         atFormatFlags: 0,
//                         sampleBuffer: pcmBuffer)
        
        // 写入到文件里面
        do {
            try self.audioFile?.write(from: pcmBuffer)
        } catch {
            print("write buffer error -\(error.localizedDescription)")
            self.delegate?.recorder(self, error: error)
        }
        self.delegate?.recorder(self, output: pcmBuffer)

        print("\(pcmBuffer) \(Date().timeIntervalSince1970)")
        print("sampleRate - \(pcmBuffer.format.sampleRate)")
    }
}

// MARK: - Setter

extension Recorder {
    func set(channelsPerFrame: Int) {
        self.channelsPerFrame = channelsPerFrame
    }

    func set(sampleRate: Double) {
        self.sampleRate = sampleRate
        prepareWriteAudioToFile(resampleFormat!.settings)
    }

    func set(voiceChanger: Int) {
        self.voiceChanger = voiceChanger
    }

    func set(noise level: Int) {
        noise = level
    }

    func set(outputPath: String) {
        guard outputPath.format.uppercased() == "AAC" else {
            fatalError("输出的格式必须为aac格式")
        }
        self.outputPath = outputPath
    }
}

extension Recorder {
    class Player {
        private var audioEngine: AVAudioEngine!
        private var pitchNode: AVAudioUnitTimePitch!
        private var playerNode: AVAudioPlayerNode!
        init() {
            audioEngine = AVAudioEngine()
            pitchNode = AVAudioUnitTimePitch()
            playerNode = AVAudioPlayerNode()
            
            audioEngine.attach(playerNode)
            audioEngine.attach(pitchNode)
            
            audioEngine.connect(playerNode, to: pitchNode, format: nil)
            audioEngine.connect(pitchNode, to: audioEngine.mainMixerNode, format: nil)
            
            audioEngine.prepare()
        }
        
        func save(buffer: AVAudioPCMBuffer, file: String) {
            playerNode.scheduleBuffer(buffer, completionHandler: nil)
            
        }
    }
}


class Converter {
    static func configureSampleBuffer(pcmBuffer: AVAudioPCMBuffer) -> CMSampleBuffer? {
        let audioBufferList = pcmBuffer.mutableAudioBufferList
        let asbd = pcmBuffer.format.streamDescription

        var sampleBuffer: CMSampleBuffer? = nil
        var format: CMFormatDescription? = nil
        
        var status = CMAudioFormatDescriptionCreate(allocator: kCFAllocatorDefault,
                                                         asbd: asbd,
                                                   layoutSize: 0,
                                                       layout: nil,
                                                       magicCookieSize: 0,
                                                       magicCookie: nil,
                                                       extensions: nil,
                                                       formatDescriptionOut: &format);
        if (status != noErr) { return nil; }
        
        var timing: CMSampleTimingInfo = CMSampleTimingInfo(duration: CMTime(value: 1, timescale: Int32(asbd.pointee.mSampleRate)),
                                                            presentationTimeStamp: CMClockGetTime(CMClockGetHostTimeClock()),
                                                            decodeTimeStamp: CMTime.invalid)
        status = CMSampleBufferCreate(allocator: kCFAllocatorDefault,
                                      dataBuffer: nil,
                                      dataReady: false,
                                      makeDataReadyCallback: nil,
                                      refcon: nil,
                                      formatDescription: format,
                                      sampleCount: CMItemCount(pcmBuffer.frameLength),
                                      sampleTimingEntryCount: 1,
                                      sampleTimingArray: &timing,
                                      sampleSizeEntryCount: 0,
                                      sampleSizeArray: nil,
                                      sampleBufferOut: &sampleBuffer);
        if (status != noErr) { NSLog("CMSampleBufferCreate returned error: \(status)"); return nil }
        
        status = CMSampleBufferSetDataBufferFromAudioBufferList(sampleBuffer!,
                                                                blockBufferAllocator: kCFAllocatorDefault,
                                                                blockBufferMemoryAllocator: kCFAllocatorDefault,
                                                                flags: 0,
                                                                bufferList: audioBufferList);
        if (status != noErr) { NSLog("CMSampleBufferSetDataBufferFromAudioBufferList returned error: \(status)"); return nil; }
        
        return sampleBuffer
    }
}
