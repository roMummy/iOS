import UIKit


// https://github.com/andyRon/swift-algorithm-club-cn/tree/master/Binary%20Search


/// 递归
func binarySearch<T: Comparable>(_ a: [T], key: T, range: Range<Int>) -> Int? {
  //upperBound总是比最后一个元素的索引多一。
  guard range.lowerBound < range.upperBound else {
    return nil
  }
  // 二分搜索许多执行会计算 midIndex = (lowerBound + upperBound) / 2。这包含了一个在非常大的数组中会出现的细微bug，因为lowerBound + upperBound可能溢出一个整数可以容纳的最大数。这种情况不太可能发生在64位CPU上，但绝对可能在32位机器上发生。
  let midIndex = range.lowerBound + (range.upperBound - range.lowerBound)/2
  
  if a[midIndex] > key {
    return binarySearch(a, key: key, range: range.lowerBound..<midIndex)
  }
  if a[midIndex] < key {
    return binarySearch(a, key: key, range: midIndex + 1..<range.upperBound)
  }
  return midIndex
}

/// 迭代
func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
  var lower = 0
  var upper = a.count
  while lower < upper {
    let midIndex = lower + (upper - lower)/2
    if a[midIndex] == key {
      return midIndex
    }else if a[midIndex] > key {
      // left
      upper = midIndex 
    }else {
      // right
      lower = midIndex + 1
    }
  }
  return nil
}

let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 19, range: 0..<numbers.count)

binarySearch(numbers, key: 19)

var str = "Hello, playground"




