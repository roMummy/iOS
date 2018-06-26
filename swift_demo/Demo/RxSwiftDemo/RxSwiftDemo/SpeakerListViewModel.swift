//
//  SpeakerListViewModel.swift
//  RxSwiftDemo
//
//  Created by TW on 2018/5/14.
//  Copyright © 2018年 TW. All rights reserved.
//

import Foundation
import RxSwift

struct SpeakerListViewModel {
    let data = Observable.just{[
        Speaker(name: "1", twitterHandle: "@1"),
        Speaker(name: "2", twitterHandle: "@2"),
        Speaker(name: "3", twitterHandle: "@3")
    ]}
}
