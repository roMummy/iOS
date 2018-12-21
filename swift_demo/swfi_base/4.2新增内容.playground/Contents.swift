import UIKit

var str = "Hello, playground"

/// 1.新增枚举遍历协议

enum Beverage: CaseIterable {
    case coffee, tea, juice
}

let numberOfChoices = Beverage.allCases.count

print(numberOfChoices)

for beverage in Beverage.allCases {
    print(beverage)
}
/// 2.添加了 #error #warning 声明

//#error("错误警告")
//#warning("警告⚠️")

let a:Double = 5.3
print(a)

