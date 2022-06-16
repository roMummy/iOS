//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///哨岗值 有可能为nil的值

///nil合并运算符
let stringTager = "1"
let number = Int(stringTager) ?? 0

extension Array {
    subscript(safa idx: Int) -> Element? {
        return idx < endIndex ? self[idx] : nil
    }
}
let array = [1,2,3]
array[safa: 4] ?? 0

//合并
let i: Int? = nil
let j: Int? = nil
let k: Int? = nil
i ?? j ?? k

//a??b??c 与(a??b)??c 前者是合并 后者是先解包括号的内容，然后在处理外面的内容
let s1: String?? = nil
(s1 ?? "inner") ?? "outer"
let s2: String?? = .some(nil)
(s2 ?? "inner") ?? "outer"

///可选值map
let characters:[Character] = ["1", "2", "3"];
var firstCharacters: String? = nil
if let char = characters.first {
    firstCharacters = String(char)
}
print(firstCharacters)
//使用map 这个map和集合的map不是一样的 只会有一个或者没有
let firstChar = characters.first.map{String($0)}
print(firstChar)

//map实现
extension Optional {
    func map_Opt<U>(transform: (Wrapped) -> U) -> U? {
        if let value = self {
            return transform(value)
        }
        return nil
    }
}
//实现可选reduce
extension Array {
    func reduce(_ nextPartialReduce:(Element, Element) -> Element) -> Element? {
//        guard let fst = first else {
//            return nil
//        }
//        return dropFirst().reduce(fst, nextPartialReduce)
        return first.map{
            dropFirst().reduce($0, nextPartialReduce)
        }
    }
}
[1, 2, 3, 4].reduce(+)

///k可选值flatMap
let stringNumbers = ["1", "2", "3", "foo"]
let x = stringNumbers.first.map_Opt{Int($0)}
print(x)

let y = stringNumbers.first.flatMap{Int($0)}
print(y)

if let a = stringNumbers.first, let b = Int(a) {
    print(b)
}

let urlString = "www.baidu.com"
let view = URL.init(string: urlString)
        .flatMap{try? Data.init(contentsOf: $0)}
        .flatMap{UIImage.init(data: $0)}
        .map{UIImageView(image: $0)}

if let view = view {
    print(view)
}
//flatMap 实现
extension Optional {
    func flatMap<U>(_ transform: (Wrapped) -> U?) -> U? {
        if let value = self, let transformed = transform(value) {
            return transformed
        }
        return nil
    }
}

//使用flatMap过滤nil
let numbers = ["1", "2", "3", "foo"]

var sum = 0
for case let i? in numbers.map({Int($0)}) {
    sum += i
}
sum

numbers.flatMap{Int($0)}.reduce(0, +)

//func flatten<S: Sequence, T>(source: S) -> [T] where S.Iterator.Element == T ? {
//    let filtered = source.lazy.filter{$0 != nil}
//    return filtered.map{$0!}
//}

///可选值判等
let regex = "^Hello$"
if regex.first == "^" {
    print("相同")
}

///Equatable 和 == 
func ==<T: Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
    return lhs.elementsEqual(rhs){$0 == $1}
}

///switch-case 匹配可选值
func ~=<T: Equatable>(pattern: T?, value: T?) -> Bool {
    return pattern == value
}
//对范围进行匹配
func ~=<Bound>(pattern: Range<Bound>, value: Bound?) -> Bool {
    return value.map{pattern.contains($0)} ?? false
}

for i in ["2", "foo", "22", "100"] {
    switch Int(i) {
    case 22:
        print("")
    case 0..<10:
        print("")
    case nil:
        print("")
    default:
        print("")
    }
}

///改进强制解包的错误信息
infix operator !!
func !!<T>(wrpped: T?, failureText: @autoclosure () -> String) -> T {
    if let x = wrpped {
        return x
    }
    fatalError(failureText())
}
let s = "foo"
let ii = Int(s) !! "Expecting integer, got \" \(s)\" "

///在调试版本中进行断言
infix operator !?
func !?<T: ExpressibleByIntegerLiteral>(wrpped: T?, failureText: @autoclosure () -> String) -> T {
    assert(wrpped != nil, failureText())//断言
    return wrpped ?? 0
}
let iii = Int(s) !? "Expecting integer, got \" \(s)\" "

//自定义初始值
func !?<T>(wrpped: T?, nilDefault: @autoclosure () -> (value: T, text: String)) -> T {
    assert(wrpped != nil, nilDefault().text)
    return wrpped ?? nilDefault().value //自定义初始值
}

Int(s) !? (2, "Expecting integer")

//返回void的函数
func !?(wrpped: ()?, failureText: @autoclosure () -> String) {
    assert(wrpped != nil, failureText())//断言
}
var output: String? = nil
output?.write("something") !? "nil"

//**挂起操作**//
//1.fatalError: 接受一条信息，无条件挂起
//2.assert: 检查条件，当结果为false时，停止执行并输出信息，在发布版本会被移除
//3.precondition: 和assert一样，但是在发布版本不会被移除

///隐士可选值行为
var ss: String = "Hello"
ss.isEmpty


