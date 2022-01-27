//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by FSKJ on 2021/9/27.
//

import CoreML
import UIKit
import AVFoundation

class ViewController: UIViewController {
    var vocalsML: vocals?
    var accompanimentML: accompaniment?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            guard let url = Bundle.main.url(forResource: "vocals", withExtension: "mlmodelc"),
                  let inputUrl = Bundle.main.url(forResource: "100", withExtension: "m4a") else {
                print("url is nil")
                return
            }
//            let compileUrl = try MLModel.compileModel(at: url)
            let model = try MLModel(contentsOf: url)
            print(model.modelDescription)

            vocalsML = vocals(model: model)
            
            
            // TODO: - How
            // 输入: - audio 转换成 4维数组？ MultiArray (Float32 1 × 2 × 512 × 1024)
            //
            // 输出：- MultiArray (Float32)
            // 怎么转换成音频？
            
            let input_3 = try MLMultiArray(shape: [1,2,512,1024], dataType: .float32)
            
            let wav_file = try AVAudioFile(forReading:inputUrl)
            
            let buffer = AVAudioPCMBuffer(pcmFormat: wav_file.processingFormat, frameCapacity: AVAudioFrameCount(wav_file.length))
            
            try wav_file.read(into: buffer!)
            
            guard let bufferData = buffer?.floatChannelData else {
                return
            }
            
            let arr = UnsafeBufferPointer(start: bufferData[0], count: Int(buffer!.frameLength))
            
            print(arr)
            return
            
            let windowSize = 1024
            let windowNumber = wav_file.length / Int64(windowSize)
            for index in 0 ..< Int(windowNumber) {
                let offset = index * windowSize
                for i in 0...windowSize {
                    input_3[[1,2,512] as [NSNumber]] = NSNumber.init(value: bufferData[0][offset + i])
                }
                
                let output = try vocalsML?.prediction(input_3: input_3)
                print(output)
            }
            
//            let output = try vocalsML?.prediction(input: input)

        } catch {
            print(error)
        }
    }
    
    func PCMBufferToFloatArray(_ pcmBuffer: AVAudioPCMBuffer) -> [[Float]]? {
        if let floatChannelData = pcmBuffer.floatChannelData {
            let channelCount = Int(pcmBuffer.format.channelCount)
            let frameLength = Int(pcmBuffer.frameLength)
            let stride = pcmBuffer.stride
            var result: [[Float]] = Array(repeating: Array(repeating: 0.0, count: frameLength), count: channelCount)
            for channel in 0..<channelCount {
                for sampleIndex in 0..<frameLength {
                    result[channel][sampleIndex] = floatChannelData[channel][sampleIndex * stride]
                }
            }
            return result
        } else {
            print("format not in Float")
            return nil
        }
    }
}
