//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 *      QuickCheck 随机测试的haskell库
 */

func pluslsCommutative(_ x: Int, _ y:Int) -> Bool {
    return x + y == y + x
}

///构建QuickCheck

//1.生成随机数
protocol Smaller {
    func smaller() -> Self?
}

protocol Arbitrary {
//    static func smaller() -> Self?
    static func arbitraty() -> Self
}
extension Int: Arbitrary {
    //实现协议 返回一个int类型的随机数
    static func arbitraty() -> Int {
        return Int(arc4random())
    }
}
Int.arbitraty()
extension Int {
    //生成一个范围内的随机数
    static func random(_ from: Int, _ to: Int) -> Int {
        return from + (Int(arc4random())%(to - from))
    }
}
extension Character: Arbitrary {
    //随机生成65-90之间的字符
    static func arbitraty() -> Character {
        return Character(UnicodeScalar(Int.random(65, 90))!)
    }
}
func tabulate<A>(times: Int, transform: (Int) -> A) -> [A] {
    return (0..<times).map(transform)
}
//随机生成0-39个字符 组成一个字符串
extension String: Arbitrary {
    static func arbitraty() -> String {
        let randomLength = Int.random(0, 40)
        let randomCharacters = tabulate(times: randomLength){_ in
            Character.arbitraty()
        }
        return String(randomCharacters)
    }
}
String.arbitraty()
String.arbitraty()

///实现check函数
let numberOfIterations = 200
func check1<A: Arbitrary>(message: String, _ property: (A) -> Bool) {
    for _ in 0..<numberOfIterations {
        let value = A.arbitraty()
        print(value)
        guard property(value) else {
            print("\"\(message)\" doesn`t hold:\(value)")
            return
        }
    }
    print("\"\(message)\" passed\(numberOfIterations) tests")
}

//测试
extension CGSize {
    var area: CGFloat {
        return width * height
    }
}
extension CGFloat: Arbitrary {
    static func arbitraty() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
}
extension CGSize: Arbitrary {
    static func arbitraty() -> CGSize {
        return CGSize(width: CGFloat.arbitraty(), height: CGFloat.arbitraty())
    }
}

//check1(message: "Area"){(size:CGSize) in size.area >= 0}

///缩小范围
check1(message: "String"){(s: String) in s.hasPrefix("Hello")}


extension Int: Smaller {
    //缩小为当前的二分之一
    func smaller() -> Int? {
        return self == 0 ? nil : self / 2
    }
}
100.smaller()

extension String: Smaller {
    //移除第一个字符
    func smaller() -> String? {
        return isEmpty ? nil : String(characters.dropFirst())
    }
}
//只要满足条件就可以无限递归 然后返回初始值
func iterateWhile<A>(_ condition: (A) -> Bool, _ initial: A, _ next: (A) -> A?) -> A {
    if let x = next(initial), condition(x) {
        return iterateWhile(condition, x, next)
    }
    return initial
}

func cheack2<A: Arbitrary>(_ message: String, _ property: @escaping (A) -> Bool) {
    for _ in 0..<numberOfIterations {
        let value = A.arbitraty()
        guard property(value) else {
//            let smallerValue = iterateWhile({!property($0)}, value, {$0.smaller()})
            print("\"\(message)\" doesn`t hold:\(value)")
            return

        }
    }
    print("\"\(message)\" passed\(numberOfIterations) tests")
}

///随机数组

//快速排序
func qsort(_ array: [Int]) -> [Int] {
    
    var array = array
    if array.isEmpty {
        return []
    }
    //每次把数组的第一个元素拿出来 然后和后面的元素比较 然后进行排序
    let pivot = array.remove(at: 0)
    let lesser = array.filter{$0 < pivot}
    let greater = array.filter{$0 >= pivot}
    let pivotArr:[Int] = [pivot]
    
    return qsort(lesser) + pivotArr + qsort(greater)
}


