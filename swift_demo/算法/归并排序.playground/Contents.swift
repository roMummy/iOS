import UIKit


// https://github.com/roMummy/swift-algorithm-club-cn/tree/master/Merge%20Sort


/// 从上到下
func mergeSort(_ arr: [Int]) -> [Int] {
  guard arr.count > 1 else {
    return arr
  }
  
  let midIndex = arr.count / 2
  let leftArray = mergeSort(Array(arr[0..<midIndex]))
  let rightArray = mergeSort(Array(arr[midIndex..<arr.count]))
  
  return merge(leftPile: leftArray, rightPile: rightArray)
}

func merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
  var leftIndex = 0
  var rightIndex = 0
  
  var orderedPile: [Int] = []
  
  while leftIndex < leftPile.count && rightIndex < rightPile.count {
    if leftPile[leftIndex] < rightPile[rightIndex] {
      orderedPile.append(leftPile[leftIndex])
      leftIndex += 1
    } else if leftPile[leftIndex] > rightPile[rightIndex] {
      orderedPile.append(rightPile[rightIndex])
      rightIndex += 1
    } else {
      orderedPile.append(leftPile[leftIndex])
      leftIndex += 1
      orderedPile.append(rightPile[rightIndex])
      rightIndex += 1
    }
  }
  
  while leftIndex < leftPile.count {
    orderedPile.append(leftPile[leftIndex])
    leftIndex += 1
  }
  
  while rightIndex < rightPile.count {
    orderedPile.append(rightPile[rightIndex])
    rightIndex += 1
  }
  
  return orderedPile
}


/// 从下到上
func mergeSortBottomUp<T>(a: [T],_ isOrderedBefore:(T, T) -> Bool) -> [T] {
  let n = a.count
  
  var z = [a, a]
  var d = 0
  
  var width = 1
  while width < n {
    var i = 0
    while i < n {
      var j = i
      var l = i
      var r = i + width
      
      let lmax = min(l + width, n)
      let rmax = min(r + width, n)
      
      while l < lmax && r < rmax {
        if isOrderedBefore(z[d][l], z[d][r]) {
          z[1 - d][j] = z[d][l]
          l += 1
        } else {
          z[1 - d][j] = z[d][r]
          r += 1
        }
        j += 1
      }
      
      while l < lmax {
        z[1 - d][j] = z[d][l]
        l += 1
        j += 1
      }
      while r < rmax {
        z[1 - d][j] = z[d][r]
        j += 1
        r += 1
      }

      i += width*2
    }
    
    width *= 2
    d = 1 - d
    print("----\(d)")
  }
  return z[d]
}

let array = [2, 1, 5, 4, 9, 4, 6, 13, 0, 1]

mergeSortBottomUp(a: array, <)

var str = "Hello, playground"

