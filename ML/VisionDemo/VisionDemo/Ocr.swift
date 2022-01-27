//
//  Ocr.swift
//  VisionDemo
//
//  Created by FSKJ on 2022/1/27.
//

import Foundation
import Vision
import UIKit

class Ocr {
    var complete: (([String]) -> Void)?
    
    lazy var request: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        // 设置为快速模型
//        request.recognitionLevel = .fast
        request.usesLanguageCorrection = true
        // 按照优先级检测语言数组
        request.recognitionLanguages = ["zh-cn"]
        // 设置模型版本
        request.revision = VNRecognizeTextRequestRevision2
        return request
    }()
//    init() {
//        request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
//    }
    
    func scanText(from sampleBuffer: CMSampleBuffer, complete: (([String]) -> Void)?) {
        self.complete = complete
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print(error)
        }
    }
    func scanText(from image: UIImage, complete: (([String]) -> Void)?) {
        self.complete = complete
        guard let cgImage = image.cgImage else {
            return
        }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print(error)
        }
    }
}
extension Ocr {
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let maximumCandidates = 1
        var texts = [String]()
        for visionResult in results {
            guard let candidate = visionResult.topCandidates(maximumCandidates).first else { continue }
            print(">>> \(candidate.string)")
            texts.append(candidate.string)
        }
        complete?(texts)
    }
}
