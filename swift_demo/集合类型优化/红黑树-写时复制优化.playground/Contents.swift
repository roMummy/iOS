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

///构建weak数组
private struct Weak<Wrapped: AnyObject> {
    weak var value: Wrapped?
    init(_ value: Wrapped) {
        self.value = value
    }
}


///构建颜色
public enum Color {
    
    case black
    case red
    var symbol: String {
        switch self {
        case .black:
            return "⚫️"
        case .red:
            return "🔴"
        }
    }
}
///由于线性结构的红黑树不能获取到包装节点的私有变量 所以用其它方式来实现红黑树
public struct RedBlackTree<Element: Comparable>: SortedSet {
    fileprivate var root: Node? = nil
    public init(){}
    
    class Node {
        var color: Color
        var value: Element
        var left: Node? = nil
        var right: Node? = nil
        //记录当前节点从创建来一共被修改的次数
        var mutationCount: Int = 0
        init(_ color: Color, _ value: Element, _ left: Node?, _ right: Node?) {
            self.color = color
            self.value = value
            self.left = left
            self.right = right
        }
    }
    ///index
    public struct Index {
        fileprivate weak var root: Node?
        fileprivate let mutationCount: Int?
        
        fileprivate var path: [Weak<Node>]
        fileprivate init(root: Node?, path: [Weak<Node>]) {
            self.root = root
            self.path = path
            self.mutationCount = root?.mutationCount
        }
    }
    
    public subscript(_ index: Index) -> Element {
        precondition(index.isValid(for: root))
        return index.path.last!.value!.value
    }
    public struct Iterator: IteratorProtocol {
        let tree: RedBlackTree
        var index: RedBlackTree.Index
        
        init(_ tree: RedBlackTree) {
            self.tree = tree
            self.index = tree.startIndex
        }
        public mutating func next() -> Element? {
            if index.path.isEmpty {
                return nil
            }
            defer {
                index.formSuccessor()
            }
            return index.path.last!.value!.value
        }
    }
}
extension RedBlackTree.Node {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        try left?.forEach(body)
        try body(value)
        try right?.forEach(body)
    }
    ///复制一个新的节点
    func clone() -> Self {
        return .init(color, value, left, right)
    }
    ///确保left唯一性
    fileprivate func makeLeftUnique() -> RedBlackTree<Element>.Node? {
        if left != nil, !isKnownUniquelyReferenced(&left) {
            left = left!.clone()
        }
        return left
    }
    ///确保right唯一性
    fileprivate func makeRightUnique() -> RedBlackTree<Element>.Node? {
        if right != nil, !isKnownUniquelyReferenced(&left) {
            right = right!.clone()
        }
        return right
    }
    ///插入
    func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        mutationCount += 1
        if element < self.value {//左边
            if let next = makeLeftUnique() {
                let result = next.insert(element)
                if result.inserted {//左边插入成功，平衡节点
                    self.balance()
                }
                return result
            }else {
                self.left = .init(.red, element, nil, nil)
                return (true, element)
            }
        }
        if element > self.value {//右边
            if let next = makeRightUnique() {
                let result = next.insert(element)
                if result.inserted {//右边插入成功，平衡节点
                    self.balance()
                }
                return result
            }else {
                self.right = .init(.red, element, nil, nil)
                return (true, element)
            }
        }
        //相同 失败 确保唯一性
        return (false, self.value)
    }
    ///平衡节点的颜色
    func balance() {
        if self.color == .red { return}
        if left?.color == .red {
            if left?.left?.color == .red {
                let l = left!
                let ll = l.left!
                swap(&self.value, &l.value)
                (self.left, l.left, l.right, self.right) = (ll, l.right, self.right, l)
                self.color = .red
                l.color = .black
                ll.color = .black
                return
            }
            if left?.right?.color == .red {
                let l = left!
                let lr = l.right!
                swap(&self.value, &lr.value)
                (l.right, lr.left, lr.right, self.right) = (lr.left, lr.right, self.right, lr)
                self.color = .red
                l.color = .black
                lr.color = .black
                return
            }
        }
        if right?.color == .red {
            if right?.left?.color == .red {
                let r = right!
                let rl = r.left!
                swap(&self.value, &rl.value)
                (self.left, rl.left, rl.right, r.left) = (rl, self.left, rl.left, rl.right)
                self.color = .red
                r.color = .black
                rl.color = .black
                return
            }
            if right?.right?.color == .red {
                let r = right!
                let rr = r.right!
                swap(&self.value, &r.value)
                (self.left, r.left, r.right, self.right) = (r, self.left, r.left, rr)
                self.color = .red
                r.color = .black
                rr.color = .black
                return
            }
        }
    }
}

extension RedBlackTree.Index {
    ///验证索引是否有效
    fileprivate func isValid(for root: RedBlackTree<Element>.Node?) -> Bool {
        return self.root === root && self.mutationCount == root?.mutationCount
    }
    ///比较两个索引
    fileprivate static func vaildate(left:RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        //判断两个索引是否在同一个数上， 是否都是有效的
        return left.root === right.root && left.mutationCount == right.mutationCount && left.mutationCount == left.root?.mutationCount
    }
    ///索引当前值
    fileprivate var current: RedBlackTree<Element>.Node? {
        guard let ref = path.last else {
            return nil
        }
        return ref.value!
    }
    ///寻找节点的后一个值
    mutating func formSuccessor() {
        guard let node = current else {
            preconditionFailure()
        }
        if var n = node.right {//如果右节点有值 找到最左边的值
            path.append(Weak(n))
            while let next = n.left {
                path.append(Weak(next))
                n = next
            }
        }else {//找上级节点 判断当前节点是不是上级节点的最左边节点
            path.removeLast()
            var n = node
            while let parent = self.current {
                if parent.left === n {
                    return
                }
                n = parent
                path.removeLast()
            }
        }
        
    }
    ///寻找节点的前一个值
    mutating func formPredecessor() {
        let current = self.current
        precondition(current != nil || root != nil)
        if var n = (current == nil ? root: current!.left) {
            path.append(Weak(n))
            while let next = n.right {
                path.append(Weak(next))
                n = next
            }
        }else {
            path.removeLast()
            var n = current
            while let parent = self.current {
                if parent.right === n {return}
                n = parent
                path.removeLast()
            }
        }
    }
}

extension RedBlackTree.Index: Comparable {
    public static func ==(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        precondition(RedBlackTree<Element>.Index.vaildate(left: left, right: right))
        return left.current === right.current
    }
    public static func <(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        precondition(RedBlackTree<Element>.Index.vaildate(left: left, right: right))
        switch (left.current, right.current) {//存在就直接比较值， 不存在就直接返回false
        case let (a?, b?):
            return a.value < b.value
        case (nil, _):
            return false
        default:
            return false
        }
    }
}

extension RedBlackTree: CustomStringConvertible {
    private func diagram<Element: Comparable>(for node: RedBlackTree<Element>.Node?, _ top: String = "", _ root: String = "", _ bottom: String = "") -> String {
        guard let node = node else {
            return root + "•\n"
        }
        if node.left == nil && node.right == nil {
            return root + "\(node.color.symbol) \(node.value)\n"
        }
        return diagram(for: node.right, top + "    ", top + "┌───", top + "│   ")
            + root + "\(node.color.symbol) \(node.value)\n"
            + diagram(for: node.left, bottom + "│   ", bottom + "└───", bottom + "    ")
    }
    
    public var description: String {
        return diagram(for: root)
    }
}


extension RedBlackTree{
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root?.forEach(body)
    }
    
    
    public func contains(_ element: Element) -> Bool {
        var node = root
        while let n = node {
            if n.value < element {
                node = n.right
            }
            else if n.value > element {
                node = n.left
            }else {
                return true
            }
        }
        return false
    }
    ///确保root唯一性
    fileprivate mutating func makeRootUnique() -> Node? {
        if root != nil, !isKnownUniquelyReferenced(&root) {
            root = root!.clone()
        }
        return root
    }
    
    ///插入
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        guard let root = makeRootUnique() else {//确保根节点存在
            self.root = Node(.black, element, nil, nil)
            return (true, element)
        }
        
        defer {//最后执行 确保根节点是黑色
            root.color = .black
        }
        return root.insert(element)
    }
    
    public var endIndex: RedBlackTree<Element>.Index {
        return Index(root: root, path: [])
    }
    public var startIndex: RedBlackTree<Element>.Index {
        //最左边的节点
        var path: [Weak<Node>] = []
        var node = root
        while let n = node {
            path.append(Weak(n))
            node = n.left
        }
        return Index(root: root, path: path)
    }
    
    public func formIndex(after i: inout RedBlackTree<Element>.Index) {
        precondition(i.isValid(for: root))
        i.formSuccessor()
    }
    public func index(after i: RedBlackTree<Element>.Index) -> RedBlackTree<Element>.Index {
        var result = i
        self.formIndex(after: &result)
        return result
    }
    
    public func formIndex(before i: inout RedBlackTree<Element>.Index) {
        precondition(i.isValid(for: root))
        i.formPredecessor()
    }
    public func index(before i: RedBlackTree<Element>.Index) -> RedBlackTree<Element>.Index {
        var result = i
        self.formIndex(before: &result)
        return result
    }
    
    public func makeIterator() -> RedBlackTree<Element>.Iterator {
        return Iterator(self)
    }
}


var set = RedBlackTree<Int>()
for item in 0...20 {
    set.insert(item)
}
print(set)


