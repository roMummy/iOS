//: Playground - noun: a place where people can play

import UIKit
import Foundation

var str = "Hello, playground"

///创建SortedSet协议 来支持有序集合
public protocol SortedSet: BidirectionalCollection,
    CustomStringConvertible,
CustomPlaygroundQuickLookable {
    ///BidirectionalCollection允许从前往后，从后往前遍历
    ///CustomStringConvertible,CustomPlaygroundQuickLookable可以很好的展示出来
    
    
}
extension SortedSet {
    public var description: String {
        let contents = self.lazy.map{"\($0)"}.joined(separator: ",")
        return "[\(contents)]"
    }
}
#if os(iOS)
    extension PlaygroundQuickLook {
        public static func monospacedText(_ string: String) -> PlaygroundQuickLook {
            let text = NSMutableAttributedString(string: string)
            let range = NSRange(location: 0, length: text.length)
            let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            style.lineSpacing = 0
            style.alignment = .left
            style.maximumLineHeight = 17
            text.addAttribute(.font, value: UIFont(name: "Menlo", size: 13)!, range: range)
            text.addAttribute(.paragraphStyle, value: style, range: range)
            return PlaygroundQuickLook.attributedString(text)
        }
    }
#endif
extension SortedSet {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        #if os(iOS)
            return .monospacedText(String(describing: self))
        #else
            return .text(String(description: self))
        #endif
    }
}

///将NSOrderedSet Swift化
private class Canary{}
public struct OrderedSet<Element: Comparable>: SortedSet {
    
    fileprivate var storage = NSMutableOrderedSet()
    ///确保OrderedSet的唯一性 NSMutableOrderedSet是NSObject类型 不能拿来判断
    fileprivate var canary = Canary()
    public init() {}
}
extension OrderedSet {
    
    public func forEach(_ body: (Element) -> Void) {
        storage.forEach{body($0 as! Element)}
    }
    
    public func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
    }
    ///在某些场面使用原生的方法 不是哈希值也不会返回true
    public func contains2(_ element: Element) -> Bool {
        return storage.contains(element) || index(of: element) != nil
    }
    
    public func index(of element: Element) -> Int? {
        let index = storage.index(of: element, inSortedRange: NSRange(0..<storage.count), usingComparator: OrderedSet.compare)
        return index == NSNotFound ? nil: index
    }
    
    @discardableResult
    public mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let index = self.index(for: newElement)
        if index < storage.count, storage[index] as! Element == newElement {
            //已经存在 插入失败 返回存在的元素
            return(false, storage[index] as! Element)
        }
        ///确保唯一性
        makeUnique()
        storage.insert(newElement, at: index)
        return (true, newElement)
    }
    
    ///返回插入的元素位置
    fileprivate func index(for element: Element) -> Int {
        return storage.index(of: element, inSortedRange: NSRange(0..<storage.count), options: .insertionIndex, usingComparator: OrderedSet.compare)
    }
    
    ///写时复制 在发生变化之前调用这个函数 而已为我们进行写时复制
    fileprivate mutating func makeUnique() {
        if !isKnownUniquelyReferenced(&canary) {
            storage = storage.mutableCopy() as! NSMutableOrderedSet
            canary = Canary()
        }
    }
    
    ///比较两个元素的位置
    fileprivate static func compare(_ a: Any, _ b: Any) -> ComparisonResult {
        let a = a as! Element, b = b as! Element
        if a<b {
            return .orderedAscending
        }
        if a>b {
            return .orderedDescending
        }
        return .orderedSame
    }
}
///实现 Collection
extension OrderedSet: RandomAccessCollection {
    public typealias Index = Int
    public typealias Indices = CountableRange<Int>
    
    public var startIndex: Int {return 0}
    public var endIndex: Int {return storage.count}
    public subscript(i: Int) -> Element {
        return storage[i] as! Element
    }
}

///测试
var set = OrderedSet<Int>()
for i in [12,1,4,1,0] {
    set.insert(i)
}
set
set.contains(1)
set.contains(111)
set.reduce(0, +)

let copy = set
set.insert(22)
copy
set

//检查没有实现哈希的元素
struct Value: Comparable {
    let value: Int
    init(_ value: Int) {
        self.value = value
    }
    static func ==(left: Value, right: Value) -> Bool {
        return left.value == right.value
    }
    static func <(left: Value, right: Value) -> Bool {
        return left.value < right.value
    }
}

let value = Value(42)
let a = value as AnyObject
let b = value as AnyObject
a.isEqual(b)
a.hash
b.hash

var values = OrderedSet<Value>()
[0,1,4,1,2,3].map(Value.init).forEach{
    values.insert($0)
}
values
values.contains(Value(2))
values.contains2(Value(2))




