import UIKit

// https://github.com/andyRon/swift-algorithm-club-cn/tree/master/Insertion%20Sort


var str = "Hello, playground"

/// 交换
//func insertionSort(array: [Int]) -> [Int] {
//  var a = array
//  for x in 1..<a.count {
//    var y = x
//    while y > 0 && a[y] < a[y - 1] {
//      a.swapAt(y-1, y)
//      y -= 1
//    }
//
//  }
//  return a
//}

/// 不交换位置
func insertionSort(array: [Int]) -> [Int] {
  var a = array
  for x in 1..<a.count {
    var y = x
    let temp = a[y]
    while y > 0 && temp < a[y - 1] {
      a[y] = a[y - 1]
      y -= 1
    }
    a[y] = temp
  }
  return a
}

/// 泛型化
func insertionSort<T>(array: [T],_ isOrderedBefore: (T,T) -> Bool) -> [T] {
  var a = array
  for x in 1..<a.count {
    var y = x
    let temp = a[y]
    while y > 0 && isOrderedBefore(temp, a[y - 1]) {
      a[y] = a[y - 1]
      y -= 1
    }
    a[y] = temp
  }
  return a
}


let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
insertionSort(array: list)
insertionSort(array: list, >)

