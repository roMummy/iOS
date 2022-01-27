//
//  ViewController.swift
//  VisionDemo
//
//  Created by FSKJ on 2022/1/27.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    lazy var previewView: PreviewView = {
        let view = PreviewView(frame: view.frame)
        return view
    }()
    
    lazy var albumBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 10, y: 30, width: 50, height: 50)
        btn.backgroundColor = .red
        btn.setTitle("相册", for: .normal)
        btn.addTarget(self, action: #selector(tapAlbum), for: .touchUpInside)
        return btn
    }()

    lazy var camera: Camera = {
        let camera = Camera(preview: previewView)
        camera.delegate = self
        return camera
    }()
    let ocr = Ocr()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera.run()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    @objc
    func tapAlbum() {
        camera.stop()
        
        DispatchQueue.main.async {
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }

    // MARK: - UI

    fileprivate func setupUI() {
        view.addSubview(previewView)
        view.addSubview(albumBtn)
        
    }
}
extension ViewController: CameraDelegate {
    func didOutput(sampleBuffer: CMSampleBuffer) {
//        print("sampleBuffer - \(sampleBuffer)")
        ocr.scanText(from: sampleBuffer) { text in
//            print("text >>> \(text)")
        }
    }
}
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        // 相册照片识别
        ocr.scanText(from: image) { list in
            picker.dismiss(animated: true) {
                self.camera.run()
                self.show(message: list.reduce("", {$0 + "\n" + $1}))
            }
        }
        
    }
}


extension UIViewController {
    func show(message: String) {
        let alertController = UIAlertController(title: message,
                                                message: nil, preferredStyle: .alert)
        // 显示提示框
        present(alertController, animated: true, completion: nil)
        // 两秒钟后自动消失
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
    }
}
