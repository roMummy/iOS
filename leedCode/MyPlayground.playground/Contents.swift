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
    var max = -1
    var start = 0
    let end = A.count - 2 //通过数量减2来控制边缘
    while start < end {
        max = max > A[start] ? max : A[start]
        if max > A[start + 2] {
            return false
        }
        start += 1
    }
    return true
}
isIdealPermutation([0])

/** 238. Product of Array Except Self
 Given an array of n integers where n > 1, nums, return an array output such that output[i] is equal to the product of all the elements of nums except nums[i].
 
 Solve it without division and in O(n).
 
 For example, given [1,2,3,4], return [24,12,8,6].
 
 Follow up:
 Could you solve it with constant space complexity? (Note: The output array does not count as extra space for the purpose of space complexity analysis.)
 */
func productExceptSelf(_ nums: [Int]) -> [Int] {
    // 例子 [2,3,4,5]
    //  左边：1  2   2*3  2*3*4
    //  右边：3*4*5  4*5  5  1
    let n = nums.count
    var A: [Int] = []
    
    //左边
    var left = 1
    for i in 0..<n {
        if i > 0 {
            left *= nums[i - 1]
        }
        A.append(left)
    }
    //右边
    var right = 1
    for i in (0..<n).reversed() {
        if i < n - 1 {
            right *=  nums[i + 1]
        }
        A[i] *= right
    }
    return A
}
productExceptSelf([1,2,3,4])

/** 473. Matchsticks to Square
 Remember the story of Little Match Girl? By now, you know exactly what matchsticks the little match girl has, please find out a way you can make one square by using up all those matchsticks. You should not break any stick, but you can link them up, and each matchstick must be used exactly one time.
 
 Your input will be several matchsticks the girl has, represented with their stick length. Your output will either be true or false, to represent whether you could make one square using all the matchsticks the little match girl has.
 
 Example 1:
 Input: [1,1,2,2,2]
 Output: true
 
 Explanation: You can form a square with length 2, one side of the square came two sticks with length 1.
 Example 2:
 Input: [3,3,3,3,4]
 Output: false
 
 Explanation: You cannot find a way to form a square with all the matchsticks.
 Note:
 The length sum of the given matchsticks is in the range of 0 to 10^9.
 The length of the given matchstick array will not exceed 15.
 */
//import sys
//import time
//
//
//def dfs(nums, sums, index, tagert):
//"""
//:param nums: List[int]
//:param sums: List[int]
//:param index: int
//:return: bool
//:tagert: int
//"""
//if index == len(nums):
//#满足3个边都一样的就是正方形
//return sums[0] == sums[1] == sums[2]
//#递归 进行所有排列组合 满足条件就跳出递归
//for i in range(0, 3):
//#如果大于平均值就没有必要加入到子列表中
//if sums[i] + nums[index] > tagert:
//continue
//sums[i] += nums[index]
//if dfs(nums, sums, index + 1, tagert):
//return True
//sums[i] -= nums[index]
//return False
//
//
//def makesquare(nums):
//"""
//:type nums: List[int]
//:rtype: bool
//"""
//n = len(nums)
//sum = 0
//sums = 4 * [0]
//for item in nums:
//sum += item
//#其它情况全部排除
//if n < 4 or sum % 4 != 0 or sum == 0 or n > 10:
//return False
//return dfs(nums, sums, 0, sum/4)
//
//def times():
//start = time.clock()
//print(makesquare([1,1,2,2,2]))
//end = time.clock()
//print('Running time: %s Seconds' % (end - start))
//times()

/** 606. 根据二叉树创建字符串
 你需要采用前序遍历的方式，将一个二叉树转换成一个由括号和整数组成的字符串。
 
 空节点则用一对空括号 "()" 表示。而且你需要省略所有不影响字符串与原始二叉树之间的一对一映射关系的空括号对。
 
 示例 1:
 
 输入: 二叉树: [1,2,3,4]
 1
 /   \
 2     3
 /
 4
 
 输出: "1(2(4))(3)"
 
 解释: 原本将是“1(2(4)())(3())”，
 在你省略所有不必要的空括号对之后，
 它将是“1(2(4))(3)”。
 示例 2:
 
 输入: 二叉树: [1,2,3,null,4]
 1
 /   \
 2     3
 \
 4
 
 输出: "1(2()(4))(3)"
 
 解释: 和第一个示例相似，
 除了我们不能省略第一个对括号来中断输入和输出之间的一对一映射关系。
 */

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}
class Solution {
    func tree2str(_ t: TreeNode?) -> String {
        guard let tree = t else {
            return "";
        }
        var sum = "\(tree.val)"
        if tree.left != nil {
            sum += "(" + "\(tree2str(tree.left))" + ")"
        }else if tree.right != nil {
            sum += "()"
        }
        if tree.right != nil {
            sum += "(" + "\(tree2str(tree.right))" + ")"
        }
        return sum
    }
}

/** 500. 键盘行
 给定一个单词列表，只返回可以使用在键盘同一行的字母打印出来的单词。键盘如下图所示。
 
 
 American keyboard
 
 
 示例1:
 
 输入: ["Hello", "Alaska", "Dad", "Peace"]
 输出: ["Alaska", "Dad"]
 注意:
 
 你可以重复使用键盘上同一字符。
 你可以假设输入的字符串将只包含字母。
 */
func isLine(_ t: String) -> Bool {
    let lines = ["QWERTYUIOPqwertyuiop", "ASDFGHJKLasdfghjkl", "ZXCVBNMzxcvbnm"]
    for line in lines {
        var num = 0
        for tt in t {
            if line.contains(tt) {
//                print(tt)
                num += 1
            }
        }
        if num == t.characters.count {
            return true
        }
    }
    return false
}
func findWords(_ words: [String]) -> [String] {
    var n:[String] = []
    for word in words {
        if isLine(word) {
            n.append(word)
        }
    }
    return n
}
print(findWords(["Hello","Alaska","Dad","Peace"]))

/** 26. 从排序数组中删除重复项
 给定一个有序数组，你需要原地删除其中的重复内容，使每个元素只出现一次,并返回新的长度。
 
 不要另外定义一个数组，您必须通过用 O(1) 额外内存原地修改输入的数组来做到这一点。
 
 示例：
 
 给定数组: nums = [1,1,2],
 
 你的函数应该返回新长度 2, 并且原数组nums的前两个元素必须是1和2
 不需要理会新的数组长度后面的元素
 */
func removeDuplicates(_ nums: inout [Int]) -> Int {
    if nums.count <= 0 {
        return 0
    }
    var id = 1;
    for index in 1..<nums.count {
        if nums[index] != nums[index - 1] {
            nums[id] = nums[index]
            id += 1
        }
    }
    return id
}
var put = [0,0,1,2,2,4,4]
removeDuplicates(&put)

/** 80. 从排序阵列中删除重复 II
 “删除重复项目” 的进阶：
 如果重复最多被允许两次，又该怎么办呢？
 
 例如：
 给定排序数列 nums = [1,1,1,2,2,3]
 
 你的函数应该返回长度为 5，nums 的前五个元素是 1, 1, 2, 2 和 3。
 */

//func removeDuplicatesTwo(_ nums: inout [Int]) -> Int {
//    var id = 1
//    for i in 1..<nums.count {
//        if nums[i] == nums[i - 1] {
//
//        }
//    }
//}


/**
 将一个按照升序排列的有序数组，转换为一棵高度平衡二叉搜索树。
 
 本题中，一个高度平衡二叉树是指一个二叉树每个节点 的左右两个子树的高度差的绝对值不超过 1。
 
 示例:
 
 给定有序数组: [-10,-3,0,5,9],
 
 一个可能的答案是：[0,-3,9,-10,null,5]，它可以表示下面这个高度平衡二叉搜索树：
 
 0
 / \
 -3   9
 /   /
 -10  5

 */
/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.left = nil
 *         self.right = nil
 *     }
 * }
 */
class Solution1 {
    func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
        guard !nums.isEmpty else {
            return nil
        }
        
        return TreeNode.buildTree(nums, 0, nums.count - 1)
    }
}
extension TreeNode {
    public class func buildTree(_ nums: [Int], _ l: Int, _ r: Int) -> TreeNode? {
        if l > r {
            return nil
        }
        if l == r {
            return TreeNode(nums[l])
        }
        
        let mid = (l + r)/2
        let root = TreeNode(nums[mid])
        root.left = buildTree(nums, l, mid - 1)
        root.right = buildTree(nums, mid + 1, r)
        return root
    }
}
let solu = Solution1()
solu.sortedArrayToBST([-10,-3,0,5,9])


