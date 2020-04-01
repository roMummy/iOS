import UIKit


// https://github.com/roMummy/swift-algorithm-club-cn/tree/master/Count%20Occurrences
var str = "Hello, playground"



func countOccurrencesOfKey(_ key: Int, inArray a: [Int]) -> Int {
  
  func left() -> Int {
    // 找到key连续出现的左边最小值
    var low = 0
    var high = a.count
    
    while low < high {
      let mid = low + (high - low)/2
      if a[mid] < key {
        low = mid + 1
      } else {
        high = mid
      }
    }
    print("low+\(low)")
    return low
  }
  
  func right() -> Int {
    // 找到key连续出现的右边最大值
    var low = 0
    var high = a.count
    
    while low < high {
      let mid = low + (high - low)/2
      if a[mid] > key {
        high = mid
      } else {
        low = mid + 1
      }
    }    
    return high
  }
  return right() - left()
}

let a = [ 0, 1, 1, 3, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
countOccurrencesOfKey(3, inArray: a)
