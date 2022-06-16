//
//  RecordView.swift
//  AudioDemo
//
//  Created by FSKJ on 2022/4/2.
//

import Foundation
import SwiftUI
import AVFoundation

class RecorderWarpper: RecordableDelegate {
    lazy var recorder: Recorder = {
        let recorder = Recorder()
        recorder.set(sampleRate: 16000)
        recorder.delegate = self
        return recorder
    }()
    lazy var player: AVPlayer = {
        let player = AVPlayer(url: URL(fileURLWithPath: recorder.getOutputPath()))
        return player
    }()
    
    func play() {
        player.play()
    }
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.replaceCurrentItem(with: AVPlayerItem(url: URL(fileURLWithPath: recorder.getOutputPath())))
        player.pause()
        player.seek(to: .zero)
    }
    
    
    func recorderDidBegin(_ recorder: Recordable) {
        print("recorderDidBegin")
    }
    
    func recorder(_ recorder: Recordable, output buffer: AVAudioPCMBuffer) {
        print("output buffer")
    }
    
    func recorderDidFinished(_ recorder: Recordable) {
        print("recorderDidFinished")
    }
    
    func recorder(_ recorder: Recordable, error: Error) {
        print("error - \(error.localizedDescription)")
    }
}


struct RecordView: View {
    let recorder = RecorderWarpper()
    
    var body: some View {
        VStack(spacing:30) {
            Button("开始") {
                print("开始录音")
                recorder.recorder.start()
            }
            Button("暂停") {
                print("暂停录音")
                recorder.recorder.pause()
            }
            Button("结束") {
                print("结束录音")
                recorder.recorder.stop()
            }
        }
        HStack(spacing: 20) {
            Button("播放录音") {
                print("播放录音")
                recorder.play()
            }
            Button("暂停播放") {
                print("暂停播放")
                recorder.pause()
            }
            Button("停止播放") {
                print("停止播放")
                recorder.stop()
            }
        }.frame(height: 80)
    }
}

struct RecordView_Previews: PreviewProvider {
    
    static var previews: some View {
        RecordView()
    }
}
