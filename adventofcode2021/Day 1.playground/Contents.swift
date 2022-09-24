import UIKit

// from: https://adventofcode.com/2021/day/1
var greeting = "Hello, playground"
guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
    fatalError("获取资源失败")
}

guard let inputStr = try? String.init(contentsOfFile: path) else {
    fatalError("转换string失败")
}
let input = inputStr.split(separator: "\n").compactMap{Int($0)}

//////////// Part 1
//var count = 0
//for i in 0..<input.count {
//    if i == 0 {
//        continue
//    }
//    if input[i] > input[i - 1] {
//        count += 1
//    }
//}
//print(count)

//////////// Part 2
var count = 0
for i in 0..<input.count {
    if i == 0 {
        continue
    }
    guard i + 2 < input.count else {
        continue
    }
    
    if input[i + 2] > input[i - 1] {
        count += 1
    }
}
print(count)
