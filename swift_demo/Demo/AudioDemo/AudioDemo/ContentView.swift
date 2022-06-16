//
//  ContentView.swift
//  AudioDemo
//
//  Created by FSKJ on 2022/2/18.
//

import SwiftUI

struct TitleRow: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
        }
    }
}

struct Detail: View {
    var body: some View {
        Text("Hello")
            .foregroundColor(.yellow)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AudioEdit()) {TitleRow(title: "音频编辑")}
                NavigationLink(destination: AudioExtract()) {TitleRow(title: "音频提取")}
                NavigationLink(destination: RecordView()) {TitleRow(title: "音频录制")}
            }
            .listStyle(.plain)
            .navigationTitle("Audio")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
