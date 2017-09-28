//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let finalSquare:Int = 25
var board = [Int](repeatElement(0, count: finalSquare + 1))
board[3] = 8
board[6] = 11
board[9] = 9
board[10] = 2
board[14] = -10
board[19] = -11
board[22] = -2
board[24] = -8

var square:Int = 0
var diceRoll = 0
//while square < finalSquare {
//    //投骰子
//    diceRoll += 1
//    if diceRoll == 7 {
//        diceRoll = 1
//    }
//    //移动点数
//    square += diceRoll
//    if square < board.count {
//        square += board[square]
//    }
//}
repeat {
    //顺着梯子爬或者滑下去
    square += board[square]
    //投骰子
    diceRoll += 1
    if diceRoll == 7 {
        diceRoll = 1
    }
    //移动点数
    square += diceRoll
}while square < finalSquare
    print("the end")
/*
 * 元组
 */
let somePoint = (1,1)
switch somePoint {
case (0,0):
    print("origin")
case (_,0):
    print("x-axis")
case (0,_):
    print("y-axis")
case (-2...2,-2...2):
    print("box")
default: break
}
//值绑定
let anotherPoint = (2,2)
switch anotherPoint {
case (let x, 0):
    print("x")
case (0, let y):
    print("y")
default:
    print("x,y")
}
//Where
let yetAnotherPoint = (1,-1)
switch yetAnotherPoint {
case let (x,y) where x == y:
    print("x==y")
case let (x,y) where x == -y:
    print("x==-y")
default:
    print("x,y")
}

//continue 停止本次循环
//guard 条件满足就执行后面的代码 条件不满足就执行else里面的代码
func greet(person:[String:String]) {
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)")
    guard let location = person["location"] else {
        print("near you")
        return
    }
    print("\(location)")
}
greet(person: ["name":"john"])

//检查api可用性
if #available(iOS 10,macOS 10.12, *) {

    // 在 iOS 使用 iOS 10 的 API, 在 macOS 使用 macOS 10.12 的 API
} else {
    // 使用先前版本的 iOS 和 macOS 的 API
}
		