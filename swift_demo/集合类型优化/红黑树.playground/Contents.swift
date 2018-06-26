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

///构建红黑树
//“红黑树总是保持它的节点的按照一定顺序排布，并以恰当的颜色着色，从而始终满足下述几条性质：
//
//1.根节点是黑色的。
//2.红色节点只拥有黑色的子节点。(只要有，就一定是。)
//3.从根节点到一个空位，树中存在的每一条路径都包含相同数量的黑色节点。”

///构建颜色
public enum Color {
    case black
    case red
}

///构建红黑树
public enum RedBlackTree<Element: Comparable> {
    case empty
    //indirect允许递归
    indirect case node(Color, Element, RedBlackTree, RedBlackTree)
    ///索引
    public struct Index {
        fileprivate var value: Element?
    }
}
public extension RedBlackTree {
    func contains(_ element: Element) -> Bool {
        switch self {
        case .empty:
            return false
        case .node(_, element, _, _):
            return true
        case let .node(_, value, left, _) where value > element:
            return left.contains(element)
        case let .node(_, _, _, right):
            return right.contains(element)
        }
    }
    
    func forEach(_ body: (Element) throws -> Void) rethrows {
        switch self {
        case .empty:
            break
        case let .node(_, value, left, right):
            //先遍历左边在中间再后面 中序遍历
            try left.forEach(body)
            try body(value)
            try right.forEach(body)
        }
    }
    
    @discardableResult
    mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let (tree, old) = inserting(element)
        self = tree
        return (old == nil, old ?? element)
    }
    
    func inserting(_ element: Element) -> (tree: RedBlackTree, existingMember: Element?) {
        let (tree, old) = _inserting(element)
        switch tree {
        case let .node(.red, value, left, right):
            return (.node(.black, value, left, right), old)
        default:
            return (tree, old)
        }
        
    }
    ///“查找指定元素可以作为叶子节点被插入到树中的位置”
    func _inserting(_ element: Element) -> (tree: RedBlackTree, old: Element?) {
        switch self {
        case .empty:
            //向空树插入元素
            return (.node(.red, element, .empty, .empty), nil)
        case let .node(_, value, _, _) where value == element:
            //相同 返回原来的值 和节点
            return (self, value)
        case let .node(color, value, left, right) where value > element:
            //插入的值小于当前节点，插入到左边
            let (l, old) = left._inserting(element)
            //old存在表示没有插入进去
            if let old = old {return (self, old)}
            return (balanced(color, value, l, right), nil)
        case let .node(color, value, left, right):
            //插入的值大于当前节点，插入到右边
            let (r, old) = right._inserting(element)
            //old存在表示没有插入进去
            if let old = old {return (self, old)}
            return (balanced(color, value, left, r), nil)
        }
    }
    
    ///平衡模式，按照红黑树的方式排列
    func balanced(_ color: Color, _ value: Element, _ left: RedBlackTree, _ right: RedBlackTree) -> RedBlackTree {
        switch (color, value, left, right) {
        case let (.black, z, .node(.red, y, .node(.red, x, a, b),c),d):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, z, .node(.red, x, a, .node(.red, y, b, c)),d):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, x, a, .node(.red, z, .node(.red, y, b, c), d)):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, x, a, .node(.red, y, b, .node(.red, z, c, d))):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        default:
            return .node(color, value, left, right)
        }
    }
    
    ///最小值
    func min() -> Element? {
        switch self {
        case .empty:
            return nil
        case let .node(_, value, left, _):
            //通过递归 找到最左边的值 就是最小值
            return left.min() ?? value
        }
    }
    ///最大值
    func max() -> Element? {
        var node = self
        var maximun: Element? = nil
        while case let .node(_, value, _, right) = node {
            maximun = value
            node = right
        }
        return maximun
    }
    
    ///查找下一个值
    func value(following element: Element) -> (found: Bool, next: Element?) {
        switch self {
        case .empty:
            return (false, nil)
        case .node(_, element, _, let right):
            //当等于当前节点时，找到右边最小的值
            return (true, right.min())
        case let .node(_, value, left, _) where value > element:
            //当小于当前值时，去左边寻找传入值的下一个值
            let v = left.value(following: element)
            return (v.found, v.next ?? value)
        case .node(_, _, _, let right):
            //当大于当前值时，去右边寻找第一个值
            return right.value(following: element)
        }
    }
    ///查找上一个值
    func value(preceding element: Element) -> (found: Bool, next: Element?) {
        var node = self
        var previous: Element? = nil
        while case let .node(_, value, left, right) = node {
            if value > element {
                node = left
            }
            else if value < element {
                previous = value
                node = right
            }
            else {
                return (true, left.max())
            }
        }
        return (false, previous)
    }
    ///返回元素个数
    public var count: Int {
        switch self {
        case .empty:
            return 0
        case let .node(_, _, left, right):
            return left.count + 1 + right.count
        }
    }
    
    ///移除一个元素
//    @discardableResult
//    mutating func remove(_ element: Element) -> (removed: Bool, memberAfterRemove: Element) {
//
//    }
}
///实现集合的功能
extension RedBlackTree: Collection {
    public var startIndex: RedBlackTree<Element>.Index {
        return Index(value: self.min())
    }
    public var endIndex: RedBlackTree<Element>.Index {
        return Index(value: nil)
    }
    public subscript(i: Index) -> Element {
        return i.value!
    }
}
///实现index和formindex
extension RedBlackTree: BidirectionalCollection {
    public func formIndex(after i: inout RedBlackTree<Element>.Index) {
        let v = self.value(following: i.value!)
        precondition(v.found)
        i.value = v.next
    }
    
    public func formIndex(before i: inout RedBlackTree<Element>.Index) {
        let v = self.value(preceding: i.value!)
        precondition(v.found)
        i.value = v.next
    }
    
    public func index(after i: Index) -> Index {
        let v = self.value(following: i.value!)
        precondition(v.found)
        return Index(value: v.next)
    }
    
    public func index(before i: RedBlackTree<Element>.Index) -> RedBlackTree<Element>.Index {
        let v = self.value(preceding: i.value!)
        precondition(v.found)
        return Index(value: v.next)
    }
}

///树形图
extension Color {
    var symbol: String {
        switch self {
        case .black:
            return "⚫️"
        case .red:
            return "🔴"
        }
    }
}
///打印
extension RedBlackTree: CustomStringConvertible {
    func diagram(_ top: String, _ root: String, _ bottom: String) -> String {
        switch self {
        case .empty:
            return root + "·\n"
        case let .node(color, value, .empty, .empty):
            return root + "\(color.symbol)\(value)\n"
        case let .node(color, value, left, right):
            return right.diagram(top + "    ", top + "┌───", top + "│   ")
                + root + "\(color.symbol)\(value)\n"
                + left.diagram(bottom + "│   ", bottom + "└───", bottom + "    ")
        }
    }
    public var description: String {
        return self.diagram("", "", "")
    }
}
///扩展索引 支持Comparable协议
extension RedBlackTree.Index: Comparable {
    public static func ==(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        return left.value == right.value
    }
    
    public static func <(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        if let lv = left.value, let rv = right.value {
            return lv < rv
        }
        return left.value != nil
    }
}

///支持SortedSet
extension RedBlackTree: SortedSet {
    public init() {
        self = .empty
    }
}


//测试
//let tinyTree: RedBlackTree<Int> = RedBlackTree.node(.black, 22, .empty, .empty)
//tinyTree
//
//let smallTree: RedBlackTree<Int> = .node(.black, 2,
//    .node(.red, 1, .node(.black, 12, .empty, .empty), .empty),
//    .node(.red, 3, .empty, .empty))
//
//print(smallTree)
//
var set = RedBlackTree<Int>.empty
for i in 1..<30 {
    set.insert(i)
}
//print(set)
let sset = set.lazy.filter{$0 % 2 == 0}.map{"\($0)"}.joined(separator: ",")
print(sset)

