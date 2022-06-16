//
//  VideoView.swift
//  AudioDemo
//
//  Created by FSKJ on 2022/2/21.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var videoUrl: URL
    @Environment(\.presentationMode) private var presentationMode
    
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        var parent: ImagePicker
        init(_ p: ImagePicker) {
            self.parent = p
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let videoUrl = info[.mediaURL] as? URL {
                parent.videoUrl = videoUrl
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


