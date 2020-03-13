import UIKit


// https://github.com/andyRon/swift-algorithm-club-cn/tree/master/Binary%20Search%20Tree


class BinarySearchTree<T: Comparable> {
  private(set) var value: T
  private(set) var parent: BinarySearchTree?
  private(set) var left: BinarySearchTree?
  private(set) var right: BinarySearchTree?
  
  init(value: T) {
    self.value = value
  }
  
  convenience init(array: [T]) {
    precondition(array.count > 0)
    self.init(value: array.first!)
    for item in array.dropFirst() {
      insert(value: item)
    }
  }
  
  /// 是否是根节点
  var isRoot: Bool {
    return parent == nil
  }

  /// 是否是叶子节点
  var isLeaf: Bool {
    return left == nil && right == nil
  }
  
  /// 是否是左叶子节点
  var isLeftChild: Bool {
    return parent?.left === self
  }
  
  /// 是否是右叶子节点
  var isRightChild: Bool {
    return parent?.right === self
  }
  
  /// 是否有左子节点
  var hasLeftChild: Bool {
    return self.left != nil
  }
  
  /// 是否有右子节点
  var hasRightChild: Bool {
    return self.right != nil
  }
  
  /// 是否有子节点
  var hasAnyChild: Bool {
    return hasLeftChild || hasRightChild
  }
  
  /// 是否有左右两个子节点
  var hasBothChild: Bool {
    return hasLeftChild && hasRightChild
  }
  
  /// 当前节点包含的所有子节点数
  var count: Int {
    return (left?.count ?? 0) + 1 + (right?.count ?? 0)
  }
  
  
  /// 插入节点
  func insert(value: T) {
    if value < self.value {
      // left
      if let left = left {
        left.insert(value: value)
      }else {
        left = BinarySearchTree(value: value)
        left?.parent = self
      }
    } else {
      // right
      if let right = right {
        right.insert(value: value)
      }else {
        right = BinarySearchTree(value: value)
        right?.parent = self
      }
    }
  }
  
  /// 搜索
  func search(key: T) -> BinarySearchTree? {
    if value == key {
      return self
    }else if value < key {
      return right?.search(key: key)
    }else {
      return left?.search(key: key)
    }
  }
  
  /// 中序遍历
  func traverseInOrder(process: (T) -> Void) {
    left?.traverseInOrder(process: process)
    process(value)
    right?.traverseInOrder(process: process)
  }
  /// 前序遍历
  func traversePreOrder(process: (T) -> Void) {
    process(value)
    left?.traversePreOrder(process: process)
    right?.traversePreOrder(process: process)
  }
  /// 后序遍历
  func traversePostOrder(process: (T) -> Void) {
    left?.traversePostOrder(process: process)
    right?.traversePostOrder(process: process)
    process(value)
  }
  
  // MARK: - 高阶函数
  
  func filter(isIncluded: (T) -> Bool) -> [T] {
    var a = [T]()
    if let left = left {
      a += left.filter(isIncluded: isIncluded)
    }
    if isIncluded(value) {
      a.append(value)
    }
    if let righ = right {
      a += righ.filter(isIncluded: isIncluded)
    }
    return a
  }
  
  func reduce<Result>(initial: Result, next: (Result, T) -> Result) -> Result {
    var a = initial
   
    if let left = left {
      a = left.reduce(initial: a, next: next)
    }
    
    a = next(a, value)
    
    if let right = right {
      a = right.reduce(initial: a, next: next)
    }
        
    return a
  }
  
  func map(formula: (T) -> T) -> [T] {
    var a = [T]()
    if let left = left {
      a += left.map(formula: formula)
    }
    a.append(formula(value))
    if let right = right {
      a += right.map(formula: formula)
    }
    return a
  }
  
  func toArray() -> [T] {
    return map {$0}
  }
  
  /// 删除
  private func reconnectParenTo(node: BinarySearchTree?) {
    if let parent = parent {
      if isLeftChild {
        parent.left = node
      }else {
        parent.right = node
      }
    }
    node?.parent = parent
  }
  
  func minimum() -> BinarySearchTree {
    var node = self
    while let next = node.left {
      node = next
    }
    return node
  }
  
  func maximum() -> BinarySearchTree {
    var node = self
    while let next = node.right {
      node = next
    }
    return node
  }
  
  func remove() -> BinarySearchTree? {
    let replacement: BinarySearchTree?
    
    // 找到能替换当前节点的点
    if let right = right {
      replacement = right.minimum()
    } else if let left = left {
      replacement = left.maximum()
    } else {
      replacement = nil
    }
    
    replacement?.remove()
    
    // 替换节点
    replacement?.right = right
    replacement?.left = left
    right?.parent = replacement
    left?.parent = replacement
    reconnectParenTo(node: replacement)
    
    // 清理当前节点
    parent = nil
    left = nil
    right = nil
    
    return replacement
  }
  
  func height() -> Int {
    // 根节点到最远的一个节点的高度
    if isLeaf {
      return 0
    } else {
      return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
    }
  }
  /// 深度
  func depth() -> Int {
    // 当前节点到根节点的高度
    var node = self
    var edges = 0
    while let parent = node.parent {
      node = parent
      edges += 1
    }
    return edges
  }
  /// 判断是否有效
  func isBST(minValue: T, maxValue: T) -> Bool {
    if value < minValue || value > maxValue { return false }
    let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
    let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
    return leftBST && rightBST
  }
}
extension BinarySearchTree: CustomStringConvertible {
  var description: String {
    var s = ""
    if let left = left {
      s += "(\(left.description)) <-"
    }
    s += "\(value)"
    if let right = right {
      s += "-> (\(right.description))"
    }
    return s
  }
}


//let tree = BinarySearchTree(array: [9,2,3,1,12,6,34,12])
//let tree = BinarySearchTree(array: [2,1,3])
//tree.search(key: 12)
//print(tree)
//
//tree.traverseInOrder{print($0)}

//print(tree.filter{$0 < 7})
//let sum = tree.reduce(initial: 0) { (l, r) -> Int in
//  print(r)
//  return l + r
//}
//print(sum)
//print(tree)
//tree.search(key: 1)?.depth()

//if let node1 = tree.search(key: 1) {
//  tree.isBST(minValue: Int.min, maxValue: Int.max)  // true
//  node1.insert(value: 100)                                 // EVIL!!!
//  tree.search(key: 100)                                  // nil
//  tree.isBST(minValue: Int.min, maxValue: Int.max)  // false
//}



var str = "Hello, playground"



// MARK: - 枚举实现

enum BinarySearchEnumTree<T: Comparable> {
  case Empty
  case Leaf(T)
  indirect case Node(BinarySearchEnumTree, T, BinarySearchEnumTree)
  
  static func create(array: [T]) -> BinarySearchEnumTree {
    precondition(array.count > 0)
    var tree = BinarySearchEnumTree.Leaf(array.first!)
    for item in array.dropFirst() {
      tree = tree.insert(newValue: item)
    }
    return tree
  }
  
  var count: Int {
    switch self {
    case .Empty:
      return 0
    case .Leaf: return 1
    case let .Node(left, _, right): return left.count + 1 + right.count
    }
  }
  
  var height: Int {
    switch self {
    case .Empty: return 0
    case .Leaf: return 1
    case let .Node(left, _, right): return 1 + max(left.height, right.height)
    }
  }
  
  func insert(newValue: T) -> BinarySearchEnumTree {
    switch self {
    case .Empty: return .Leaf(newValue)
    case .Leaf(let value):
      if newValue < value {
        return .Node(.Leaf(newValue), value, .Empty)
      } else {
        return .Node(.Empty, value, .Leaf(newValue))
      }
    case let .Node(left, value, right):
      if newValue < value {
        return .Node(left.insert(newValue: newValue), value, right)
      } else {
        return .Node(left, value, right.insert(newValue: newValue))
      }
    }
  }
  
  func search(key: T) -> BinarySearchEnumTree? {
    switch self {
    case .Empty:
      return nil
    case .Leaf(let value):
      return value == key ? self: nil
    case let .Node(left, value, right):
      if key < value {
        return left.search(key: key)
      } else if key > value {
        return right.search(key: key)
      } else {
        return self
      }
    }
  }
}
extension BinarySearchEnumTree: CustomDebugStringConvertible {
  var debugDescription: String {
    switch self {
    case .Empty:
      return ""
    case .Leaf(let value):
      return "\(value)"
    case let .Node(left, value, right):
      return "\(left.debugDescription) <- \(value) -> \(right.debugDescription)"
    }
    
  }
}


let tree = BinarySearchEnumTree.create(array: [2,3,4,1,5,9])

print(tree)





