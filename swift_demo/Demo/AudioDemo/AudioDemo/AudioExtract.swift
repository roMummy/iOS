//
//  AudioExtract.swift
//  AudioDemo
//
//  Created by FSKJ on 2022/2/21.
//

import SwiftUI

struct AudioExtract: View {
    @State private var videoUrl: URL = URL.init(fileURLWithPath: "")
    
    @State private var isShowPhotoLibrary = false
    var body: some View {
        VStack {
            Text("视频地址 - \(self.videoUrl.path)")
            Button {
                self.isShowPhotoLibrary = true
            } label: {
                Text("选择视频")
            }
        }
        .sheet(isPresented: self.$isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, videoUrl: self.$videoUrl)
        }
    }
}

struct AudioExtract_Previews: PreviewProvider {
    static var previews: some View {
        AudioExtract()
    }
}
