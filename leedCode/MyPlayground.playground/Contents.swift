//: Playground - noun: a place where people can play

import UIKit

/** 167. 两数之和 II - 输入有序数组
 给定一个已按照升序排列 的有序数组，找到两个数使得它们相加之和等于目标数。
 
 函数应该返回这两个下标值 index1 和 index2，其中 index1 必须小于 index2。请注意，返回的下标值（index1 和 index2）不是从零开始的。
 
 你可以假设每个输入都只有一个解决方案，而且你不会重复使用相同的元素。
 
 输入：数组 = {2, 7, 11, 15}, 目标数 = 9
 输出：index1 = 1, index2 = 2
 */

func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    var start = 0
    var end = numbers.count - 1
    while start < end {
        if numbers[start] + numbers[end] == target { break }
        else if numbers[start] + numbers[end] < target { start += 1}
        else {end -= 1}
    }
    return [start + 1, end + 1]
}
twoSum([-3, 3, 4, 90], 0)


/** 775. Global and Local Inversions
 We have some permutation A of [0, 1, ..., N - 1], where N is the length of A.
 
 The number of (global) inversions is the number of i < j with 0 <= i < j < N and A[i] > A[j].
 
 The number of local inversions is the number of i with 0 <= i < N and A[i] > A[i+1].
 
 Return true if and only if the number of global inversions is equal to the number of local inversions.
 
 Example 1:
 
 Input: A = [1,0,2]
 Output: true
 Explanation: There is 1 global inversion, and 1 local inversion.
 Example 2:
 
 Input: A = [1,2,0]
 Output: false
 Explanation: There are 2 global inversions, and 1 local inversion.
 Note:
 
 A will be a permutation of [0, 1, ..., A.length - 1].
 A will have length in range [1, 5000].
 The time limit for this problem has been reduced.

 */

func isIdealPermutation(_ A: [Int]) -> Bool {
    
}

