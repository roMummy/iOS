//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
print("Hello")

/*
 *      错误处理
 */

///表示并抛出错误
enum VendingMachineError: Error {
    case invalidSelection
    case infufficientFunds(coinNeeded:Int)
    case outOfStock
}

//throw VendingMachineError.infufficientFunds(coinNeeded: 3)
print("123")
///错误处理 swift中的错误处理并不涉及解除调用栈

//用throwing函数传递错误 一个throwing函数可以在其内部抛出错误，并将错误传递到函数被调用时的作用域 只有throwing 函数可以传递错误

struct Item {
    var price:Int
    var count:Int
}

class VendingMachine {
    var inventory = [
        "Candy":Item(price: 12, count: -12),
        "Chips":Item(price: 10, count: 10),
        "Pize":Item(price: 11, count: 11),
        ]
    var coinsDeposited = 0
    func dispenseSnack(snack: String) {
        print(snack)
    }
    
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.infufficientFunds(coinNeeded: item.price - coinsDeposited)
        }
        //所有条件都满足
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print(name)
        
    }
    
}

let favoriteSnacks = [
    "Alice":"Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
//传递错误
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy"
    try vendingMachine.vend(itemNamed: snackName)
}

//传递错误
struct PurchasedSnack {
    
    let name: String
    init(name: String, vendingMachine:VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

//用Do-Catch处理错误

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alsice", vendingMachine: vendingMachine)
}catch VendingMachineError.invalidSelection {
    print("invalid")
}catch VendingMachineError.outOfStock {
    print("out")
}catch VendingMachineError.infufficientFunds(let coinNeeded) {
    print(coinNeeded)
}
//print("hello")
//使用结构体传递错误
do {
    try PurchasedSnack(name:"Pize" ,vendingMachine:vendingMachine)
}catch VendingMachineError.invalidSelection {
    print("invalid")
}catch VendingMachineError.outOfStock {
    print("out")
}catch VendingMachineError.infufficientFunds(let coinNeeded) {
    print(coinNeeded)
}

///将错误转换成可选值
//func someThrowingFunc() throws -> Int {
//    
//}
//let x = try? someThrowingFunc()
//let y:Int?
//do {
//    y = try someThrowingFunc()
//} catch {
//    y = nil
//}

///禁用错误传递 try! 这会把调用包装在一个不会有错误抛出的运行时断言中

///指定清理操作 使用defer 在即将离开当前代码块时执行一系列语句 执行语句不能包含控制转移语句 break或者return 而且是反着执行









