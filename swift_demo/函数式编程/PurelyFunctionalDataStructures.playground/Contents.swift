//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 *      纯函数式数据结构
 *  具有不变性的高效的数据结构
 */

///二叉搜索树
//class Solution {
//   static func isNumber(_ s: String) -> Bool {
//        for char in s.characters {
//            if char == "0" {
//                return true
//            }
//        }
//        return false
//    }
//}
//Solution.isNumber("2e10")

//二叉树 indirect 插入一个间接层 实现递归
indirect enum BinarySearchTree<Element: Comparable> {
    case Leaf //叶
    case Node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>) //节点
}
//leaf是空的
let leaf: BinarySearchTree<Int> = .Leaf
let five: BinarySearchTree<Int> = .Node(leaf, 5, leaf)

//实现树
extension BinarySearchTree {
    //生成一个空树
    init() {
        self = .Leaf
    }
    //生成一个只含有值得树
    init(_ value: Element) {
        self = .Node(.Leaf, value, .Leaf)
    }
    //计算一棵树中存值得个数
    public var count: Int {
        switch self {
        case .Leaf:
            return 0
        case let .Node(left, _, right):
            return 1 + left.count + right.count
        }
    }
    //计算树中所有元素组成的数组
    var elements: [Element] {
        switch self {
        case .Leaf:
            return []
        case let .Node(left, x, right):
            return left.elements + right.elements + [x]
        }
    }
    //检查一棵树是否为空
    var isEmpty: Bool {
        if case .Leaf = self {
            return true
        }
        return false
    }
    
}

extension Sequence {
    //检查一个数组中的所有元素是不是都符合某个条件
    func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
}
extension BinarySearchTree where Element: Comparable {
    //检测是不是二叉搜索树
    var isBST: Bool {
        switch self {
        case .Leaf:
            return true
        case let .Node(left, x, right):
            return left.elements.all{y in y < x}
                && right.elements.all{y in y > x}
                && left.isBST
                && right.isBST
        }
    }
}

extension BinarySearchTree {
    //检查是否在二叉树中
    func contains(_ x: Element) -> Bool {
        switch self {
        //是否是叶子
        case .Leaf:
            return false
        //是否在中间节点上
        case let .Node(_, y, _) where x == y:
            return true
        //查询值在左边节点上
        case let .Node(left, y, _) where x < y:
            return left.contains(x)
        //查询值在右边节点上
        case let .Node(_, y, right) where x > y:
            return right.contains(x)
        default:
            fatalError("The impossible occurred")
        }
    }
    //插入到二叉树中
    mutating func insert(_ x: Element) {
        switch self {
        case .Leaf:
            self = BinarySearchTree(x)
        case .Node(var left, let y, var right):
            if x < y {
                left.insert(x)
            }
            if x > y {
                right.insert(x)
            }
            self = .Node(left, y, right)
        }
    }
}

let myTree: BinarySearchTree<Int> = BinarySearchTree()
var copied = myTree
copied.insert(5)
copied.insert(1)
//只是值引用
(myTree.elements, copied.elements)

///基于字典树的自动补全

//给一个前缀然后在历史记录中搜索，返回符合的数组
func autocomplete(_ history: [String], textEntered: String) -> [String] {
    return history.filter{$0.hasPrefix(textEntered)}
}

//字典树

//用来存储所有节点处字符余子字典树的映射关系
struct Trie<Element: Hashable> {
    //截止当前节点的字符串是否在树中
    let isElement: Bool
    let children: [Element: Trie<Element>]
    init() {
        isElement = true
        children = [:]
    }
    //初始化
    init(isElement: Bool, children: [Element: Trie<Element>] ) {
        self.isElement = isElement
        self.children = children
    }
    //创建只含有一个元素的字典树
    init(_ key: [Element]) {
        if let (head, tail) = key.decompose {//如果不为空，创建一个新的树，以head为键
            let children = [head: Trie(tail)]
            self = Trie(isElement: false, children: children)
        }else {//如果为空，创建一个没有子节点的空字典
            self = Trie(isElement: true, children: [:])
        }
    }
    //展开字典树
    var elements: [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map{[key] + $0}
        }
        return result
    }
    //确定对应的键是否在数组中
    func lookup(_ key: [Element]) -> Bool {
        //如果键组是一个空数组 返回当前节点的isElement
        guard let(head, tail) = key.decompose else {
            return isElement
        }
        //如果不为空，但是不存在对应的字树 返回false 字典中没有存储这个键组
        guard let subtrie = children[head] else {
            return false
        }
        //递归查询剩下的键是否在这棵树中
        return subtrie.lookup(tail)
    }
    //给定一个前缀，返回所有匹配的元素
    func withPrefix(_ prefix: [Element]) -> Trie<Element>? {
        
        guard let (head, tail) = prefix.decompose else {
            return self
        }
        guard let remainder = children[head] else {
            return nil
        }
        return remainder.withPrefix(tail)
    }
    //重构autocomplete
    func autocomplete(_ key: [Element]) -> [[Element]] {
        return withPrefix(key)?.elements ?? []
    }
    //插入字典树
    func insert(key: [Element]) -> Trie<Element> {
        guard let (head, tail) = key.decompose else {//如果key为空，不添加
            return Trie(isElement: true, children: children)
        }
        var newChildren = children
        if let nextTrie = children[head] {//如果head存在，就把tail插入到对应的子树种
            newChildren[head] = nextTrie.insert(key: tail)
        }else {//如果head不存在就创建一个新的head 然后插入进去
            newChildren[head] = Trie(tail)
        }
        return Trie(isElement: isElement, children: newChildren)
    }
    
}
extension Array {
    //如果数组不为空就返回数组的第一个元素和除开第一个元素的其它元素的数组的元组
    var decompose: (Element, [Element])? {
        return isEmpty ? nil : (self[startIndex], Array(self.dropFirst()))
    }
}

//使用decompose递归式对数组求和
func sum(_ xs: [Int]) -> Int {
    guard let (head, tail) = xs.decompose else {
        return 0
    }
    return head + sum(tail)
}
let sumD = sum([1,2,3,4])

//讲字符串转换成字符树
func buildStringTrie(_ words: [String]) -> Trie<Character> {
    let emptyTrie = Trie<Character>()
    return words.reduce(emptyTrie, { trie, word in
        trie.insert(key: Array(word.characters))
    })
}

//自动拼接
func autocompleteString(knownWords: Trie<Character>, word: String) -> [String] {
    let chars = Array(word.characters)
    let completed = knownWords.autocomplete(chars)
    return completed.map{ chars in
        word + String(chars)
    }
}

let contents = ["car", "cat", "cart", "ad"]
let trieOfWords = buildStringTrie(contents)
let result = autocompleteString(knownWords: trieOfWords, word: "car")
print(result)