//: Playground - noun: a place where people can play

import UIKit

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


/////有序数组

public struct SortedArray<Element: Comparable>: SortedSet {
    fileprivate var storage: [Element] = []
    public init(){}
}
extension SortedArray {
    func index(for element: Element) -> Int {//通过二分排序确定元素的位置
        var start = 0
        var end = storage.count
        while start < end {
            let middle = start + (end - start)/2
            if element > storage[middle] {
                start = middle + 1
            }else {
                end = middle
            }
        }
        return start
    }
    
    public func index(of element: Element) -> Int? {
        let index = self.index(for: element)
        guard index < count, storage[index] == element else {
            return nil
        }
        return index
    }
    
    public func contains(_ element: Element) -> Bool {
        let index = self.index(for: element)
        return index < count && storage[index] == element
    }
    
    public func forEach(_ body:(Element)throws -> Void) rethrows {
        try storage.forEach(body)
    }
    
    public func sorted() -> [Element] {
        return storage
    }
    
    //表示返回值可以不用接收
    @discardableResult
    ///存在就不插入，不存在就插入到指定位置 保证序列不变
    public mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let index = self.index(for: newElement)
        if index < count && storage[index] == newElement {
            return (false, storage[index])
        }
        storage.insert(newElement, at: index)
        return(true, newElement)    
    }
    
}
extension SortedArray: RandomAccessCollection {
    public typealias lndices = CountableRange<Int>
    
    public var startIndex:Int {return storage.startIndex}
    public var endIndex:Int {return storage.endIndex}
    
    public subscript(index: Int) -> Element {
        return storage[index]
    }
}

var set = SortedArray<Int>()
for i in (0..<22) {
    set.insert(2*i)
}
print(set)
set.contains(1)
set.insert(1)
print(set)
let copy = set
set.insert(13)
set.contains(13)
copy.contains(13)

///测试
func benchmark(count: Int, measure: (String, () -> Void) -> Void) {
    var set = SortedArray<Int>()
    let input = 0..<count
    measure("SortedArray.insert") {
        for value in input {
            set.insert(value)
        }
    }
    
    let lookups = 0..<count
    measure("SortedArray.contains") {
        for element in lookups {
            guard set.contains(element) else {
                fatalError()
            }
        }
    }
    
    measure("SortedArray.forEach") {
        var i = 0
        set.forEach{ (element) in
            guard element == i else {fatalError()}
            i += 1
        }
        guard i == input.count else {
            fatalError()
        }
    }
    
    measure("SortedArray.for-in") {
        var i = 0
        for element in set {
            guard element == i else {fatalError()}
            i += 1
        }
        guard i == input.count else {
            fatalError()
        }
    }
}

for size in (0..<20).map({ 1 << $0 }) {
    benchmark(count: size, measure: { (name, body) in
        let start = Date()
        body()
        let end = Date()
        print("\(name),\(size),\(end.timeIntervalSince(start))")
    })
}

