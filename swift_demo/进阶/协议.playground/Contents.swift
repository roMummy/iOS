//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
//extension Sequence where Iterator.Element: Comparable {
//    func sorted() -> [Self.Iterator.Element]
//}
//extension MutableCollection where
//    Self: RandomAccessCollection,
//    Self.Iterator.Element: Comparable {
//        mutating func sort()
//}

///面向协议编程
protocol Drawing {
    mutating func addEllipse(rect: CGRect, fill: UIColor)
    mutating func addRectangle(rect: CGRect, fill fillColor: UIColor)
}
extension CGContext: Drawing {
    func addEllipse(rect: CGRect, fill: UIColor) {
        setFillColor(fill.cgColor)
        fillEllipse(in: rect)
    }
    
    func addRectangle(rect: CGRect, fill fillColor: UIColor) {
        setFillColor(fillColor.cgColor)
        fill(rect)
    }
}
struct XMLNode {
    let tag: String
}
struct SVG {
    var rootNode = XMLNode(tag: "svg")
    mutating func append(node: XMLNode) {
//        rootNode.append(node)
    }
}

///协议扩展
extension Drawing {
    mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {
        let diameter = radius/2
        let origin = CGPoint(x: center.x - diameter, y: center.y - diameter)
        let size = CGSize(width: radius, height: radius)
        let rect = CGRect(origin: origin, size: size)
        addEllipse(rect: rect, fill: fill)
    }
}

///在协议扩展中重写方法
extension SVG {
    mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {

    }
}

///协议的两种类型
//关联类型的协议 普通协议
struct ConstantIterator: IteratorProtocol {
    mutating func next() -> Int? {
        return 1
    }
}

///类型抹消 带有类型参数的只能用作泛型
//let iterator: IteratorProtocol = ConstantIterator()
//let iterator: Any<IteratorProtocol where .Element == Int> = ConstantIterator()
func nextInt<I: IteratorProtocol>(iterator: inout I) -> Int?
    where I.Element == Int {
    return iterator.next()
}

class IntIterator {//类型抹消 第一种方式，封装到black闭包中
    var nextlmpl: () -> Int?
    init<I: IteratorProtocol>(_ iterator: I)
        where I.Element == Int {
            var iteratroCopy = iterator
            self.nextlmpl = {iteratroCopy.next()}
    }
}
var iter = IntIterator(ConstantIterator())
iter = IntIterator([1,2,3].makeIterator())
print(iter.nextlmpl())

extension IntIterator: IteratorProtocol {
    func next() -> Int? {
        return nextlmpl()
    }
}
iter.next()
iter.next()

//泛型版本
class AnyIterator<A>: IteratorProtocol {
    var nextImpl: () -> A?
    
    init<I: IteratorProtocol>(_ iterator: I)
        where I.Element == A {
            var iteratorCopy = iterator
            self.nextImpl = {iteratorCopy.next()}
    }
    func next() -> A? {
        return nextImpl()
    }
}

//方法2
class IteratorBox<A>: IteratorProtocol {
    func next() -> A? {
        fatalError()
    }
}
class IteratorBoxHelper<I: IteratorProtocol>: IteratorBox<I.Element> {
    var iterator: I
    init(iterator: I) {
        self.iterator = iterator
    }
    override func next() -> I.Element? {
        return iterator.next()
    }
}
let itere: IteratorBox<Int> = IteratorBoxHelper(iterator: ConstantIterator())


///带有Self的协议 例如Equatable
struct MonetaryAmount: Equatable {
    var currency: String
    var amountInCents: Int
    
    static func ==(lhs: MonetaryAmount, rhs: MonetaryAmount) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.amountInCents == rhs.amountInCents
    }
}

//let x: Equatable = MonetaryAmount(currency: "error", amountInCents: 100)
func allEqual<E: Equatable>(x: [E]) -> Bool {
    guard let firstElement = x.first else {
        return true
    }
    for element in x {
        guard element == firstElement else {
            return false
        }
    }
    return true
}
extension Collection where Iterator.Element: Equatable {
    func allEqual() -> Bool {
        guard let firstElement = first else {
            return true
        }
        for element in self {
            guard element == firstElement else {
                return false
            }
        }
        return true
    }
}

class IntegerRef: NSObject {
    let int: Int
    init(_ int: Int) {
        self.int = int
    }
}
func ==(lhs: IntegerRef, rhs: IntegerRef) -> Bool {
    return lhs.int == rhs.int
}
let one = IntegerRef(1)
let otherOne = IntegerRef(1)
one == otherOne
//NSObject == 相当于swift中的===
let two: NSObject = IntegerRef(2)
let otherTwo: NSObject = IntegerRef(2)
two == otherTwo

///协议内幕 当我们通过协议类型创建一个变量的时候，这个变量会被包装到一个存在容器的盒子中

func f<C: CustomStringConvertible>(_ x: C) -> Int {
    return MemoryLayout.size(ofValue: x)
}
func g(_ x: CustomStringConvertible) -> Int {
    return MemoryLayout.size(ofValue: x)
}
print(f(5)) //8 “f 接受的是泛型参数，整数 5 会被直接传递给这个函数，而不需要经过任何包装。所以它的大小是 8 字节”

print(g(5)) //40 “对于 g，整数会被封装到一个存在容器中。对于普通的协议，会使用不透明存在容器 (opaque existential container)。不透明存在容器中含有一个存储值的缓冲区 (大小为三个指针，也就是 24 字节)；一些元数据 (一个指针，8 字节)；以及若干个目击表 (0 个或者多个指针，每个 8 字节)。如果值无法放在缓冲区里，那么它将被存储到堆上，缓冲区里将变为存储引用，它将指向值在堆上的地址”


///性能影响

//隐士打包
func printProtocol(array: [CustomStringConvertible]) {
    print(array)
}
//没有打包 性能更好 推荐
func printGeneric<A: CustomStringConvertible>(array: [A]) {
    print(array)
}



