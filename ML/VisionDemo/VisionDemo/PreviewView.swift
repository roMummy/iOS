//
//  PreviewView.swift
//  VisionDemo
//
//  Created by FSKJ on 2022/1/27.
//

import Foundation
import AVFoundation
import UIKit

class PreviewView: UIView  {
    var videoPerviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        return layer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPerviewLayer.session
        }
        set {
            videoPerviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
