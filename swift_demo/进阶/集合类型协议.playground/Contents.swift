//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//序列 想要使用Sequence协议 只需要实现makeIterator方法

protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Iterator
}

//迭代器

protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}

//创建一个永不枯竭的迭代器

struct ConstantIterator: IteratorProtocol {
    typealias Element = Int
    mutating func next() -> Int? {
        return 1
    }
}

//var iterator = ConstantIterator()
//while let x = iterator.next() {
//    print(x)
//}

struct FibsIterator: IteratorProtocol {
    var state = (0,1)
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}
//var iterator = FibsIterator()
//while let x = iterator.next() {
//    print(x)
//}

//遵守序列协议
struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    mutating func next() -> String? {
        guard offset < string.endIndex else {
            return nil
        }
        offset = string.index(after: offset)
        return string[string.startIndex..<offset]
    }
}

struct PrefixSequence: Sequence {
    let string: String
    
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}

//for prefix in PrefixSequence(string: "Hello") {
//    print(prefix)
//}

//迭代器和值语义 值复制，迭代器的所有状态都会被复制

let seq = stride(from: 0, to: 9, by: 1)
var i1 = seq.makeIterator()
i1.next()
i1.next()
var i2 = i1
i1.next()
i1.next()
i2.next()
i2.next()

//不具有值语义的迭代器 AnyIterator 对别的迭代器进行封装，用来将原来的迭代器的具体类型抹除掉
var i3 = AnyIterator(i1)
var i4 = i3
i3.next()
i3.next()
i4.next()
i4.next()

//基于函数的迭代器和序列

func fibxIterator() -> AnyIterator<Int> {
    var state = (0,1)
    return AnyIterator {
        let upcomingNumber = state.0
        state = (state.1, state.0+state.1)
        return upcomingNumber
    }
}
let fibsSequence = AnySequence.init(fibxIterator())
Array(fibsSequence.prefix(10))

//以first开始，next参数传入的闭包生成序列的后续元素
let randomNumbers = sequence(first: 100) { (previous) -> UInt32? in
    let newValue = arc4random_uniform(previous)
    guard newValue > 0 else {return nil}
    return newValue
}
Array(randomNumbers)

//可以两次调用next闭包
let fibsSequence2 = sequence(state: (0, 1)) { (state: inout(Int, Int)) -> Int? in
    let upcomingNumber = state.0
    state = (state.1, state.0 + state.1)
    return upcomingNumber
}
Array(fibsSequence2.prefix(10))

//不稳定序列
let standardIn = AnySequence {
    return AnyIterator {
        readLine()
    }
}
for (i, line) in standardIn.enumerated() {
    print("\(i + 1):\(line)")
}

//子序列
//extension Sequence where Iterator.Element: Equatable,
//        SubSequence: Sequence,
//        SubSequence.Iterator.Element == Iterator.Element {
//    func headMirrorsTail(_ n: Int) -> Bool {
//        let head = prefix(n)
//        let tail = suffix(n).reversed()
//        return head.elementsEqual(tail)
//    }
//}
//[1,2,3,3,2,1].headMirrorsTail(2)

///集合类型 稳定的序列 Collection

protocol Queue {
    associatedtype Element
    //入栈
    mutating func enqueue(_ newElement: Element)
    //出栈
    mutating func dequeue() -> Element?
}
//先进先出
struct FIFOQueue<Element>: Queue {
    fileprivate var left: [Element] = []
    fileprivate var right: [Element] = []
    //入栈
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    //出栈
    mutating func dequeue() -> (Element)? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}
//实现Collection协议
extension FIFOQueue: Collection {
    public var startIndex: Int{return 0}
    public var endIndex: Int{return left.count + right.count}
    public func index(after i: Int) -> Int {
        precondition(i < endIndex) //先决函数
        return i + 1
    }
    public subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        }else {
            return right[position - left.count]
        }
    }
}

var q = FIFOQueue<String>()
for x in ["1", "2", "3", "4"] {
    q.enqueue(x)
}
for s in q {
    print(s)
}
var a = Array(q)
a.append(contentsOf: q[2...3])
q.map{$0.uppercased()}
q.count

//ExpressibleByArrayLiteral 可以使用[]创建队列
extension FIFOQueue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(left: elements.reversed(), right: [])
    }
    
}

let queue: FIFOQueue = [1,2,3]

//关联类型
//struct IndexingIterator<Element: Collection>: IteratorProtocol, Sequence {
//    private let _elements: Element
//    private var _position: Element.Index
//    init(_elements: Element) {
//        self._elements = _elements
//        self._position = _elements.startIndex
//    }
//    
//    mutating func next() -> Element._Element? {
//        guard _position < _elements.endIndex else {
//            return nil
//        }
//        let element = _elements[_position]
//        _elements.formIndex(after: &_position)
//        return element
//    }
//}

///索引

///单向链表
enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
    //返回查询的节点
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}
let list = List<Int>.end.cons(1).cons(2).cons(3)
print(list)

extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end){partialList, element in
            partialList.cons(element)
        }
    }
}
let list2: List = [1,2,3]
print(list2)

//栈
protocol Stack {
    associatedtype Element
    mutating func push(_ x: Element)//入栈
    mutating func pop() -> Element?//出栈
}
extension Array: Stack {
    mutating func push(_ x: Element) {
        append(x)
    }
    mutating func pop() -> Element? {
        return popLast()
    }
}
extension List: Stack {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    mutating func pop() -> Element? {
        switch self {
        case .end:
            return nil
        case let .node(x, next: xs):
            self = xs
            return x
        }
    }
}
var stacks: List = [1,2,3]
var ab = stacks
var bc = stacks

ab.pop()
ab.pop()
ab.pop()

stacks.pop()
stacks.push(4)

//extension List: IteratorProtocol, Sequence {
//    typealias Iterator = List
//
//    mutating func next() -> Element? {
//        return pop()
//    }
//}

//let lists: List = ["1", "2", "3"]
//for x in lists {
//    print(x)
//}
fileprivate enum ListNode<Element> {
    case end
    indirect case node(Element, next: ListNode<Element>)
    
    func cons(_ x: Element) -> ListNode<Element> {
        return .node(x, next: self)
    }
}
//给栈添加tag
public struct ListIndex<Element>: CustomStringConvertible {
    fileprivate let node: ListNode<Element>
    fileprivate let tag: Int
    
    public var description: String {
        return "ListIndex(\(tag))"
    }
}
//使栈实现comparable协议
extension ListIndex: Comparable {
    public static func == <T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    
    public static func < <T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag > rhs.tag
    }
}

//满足Collection协议的机构体
public struct Lists<Element>: Collection {
    public typealias Index = ListIndex<Element>
    
    public let startIndex: Index
    public let endIndex: Index
    
    public subscript(position: Index) -> Element {
        switch position.node {
        case .end: fatalError("Subscript out of range")
        case let .node(x, _): return x
        }
    }
    
    public func index(after i: Index) -> Index {
        switch i.node {
        case .end:
            fatalError("Subscript out of range")
        case let .node(_, next):
            return Index(node: next, tag: i.tag - 1)
        }
    }
    
    public static func == <T: Equatable>(lhs: Lists<T>, rhs: Lists<T>) ->Bool {
        return lhs.elementsEqual(rhs)
    }
}

//实现 ExpressibleByArrayLiteral
extension Lists: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        startIndex = ListIndex(node: elements.reversed().reduce(.end){partialList, element in
            partialList.cons(element)
            
        }, tag: elements.count)
        endIndex = ListIndex(node: .end, tag: 0)
    }
}
//重写打印
extension Lists: CustomStringConvertible {
    public var description: String {
        let elements = self.map{String(describing: $0)}.joined(separator: ",")
        return "List: (\(elements))"
    }
}

let lists: Lists = ["one", "two", "three"]
lists.first
lists.index(of: "two")

extension Lists {
    public var count: Int {
        return startIndex.tag - endIndex.tag
    }
}
lists.count

///切片

//lists.dropFirst()
//lists.suffix(3)
struct Slice<Base: Collection>: Collection {
    typealias Index = Base.Index
    typealias IndexDistance = Base.IndexDistance
    
    let collection: Base
    
    var startIndex: Index
    var endIndex: Index
    
    init(base: Base, bounds: Range<Index>) {
        collection = base
        startIndex = bounds.lowerBound
        endIndex = bounds.upperBound
    }
    
    func index(after i: Base.Index) -> Index {
        return collection.index(after: i)
    }
    
    subscript(position: Index) -> Base.Iterator.Element {
        return collection[position]
    }
    
    typealias SubSequence = Slice<Base>
    
    subscript(bounds: Range<Base.Index>) -> Slice<Base> {
        return Slice(base: collection, bounds: bounds)
    }
}

//实现自定义切片
extension Lists {
    public subscript(bounds: Range<Index>) -> Lists<Element> {
        return Lists(startIndex: bounds.lowerBound, endIndex: bounds.upperBound)
    }
}

//通用的PrefixIterator
//struct PrefixIterators<Base: Collection>: IteratorProtocol, Sequence {
//    let base = Base
//    var offset: Base.Index
//    
//    init(_ base: Base) {
//        self.base = base
//        self.offset = base.startIndex
//    }
//    
//    mutating func next() -> Base.SubSequence? {
//        guard offset != base.endIndex else {
//            return nil
//        }
//        base.formIndex(after: &offset)
//        return base.prefix(upTo: offset)
//    }
//}

///专门的集合类型

/*  BidirectionalCollection — “一个既支持前向又支持后向遍历的集合。”

    RandomAccessCollection — “一个支持高效随机存取索引遍历的集合。”

    MutableCollection — “一个支持下标赋值的集合。”

    RangeReplaceableCollection — “一个支持将任意子范围的元素用别的集合中的元素进行替换的集合“*/

//前向索引 只能从前面向后面进行索引，不能从后面向前面索引
//重写reversed方法 返回Lists列表
extension Lists {
    public func reversed() -> Lists<Element> {
        let reversedNodes: ListNode<Element> = self.reduce(.end){$0.cons($1)}
        return Lists(startIndex: ListIndex(node: reversedNodes, tag: self.count), endIndex: ListIndex(node: .end, tag: 0))
    }
}
let reversedArray: [String] = lists.reversed()
//lists.reversed() as Any is Lists<String>

//双向索引 BidirectionalCollection

//MutableCollection

//extension FIFOQueue: MutableCollection {
//    public var startIndex: Int {return 0}
//    public var endIndex: Int {return left.count + right.count}
//    
//    public func index(after i: Int) -> Int {
//        return i + 1
//    }
//    public subscript(position: Int) -> Element {
//    
//        get {
//            precondition((0..<endIndex).contains(position), "Index out of bounds")
//            if position < left.endIndex {
//                return left[left.count - position - 1]
//            }else {
//                return right[position - left.count]
//            }
//            
//        }
//        set {
//            precondition((0..<endIndex).contains(position), "Index out of bounds")
//            if position < left.endIndex {
//                left[left.count - position - 1] = newValue
//            }else {
//                return right[position - left.count] = newValue
//            }
//        }
//    }
//}

//RangeReplaceableCollection 将某些元素进行替换
//extension FIFOQueue: RangeReplaceableCollection {
//
//    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, C.Iterator.Element == Element {
//        right = left.reversed() + right
//        left.removeAll()
//        right.replaceSubrange(subrange, with: newElements)
//    }
//}

//组合能力

