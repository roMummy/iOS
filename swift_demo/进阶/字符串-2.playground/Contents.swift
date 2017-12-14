//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///Character的内部组织结构
MemoryLayout<Character>.size

///编码单元表示方式

//使用unicodeScalars拆分字符串
extension String {
    func words(with charaset: CharacterSet = .alphanumerics) -> [String] {
        return self.unicodeScalars.split{
            !charaset.contains($0)
        }.map(String.init)//先转换成String.UnicodeScalarView的切片数组，在转换成String
    }
}
let s = "Wow! This contains _all_ kinds of things like 123 and \"quotes\"?"
s.words()

//UTF-16 它支持随机存取
//extension String.UTF16View: RandomAccessCollection{}


//CustomStringConvertible 实现这个协议可以自定义打印的参数 description
//CustomDebugStringConvertible 可以调用String(reflectiong:)时输出更多的调试信息

///文本输出流
//public func print<Target: TextOutputStream>
//    (_ items: Any...,separator: String = "",
//     terminator: String = "\n", to output: inout Target){}
var ss = ""
let numbers = [1,2,3,4]
print(numbers, to: &ss)

var _playgroundPrintHook: ((String) -> Void)?
var printCapture = ""
_playgroundPrintHook = {text in
    printCapture += text
}
print("123456")
printCapture

//自定义输出流
struct ArrayStreem: TextOutputStream {
    var buffer:[String] = []
    mutating func write(_ string: String) {
        buffer.append(string)
    }
}
var stream = ArrayStreem()
print("Hello", to: &stream)
print("World", to: &stream)
stream.buffer

//扩展Data
extension Data: TextOutputStream {
    public mutating func write(_ string: String) {
        string.utf8CString.dropLast().withUnsafeBufferPointer {
            append($0)
        }
    }
}

//TextOutputStreamable
struct SlowStreamer: TextOutputStreamable, ExpressibleByArrayLiteral {
    let contents: [String]
    
    init(arrayLiteral elements: String...) {
        contents = elements
    }
    func write<Target>(to target: inout Target) where Target : TextOutputStream {
        for x in contents {
            target.write(x)
            target.write("\n")
            sleep(1)
        }
    }
}
let show: SlowStreamer = [
    "You'll see that this gets",
    "written slowly line by line",
    "to the standard output"]
print(show)

//标准错误
struct StdErr: TextOutputStream {
    mutating func write(_ string: String) {
        guard !string.isEmpty else {
            return
        }
        fputs(string, stderr)   //向指定的文件写入一个字符串
    }
}
var standarderror = StdErr()
print("oops!", to: &standarderror)

