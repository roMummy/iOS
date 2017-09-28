//: Playground - noun: a place where people can play

import UIKit

var str = "Do any additional 12 setup <image>http://regxlib.com/Default.aspx<image/> after 30 loading the view,102 typically 0 from a nib"

//创建规则
let pattern = ".*?image"

//利用规则创建表达式对象
let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))

//利用表达式对象取出结果
let res = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, str.characters.count))
let result = regex.matches(in: str, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, str.characters.count))
for a in result {
//    let startIndex = str.index(str.startIndex, offsetBy: a.range.location)
//    let endIndex = str.index(str.startIndex, offsetBy: a.range.location + a.range.length)
//    let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
//    print(str.substring(with: range))
    
    print(rangeOfString(a.range, str))
}
//获取范围类的字符串
func rangeOfString(_ range: NSRange,_ text: String) -> String {
    let startIndex = text.index(text.startIndex, offsetBy: range.location)
    let endIndex = text.index(text.startIndex, offsetBy: range.location + range.length)
    let newRange = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
    return text.substring(with: newRange)
}


