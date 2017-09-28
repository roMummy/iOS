//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 * 闭包 和oc中的bocks差不多 可以在代码中传递和使用 三种形式：
 * 一：全局函数是一个有名字但不会捕获任意值的闭包
 * 二：嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
 * 三：闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常亮值的匿名闭包
 * “闭包的函数体部分由关键字in引入”
 */

///闭包表达式 不能设定默认值，可变参数要放到参数列表的最后一位
let names = ["Chris", "Alex", "Ewa", "Barry"]
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 < s2
}
var reversedNames = names.sorted(by: backward)

//可变参数要放到参数列表的最后一位 一个可变的参数之前经常会导致参数给定的情况下将有模棱两可的内部参数匹配(例如,可变参数。都有相同的类型)。
//let testClosure = { (scores: Int..., name: String) -> String in
//    return "Happy"
//}
//let k = testClosure(1, 2, 3, "John")

reversedNames = names.sorted(by: {(s1: String, s2: String) -> Bool in return s1 > s2
})
//简化写法
reversedNames = names.sorted(by: {s1,s2 in return s1 > s2})

///单表达式闭包隐式返回
reversedNames = names.sorted(by: {s1,s2 in s1 > s2})

///参数名称缩写
reversedNames = names.sorted(by: {$0 > $1})

///运算符方法
reversedNames = names.sorted(by: >)

///尾随闭包
reversedNames = names.sorted(){$0 > $1}

let digitNames = [
 0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
 5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    }while number > 0
    return output
}
print(strings)

///值捕获  “闭包可以在其被定义的上下文中捕获常量或变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值”

func makelncrementer(forlncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makelncrementer(forlncrement: 10)
let incrementBySever = makelncrementer(forlncrement: 7)
incrementBySever()
incrementByTen()

///闭包是引用类型
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()

///逃逸闭包 一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行

var completionHandlers:[() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure:() -> Void) {
    closure()
}
class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure {
            self.x = 100
        }
        someFunctionWithNonescapingClosure {
            x = 200
        }
    }
    
}
let instance = SomeClass()
instance.doSomething()
print(instance.x)

completionHandlers.first?()
print(instance.x)

///自动闭包 是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值

var customerslnLine = ["Chris", "Alex", "Ewa", "Barry", "123"]
print(customerslnLine.count)

let customerProovider = {customerslnLine.remove(at: 0)}
print(customerslnLine.count)

print("Now serving \(customerProovider())")
print(customerslnLine.count)

func serve(customer customerProvider:() -> String) {
    print(customerProovider())
}
serve(customer: {customerslnLine.remove(at: 0)})
//@autoclosure 将传入的东西自动转换成闭包
func serve(customer customerProvider:@autoclosure() -> String) {
    print("now \(customerProovider())")
}
serve(customer: customerslnLine.remove(at: 0))
//自动闭包可以逃逸

var customerProviders:[() -> String] = []
func collectCustomerProviders(_ customerProvider:@autoclosure @escaping () -> String) {
    customerProviders.append(customerProovider)
}
collectCustomerProviders(customerslnLine.remove(at: 0))
collectCustomerProviders(customerslnLine.remove(at: 0))

print(customerProviders.count)
for customerProvider in customerProviders {
    print(customerProovider())
}

