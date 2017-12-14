//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///标准等价
let single = "Pok\u{00e9}mon"
let double = "Pok\u{0065}\u{0301}mon"

//字符数相等
single.count
double.count

single.utf16.count
double.utf16.count
single.utf8.count
double.utf8.count

if single == double {
    debugPrint("swift-相等")
}
//NSString 版本 oc中并不相同
let nssingle = NSString.init(characters: [0x0065,0x0301], length: 2)
let nsdouble = NSString.init(characters: [0x00e9], length: 1)

if nssingle.isEqual(to: nsdouble as String) {
    debugPrint("oc - 相等")
}

single.utf16.elementsEqual(double.utf16)

///字符串和集合 已经继承Collection协议扩展
for chare in single {
    print(chare)
}

let s = "abcdef"
let idx = s.index(s.startIndex, offsetBy: 3) //开始之后的底3个字符
s[idx]

let safeIdx = s.index(s.startIndex, offsetBy: 6, limitedBy: s.endIndex) //当越界之后返回nil
String(s.prefix(4)) //通过整数获取字符串

//找到特定的字符
var hello = "Hello!"
if let idx = hello.index(of: "!") {
    hello.insert(contentsOf: ",world", at: idx)
}
hello

//extension String: RangeReplaceableCollection {}
if let comma = hello.index(of: ","){
    print(hello[hello.startIndex..<comma])
    hello.replaceSubrange(hello.startIndex..<hello.endIndex, with: "How about") //替换
}
hello

///字符串与切片
let world = "hello,world!".suffix(6).dropLast()
String(world)

//接收含有多个分隔符的序列作为参数的分割函数
extension Collection where Iterator.Element: Equatable {
    public func split<S: Sequence>(separators: S) -> [SubSequence]
        where Iterator.Element == S.Iterator.Element {
            return split{separators.contains($0)}
    }
   
}
"Hello,World".split(separators: ",l").map(String.init)

///简单的正则表达式匹配器
//基础的正则表达式类型
public struct Regex {
    fileprivate let regexp: String
    public init(_ regexp: String) {
        self.regexp = regexp
    }

    fileprivate static func matchHere (regexp: String.SubSequence, text: String.SubSequence) -> Bool {
        //空的正则表达式可以匹配所有
        if regexp.isEmpty {
            return true
        }

        //所有跟在*后面的字符都需要调用matchStart
        if let c = regexp.first, regexp.dropFirst().first == "*" {
            return matchStar(character: c, regexp: regexp.dropFirst(2), text: text)
        }

        //如果已经是正则表达式的最后一个字符，而且这个是$，那么当且仅当剩余字符串为空时才匹配
        if regexp.first == "$" && regexp.dropFirst().isEmpty {
            return text.isEmpty
        }

        //如果当前字符匹配了，那么从输入字符串和正则表达式中将其丢弃，然后继续进行接下来的匹配
        if let tc = text.first, let rc = regexp.first, rc == "." || tc == rc {
            return matchHere(regexp: regexp.dropFirst(), text: text.dropFirst())
        }

        //如果上面的都不匹配 ， 那么就没有匹配的
        return false
    }

    //*号后面的匹配规则
    fileprivate static func matchStar (character c: Character, regexp: String.SubSequence, text: String.SubSequence) -> Bool {
        var idx = text.startIndex
        while true {// 一个*号匹配0个或多个实例
            if matchHere(regexp: regexp, text: text.suffix(from: idx)) {
                return true
            }
            if idx == text.endIndex || (text[idx] != c && c != ".") {
                return false
            }
            text.formIndex(after: &idx)
        }
    }

    //当字符串参数匹配表达式是返回true
    public func match(_ text: String) -> Bool {
        //如果表达式以^开头，从头开始匹配输入
        if regexp.first == "^" {
            return Regex.matchHere(regexp: regexp.dropFirst(), text: text[text.startIndex..<text.endIndex])
        }
        //在输入的每个部分进行搜索，直到发现匹配
        var idx = text.startIndex
        while true {
            if Regex.matchHere(regexp: regexp[regexp.startIndex..<regexp.endIndex], text: text.suffix(from: idx)) {
                return true
            }
            guard idx != text.endIndex else {break}
            text.formIndex(after: &idx)
        }
        return false
    }
}
//使用
Regex("^h..lo*!$").match("helloooooooo!")


///ExpressibleByStringLiteral 字符串字面量

extension Regex: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        regexp = value
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self = Regex(stringLiteral: value)
    }
    public init(unicodeScalarLiteral value: String) {
        self = Regex(stringLiteral: value)
    }
}

let r: Regex = "^h..lo*!$"
func findMatches(in strings: [String], regex: Regex) -> [String] {
    return strings.filter{regex.match($0)}
}
findMatches(in: ["foo", "bar", "baz"], regex: "^b..")
typealias StringLiteralType = StaticString
let what = "hello"
//what is StaticString

///String 的内部结构
//字符串的内部存储结构
struct String {
    var _core: _StringCore
}
struct _StringCore {
    var _baseAddress: UnsafeMutableRawPointer? //地址
    var _countAndFlags: UInt  //大小
    var _owner: AnyObject? //负责写时复制和内存回收的对象
}

let bits = unsafeBitCast(hello, to: _StringCore.self)
//三个等号代表全等 存储地址都相等


