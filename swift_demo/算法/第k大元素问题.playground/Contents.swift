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


// 使用二分搜索+快速排序
func randomizedSelect<T: Comparable>(_ array: [T], order k: Int) -> T {
  var a = array

  func randomPivot<T: Comparable>(_ a: inout [T],_ low: Int,_ hight: Int) -> T {
    let randomIndex = randomx(min: low, max: hight)

    a.swapAt(randomIndex, hight)
    return a[hight]
  }

  func randomizedPartition<T: Comparable>(_ a: inout [T],_ low: Int,_ high: Int) -> Int {
    let pivot = randomPivot(&a, low, high)
    var i = low
    for j in low..<high {
      if a[j] <= pivot {
        a.swapAt(i, j)
        i += 1
      }
    }
    a.swapAt(i, high)
    return i
  }

  func randomziedSelect<T: Comparable>(_ a: inout [T],_ low: Int,_ high: Int,_ k: Int) -> T {
    if low < high {
      let p = randomizedPartition(&a, low, high)
      if k == p {
        return a[p]
      } else if k < p {
        return randomziedSelect(&a, low, p - 1, k)
      } else {
        return randomziedSelect(&a, p + 1, high, k)
      }
    } else {
      return a[low]
    }

  }

  precondition(a.count > 0)
  return randomziedSelect(&a, 0, a.count - 1, k)
}

func randomx(min: Int, max: Int) -> Int {
  return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

let a = [7, 92, 23, 9, -1, 0, 11, 6]

let p = randomizedSelect(a, order: 1)
print(p)
randomx(min: 0, max: 10)



