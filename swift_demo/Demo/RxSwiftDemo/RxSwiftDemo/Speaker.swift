//
//  Speaker.swift
//  RxSwiftDemo
//
//  Created by TW on 2018/5/14.
//  Copyright © 2018年 TW. All rights reserved.
//

import Foundation
import UIKit

struct Speaker {
    let name: String
    let twitterHandle: String
    var image: UIImage?
    
    init(name: String, twitterHandle: String) {
        self.name = name
        self.twitterHandle = twitterHandle
        image = UIImage.init(named: name)
    }
}
extension Speaker: CustomStringConvertible {
    var description: String {
        return "\(name) \(twitterHandle)"
    }
}
