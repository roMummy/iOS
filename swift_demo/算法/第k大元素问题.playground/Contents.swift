import UIKit


// https://github.com/roMummy/swift-algorithm-club-cn/tree/master/Kth%20Largest%20Element
var str = "Hello, playground"

func kthLargest(a: [Int], k: Int) -> Int? {
  let len = a.count
  if k > 0 && k <= len {
    let sorted = a.sorted()
    return sorted[len - k]
  } else {
    return nil
  }
}





