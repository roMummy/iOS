//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *  生成器和序列
 */

///生成器 遵循这个协议的任何类型

protocol GeneratorType {
    associatedtype Element
    func next() -> Element
}

//从数组的末尾生成序列值
class CountdownGenrator: GeneratorType {
    var element: Int
    
    init<T>(array: [T]) {
        self.element = array.count
    }
    func next() -> Int? {
        element -= 1
        return self.element < 0 ? nil : element
    }
}

let xs = ["A", "B", "C"]
let generator = CountdownGenrator(array: xs)
while let i = generator.next() {
    print(i)
}

//生成无数个2的幂值
class PowerGenrator: GeneratorType {
    var power: NSDecimalNumber = 1
    let two: NSDecimalNumber = 2
    
    func next() -> NSDecimalNumber? {
        power = power.multiplying(by: two)
        return power
    }
    //查找满足某个条件的最小值
    func findPower(predicate: (NSDecimalNumber) -> Bool) -> NSDecimalNumber {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return 0
    }
    //泛型版本
    func find(_ predicate: (Element) -> Bool) -> Element? {
        while let x = self.next() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
}

let powerMin = PowerGenrator().findPower{$0.intValue > 1000}
print(powerMin)

//生成一组字符串，与某个文件中以行为单位的内容相对应
class FileLinesGenerator: GeneratorType {
    typealias Element = String?
    var lines: [String] = []
    init(filename: String) throws {
        let contents: String = try String(contentsOfFile: filename)
        let newLine = NSCharacterSet.newlines
        lines = contents.components(separatedBy: newLine)
    }
    
    func next() -> Element {
        guard !lines.isEmpty else {
            return nil
        }
        let nextLine = lines.remove(at: 0)
        return nextLine
    }
}
//print("123123")

class LimitGenerator<G: GeneratorType>: GeneratorType {
    var limit = 0
    var generator: G
    
    init(limit: Int, generator: G) {
        self.limit = limit
        self.generator = generator
    }
    func next() -> G.Element? {
        guard limit >= 0 else {
            return nil
        }
        limit -= 1
        return generator.next()
    }
}

//使用AnyIterator重构CountdownGenrator
extension Int {
    func countDown() -> AnyIterator<Int> {
        var i = self
        i -= 1
        return AnyIterator{i < 0 ? nil : i}
    }
}

//拼接两个基础元素相同的生成器
//func +<G: GeneratorType, H: GeneratorType>(first: G, second: H) -> AnyIterator<G.Element> where G.Element == H.Element {
//    return AnyIterator{first.next() }
//}

/*
 *      序列
 */

protocol SequenceType {
    associatedtype Generator: GeneratorType
    func generate() -> Generator
//    func map<T>(
//        _ transform: (Self.Generator.Element) throws -> T)
//        rethrows -> [T]
}

//生成一个数组的倒序序列值
struct ReverseSequance<T>: SequenceType {
    var array: [T]
    
    init(array: [T]) {
        self.array = array
    }
    func generate() -> CountdownGenrator{
        return CountdownGenrator(array: array)
    }
//    func map<T>(_ transform: (Int?) throws -> T) rethrows -> [T] {
//        return [transform()]
//    }
}

let reverseSequance = ReverseSequance(array: xs)
let reverseGenerator = reverseSequance.generate()
while let i = reverseGenerator.next() {
    print("\(i)  \(xs[i])")
}

//for i in ReverseSequance(array: xs) {
//    print("\(i)  \(xs[i])")
//}


/*
 *      遍历二叉树
 */

//GeneratorOfOne 结构体可以用于将某个可选值封装成一个生成器
let three: [Int] = Array(IteratorOverOne(_elements: 3))
print(three)
let empty: [Int] = Array(IteratorOverOne(_elements: nil))

func one<T>(x: T?) -> AnyIterator<T> {
    return AnyIterator(IteratorOverOne(_elements: x))
}

