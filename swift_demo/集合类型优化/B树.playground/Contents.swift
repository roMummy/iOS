//: Playground - noun: a place where people can play

import UIKit
import Darwin

var str = "Hello, playground"

///获取缓存尺寸大小
func cacheSize() -> Int? {
    var result: Int = 0
    var size = MemoryLayout<Int>.size
    let status = sysctlbyname("hw.l1dcachesize", &result, &size, nil, 0)
    guard status != -1 else {
        return nil
    }
    return result
}

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


///B树
///1.最大尺寸：每个节点最多存储 order - 1 个按照升序排列的元素。
///2.最小尺寸：非根节点中至少要填满一半元素，也就是说，除了根节点以外，其余每个节点中的元素个数至少为 (order - 1) / 2。
///3.深度均匀：所有叶子节点在树中所处的深度必须相同，也就是位于从顶端根节点向下计数的同一层上。

public struct BTree<Element: Comparable> {
    fileprivate var root: Node
    public init() {
        //默认阶为缓存尺寸的4分之一
        let order = (cacheSize() ?? 32768)/(4*MemoryLayout<Element>.stride)
        self.init(order: Swift.max(16, order))
    }
    init(order: Int) {
        self.root = Node(order: order)
    }
}
///添加节点
extension BTree {
    final class Node {
        let order: Int  //阶
        var mutationCount: Int64 = 0  //更改次数
        var elements: [Element] = []  //存放节点的所有有序元素
        var children: [Node] = []   //存放所有子节点
        
        init(order: Int) {
            self.order = order
        }
    }
}
///添加碎片
extension BTree {
    struct Splinter {
        //分离元素 比节点中的所有元素都小
        let separator: Element
        let node: Node
    }
}
///添加路径
extension BTree {
    struct UnsafePathElement {
        unowned(unsafe) let node: Node
        var slot: Int
        init(_ node: Node, _ slot: Int) {
            self.node = node
            self.slot = slot
        }
    }
}
extension BTree.UnsafePathElement {
    var value: Element? {
        guard slot < node.elements.count else {
            return nil
        }
        return node.elements[slot]
    }
    
    var child: BTree<Element>.Node {
        return node.children[slot]
    }
    
    var isLeaf: Bool {return node.isLeaf}
    
    var isAtEnt: Bool {return slot == node.elements.count}
}
extension BTree.UnsafePathElement: Equatable {
    static func == (lhs: BTree<Element>.UnsafePathElement, rhs: BTree<Element>.UnsafePathElement) -> Bool {
        return lhs.node === rhs.node && lhs.slot == rhs.slot
    }
}
extension BTree {
    public struct Index {
        fileprivate weak var root: Node?
        fileprivate let mutationCount: Int64
        
        fileprivate var path: [UnsafePathElement]
        //当前位置
        fileprivate var current: UnsafePathElement
        
        init(startOf tree: BTree) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(tree.root, 0)
            while !current.isLeaf {//不是叶子节点 定位到第一个位置去
                push(0)
            }
        }
        init(endOf tree: BTree) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(tree.root, tree.root.elements.count)
        }
    }
}

extension BTree.Index {
    ///验证根节点
    fileprivate func validate(for root: BTree<Element>.Node) {
        precondition(self.root === root)
        precondition(self.mutationCount == root.mutationCount)
    }
    ///验证两个index是否相同
    fileprivate static func validate(_ left: BTree<Element>.Index, _ right: BTree<Element>.Index) {
        precondition(left.root === right.root)
        precondition(left.mutationCount == right.mutationCount)
        precondition(left.root != nil)
        precondition(left.mutationCount == left.root!.mutationCount)
    }
    ///“接受一个与当前路径相关的子节点中的位置值，并把它添加到路径的末端”
    fileprivate mutating func push(_ slot: Int) {
        path.append(current)
        let child = current.node.children[current.slot]
        current = BTree<Element>.UnsafePathElement(child, slot)
    }
    ///移除最后一个元素
    fileprivate mutating func pop() {
        current = self.path.removeLast()
    }
    ///下一个索引
    fileprivate mutating func formSuccessor() {
        precondition(!current.isAtEnt, "不能是最后一个")
        current.slot += 1
        if current.isLeaf {
            while current.isAtEnt,current.node !== root {
                //上溯到最近的，拥有更多元素的祖先节点
                pop()
            }
        }else {
            while !current.isLeaf {
                //下行到当前节点最左侧叶子节点的开头
                push(0)
            }
        }
    }
    ///上一个索引
    fileprivate mutating func formPredecessor () {
        if current.isLeaf {
            while current.slot == 0, current.node !== root {
                pop()
            }
            precondition(current.slot > 0, "cannot go below startindex")
            current.slot -= 1
        }else {
            while !current.isLeaf {
                let c = current.child
                push(c.isLeaf ? c.elements.count - 1: c.elements.count)
            }
        }
    }
    
}

extension BTree.Index: Comparable {
    public static func ==(left: BTree<Element>.Index, right: BTree<Element>.Index) -> Bool {
        BTree<Element>.Index.validate(left,right)
        return left.current == right.current
    }
    public static func <(left: BTree<Element>.Index, right: BTree<Element>.Index) -> Bool {
        BTree<Element>.Index.validate(left,right)
        switch (left.current.value, right.current.value) {
        case let (a?, b?):
            return a < b
        case (nil, _): return false
        default:
            return true
        }
    }
}

extension BTree.Node {
    ///判断是否是叶子节点
    var isLeaf: Bool {return children.isEmpty}
    ///是否需要分割
    var isTooLarge: Bool {return elements.count >= order}
    
    func forEach(_ body: (Element) throws -> Void) rethrows {
        if children.isEmpty {
            try elements.forEach(body)
        }else {
            for i in 0...elements.count {
                try children[i].forEach(body)
                try body(elements[i])
            }
        }
    }
    ///元素在节点内部的位置
    internal func slot(_ element: Element) -> (match: Bool, index: Int) {
        //通过二分法查找元素
        var start = 0
        var end = elements.count
        while start < end {
            let mid = start + (end - start)/2
            if elements[mid] > element {
                end = mid
            }else {
                start = mid + 1
            }
        }
        let match = start < elements.count && elements[start] == element
        return (match, start)
    }
    ///查找元素是否在当前节点中
    func contains(_ element: Element) -> Bool {
        let slot = self.slot(element)
        //存在当前节点就放回
        if slot.match {return true}
        //子节点没有
        guard !children.isEmpty else {return false}
        //递归整个树
        return children[slot.index].contains(element)
    }
    ///实现写时复制 克隆节点
    func clone() -> BTree<Element>.Node {
        let clone = BTree<Element>.Node(order: order)
        clone.elements = self.elements
        clone.children = self.children
        return clone
    }
    ///确定子节点写时复制
    func makeChildUnique(at slot: Int) -> BTree<Element>.Node {
        guard !isKnownUniquelyReferenced(&children[slot]) else {
            return children[slot]
        }
        let clone = children[slot].clone()
        children[slot] = clone
        return clone
    }
    ///分离节点中元素多的节点
    func split() -> BTree<Element>.Splinter {
        let count = self.elements.count
        let mid = count/2
        
        let separator = self.elements[mid]
        
        let node = BTree<Element>.Node(order: order)
        //把节点后半段添加的碎片节点中
        node.elements.append(contentsOf: self.elements[mid + 1 ..< count])
        //移除添加进去的节点 和 中间节点
        self.elements.removeSubrange(mid..<count)
        if !isLeaf {//存在叶子节点 把叶子节点也平均分割
            node.children.append(contentsOf: self.children[mid + 1 ..< count])
            self.children.removeSubrange(mid + 1 ..< count + 1)
        }
        return .init(separator: separator, node: node)
    }
    ///插入元素
    func insert(_ element: Element) -> (old: Element?, splinter: BTree<Element>.Splinter?) {
        //查找是否已经存在
        let slot = self.slot(element)
        if slot.match {
            return (self.elements[slot.index], nil)
        }
        //不存在 节点更改次数
        mutationCount += 1
        //如果是叶子节点 直接插入进去
        if self.isLeaf {
            elements.insert(element, at: slot.index)
            return (nil, self.isTooLarge ? self.split() : nil)
        }
        let (old, splinter) = makeChildUnique(at: slot.index).insert(element)
        guard let s = splinter else {
            return (old, nil)
        }
        elements.insert(s.separator, at: slot.index)
        children.insert(s.node, at: slot.index + 1)
        return (nil, self.isTooLarge ? self.split() : nil)
    }
    var count: Int {
        return children.reduce(elements.count){$0 + $1.count}
    }
    
}


extension BTree {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root.forEach(body)
    }
    fileprivate mutating func makeRootUnique() -> Node {
        if isKnownUniquelyReferenced(&root) {
            return root
        }
        root = root.clone()
        return root
    }
    ///插入
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let root = makeRootUnique()
        let (old, splinter) = root.insert(element)
        if let splinter = splinter {
            //添加新的层级
            let r = Node(order: root.order)
            r.elements = [splinter.separator]
            r.children = [root, splinter.node]
            self.root = r
        }
        return (old == nil, old ?? element)
    }
    public var count: Int {
        return root.count
    }

}
extension BTree: SortedSet {
    public var startIndex: BTree<Element>.Index {
        return Index(startOf: self)
    }
    public var endIndex: BTree<Element>.Index {
        return Index(endOf: self)
    }
    public subscript(index: Index) -> Element {
        index.validate(for: root)
        return index.current.value!
    }
    public func formIndex(after i: inout BTree<Element>.Index) {
        i.validate(for: root)
        i.formSuccessor()
    }
    public func formIndex(before i: inout BTree<Element>.Index) {
        i.validate(for: root)
        i.formPredecessor()
    }
    public func index(after i: BTree<Element>.Index) -> BTree<Element>.Index {
        i.validate(for: root)
        var i = i
        i.formSuccessor()
        return i
    }
    public func index(before i: BTree<Element>.Index) -> BTree<Element>.Index {
        i.validate(for: root)
        var i = i
        i.formSuccessor()
        return i
    }
}

///自定义迭代器 避免索引验证
extension BTree {
    public struct Iterator: IteratorProtocol {
        public mutating func next() -> Element? {
            guard let result = index.current.value else {
                return nil
            }
            index.formSuccessor()
            return result
        }
        
        let tree: BTree
        var index: Index
        
        init(_ tree: BTree) {
            self.tree = tree
            self.index = tree.startIndex
        }
    }
    public func makeIterator() -> BTree<Element>.Iterator {
        return Iterator.init(self)
    }
}
///验证
var set = BTree<Int>(order: 5)
for i in 0...250 {
    set.insert(i)
}
print(set)

