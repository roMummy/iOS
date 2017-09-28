//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//传入一个数组 返回最大最小值
func minMax(array:[Int])->(min:Int, max:Int)? {
    if array.isEmpty {
        return nil
    }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        }else if value > currentMax {
            currentMax = value
        }
    }
    return(currentMin, currentMax)
}
if let bounds = minMax(array: [3,12,41,51,-12]){
    print("min is \(bounds.min),max is \(bounds.max)")
}

//参数标签
func greet(person: String, from hometown:String)-> String {
    return "Hello \(person)! Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))

//忽略参数标签
func someFunction(_ fistParameterName:Int, secondParameterName:Int) {
    // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
}
someFunction(1, secondParameterName: 2)

//默认参数值
func someFunction(parameterWithoutDefault: Int,parameterWithDefault: Int = 12){
    // 如果你在调用时候不传第二个参数，parameterWithDefault 会值为 12 传入到函数体中。”
}
someFunction(parameterWithoutDefault: 1)

//可变参数 一个函数最多只能拥有一个可变参数
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1,2,2,3,4)

/*输入输出参数 可以直接修改传入参数的值
 *“你只能传递变量给输入输出参数。你不能传入常量或者字面量，因为这些量是不能被修改的。当传入的参数作为输入输出参数时，需要在参数名前加 & 符，表示这个值可以被函数修改”
 */
func swapTwolnts(_ a:inout Int,_ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwolnts(&someInt, &anotherInt)
print("\(someInt):\(anotherInt)")

//是用函数类型
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

var mathFunction: (Int,Int) -> Int = addTwoInts //将函数赋值给变量
print(mathFunction(1,2))

///函数类型作为参数类型
func printMathResult(_ mathFunctionn:(Int,Int) -> Int, _ a:Int,_ b: Int){
    print(mathFunction(a,b))
}
printMathResult(addTwoInts, 3, 5)

///函数类型作为返回类型
//func stepForward(_ input: Int) -> Int{
//    return input + 1
//}
//func stepBackward(_ input: Int) -> Int {
//    return input - 1
//}
//func chooseStepFunction(backward: Bool) -> (Int) -> Int {
//    return backward ? stepBackward: stepForward
//}
//var currentValue = 3
//let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
//
//while currentValue != 0 {
//    print("\(currentValue)....")
//    currentValue = moveNearerToZero(currentValue)
//}
//print("zero!")

///嵌套函数
func chooseStepFunction(backword: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int {
        return input + 1
    }
    func stepBackward(input: Int) -> Int {
        return input - 1
    }
    return backword ? stepBackward : stepForward
}
var currentValue = -4
let moveNearerToZero = chooseStepFunction(backword: currentValue > 0)
while currentValue != 0 {
    print("\(currentValue)...")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")


		