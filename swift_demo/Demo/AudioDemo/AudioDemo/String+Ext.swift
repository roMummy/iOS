//
//  String+Ext.swift
//  AudioDemo
//
//  Created by FSKJ on 2022/4/6.
//

import Foundation

extension String {
    /// 文件格式 - e.g. “.mp3”
    var `extension`: String {
        if let index = lastIndex(of: ".") {
            return String(self[index...])
        } else {
            return ""
        }
    }

    /// 文件格式 - e.g. "mp3"
    var format: String {
        if let index = lastIndex(of: ".") {
            let start = self.index(index, offsetBy: 1)
            return String(self[start...])
        } else {
            return ""
        }
    }
}
