import UIKit

// https://github.com/roMummy/swift-algorithm-club-cn/tree/master/Boyer-Moore-Horspool

var str = "Hello, playground"


extension String {
  /// 暴力方法
//  func index(of pattern: String) -> Index? {
//    for i in self.indices {
//
//      var j = i
//      var found = true
//      for p in pattern.indices {
//        guard j != endIndex, self[j] == pattern[p] else {found = false; break}
//        j = index(after: j)
//      }
//      if found {
//        return i
//      }
//    }
//    return nil
//  }
  
  /// boyer-moore
  func index(of pattern: String) -> Index? {
    let patternLength = pattern.count
    guard patternLength > 0, patternLength <= count else {
      return nil
    }
    
    let skipTable = pattern.skipTable
    let lastChar = pattern.last!
    
    var i = index(startIndex, offsetBy: patternLength - 1)
    
    while i < endIndex {
      let c = self[i]
      
      if c == lastChar {
        if let k = match(from: i, with: pattern) {return k}
        i = index(after: i)
      } else {
        // 匹配失败 通过跳转表跳转到具体的位置，如果超过直接到末尾
        i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
      }
    }
    
    return nil
  }
  
  fileprivate var skipTable: [Character: Int] {
    var skipTable: [Character: Int] = [:]
    for (i, c) in enumerated() {
      skipTable[c] = count - i - 1
    }
    return skipTable
  }
  
  fileprivate func match(from currentIndex: Index, with pattern: String) -> Index? {
    if currentIndex < startIndex {return nil}
    if currentIndex >= endIndex {return nil}
    
    if self[currentIndex] != pattern.last {return nil}
    
    if pattern.count == 1 && self[currentIndex] == pattern.last {
      return currentIndex
    }
    
    return match(from: index(before: currentIndex), with: "\(pattern.dropLast())")
  }
}

let sourceString = "Hello World!"
let pattern = "World"
let index = sourceString.index(of: pattern)
//print(sourceString[index!])
