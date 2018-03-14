//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///模式匹配 正则匹配是模式匹配的子集

func ~=(pattern: NSRegularExpression, input: String) -> Bool {
    return pattern.numberOfMatches(in: input, options: [], range: NSRange(location: 0, length: input.count)) > 0
}

