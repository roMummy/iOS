//
//  Camera.swift
//  VisionDemo
//
//  Created by FSKJ on 2022/1/27.
//

import Foundation
import AVFoundation

protocol CameraDelegate: NSObjectProtocol {
    func didOutput(sampleBuffer: CMSampleBuffer)
}

class Camera: NSObject {
    weak var delegate: CameraDelegate?
    
    let previewView: PreviewView
    let captureSession = AVCaptureSession()
    let captureSessionQueue = DispatchQueue(label: "com.demo.VisionDemo.CaptureSessionQueue")
    
    var captureDevice: AVCaptureDevice?
    
    var videoDataOutput = AVCaptureVideoDataOutput()
    let videoDataOutputQueue = DispatchQueue(label: "com.demo.VisionDemo.VideoDataOutputQueue")
    
    init(preview: PreviewView) {
        self.previewView = preview
        super.init()
        previewView.session = captureSession
        // 防止阻塞主线程
        captureSessionQueue.async {
            self.setupCamera()
        }
    }
    
    func setupCamera() {
        // 创建捕获设备
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("不能创建捕获设备")
            return
        }
        self.captureDevice = captureDevice
        
        // 设置1080p捕获
        if captureDevice.supportsSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        // 创建输入设备
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("创建输入设备失败")
            return
        }
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
        // 配置输出设备
        // 丢弃延迟帧
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        // 通过代理的方式获取数据buffer
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            // 开启视频稳定的话，在屏幕上绘制会有延迟
            videoDataOutput.connection(with: .video)?.preferredVideoStabilizationMode = .off
        } else {
            print("添加视频输出失败")
            return
        }
        
        // 设置缩放和自动对焦识别小文字
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.videoZoomFactor = 2
            captureDevice.autoFocusRangeRestriction = .near
            captureDevice.unlockForConfiguration()
        } catch {
            print("设置缩放失败 \(error.localizedDescription)")
            return
        }
    }
    
    func run() {
        captureSessionQueue.async {[weak self] in
            guard let `self` = self else {return}
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }
    func stop() {
        captureSessionQueue.async {[weak self] in
            self?.captureSession.stopRunning()
        }
    }
}
extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        delegate?.didOutput(sampleBuffer: sampleBuffer)
    }
}
