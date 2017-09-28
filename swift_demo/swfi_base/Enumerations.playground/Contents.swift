//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 *  枚举
 */

///枚举语法 枚举不会隐士的被赋值 它们的值类型就是枚举名称
enum SomeEnumeration {
    
}
enum CompassPoint {
    case north
    case south
    case east
    case west
}
enum Planet {
    case mercury, venus
}
var directionToHead = CompassPoint.west
directionToHead = .east

///使用switch语句匹配枚举值 switch必须穷举所有情况

directionToHead = .south
switch directionToHead {
case .north:
    print("north")
case .south:
    print("south")
case .east:
    print("east")
case .west:
    print("west")
}
//可以使用default来含盖其它的枚举值
let somePlanet = Planet.venus
switch somePlanet {
case .venus:
    print("venus")
default:
    print("other")
}

///关联值 在同一时间只能存储一个值
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var productBarcode = Barcode.upc(1, 12345, 12345, 3)
productBarcode = .qrCode("fafafsafa")

switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC:\(numberSystem),\(manufacturer),\(product),\(check)")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}

///原始值  “作为关联值的替代选择，枚举成员可以被默认值（称为原始值）预填充，这些原始值的类型必须相同”
enum ASCIIControlCharacter:Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

///原始值的隐士赋值
enum Planets:Int {
    case mercury, venus
}
//使用rawValue可以访问枚举成员的原始值
let earthsOrder = Planets.mercury.rawValue

///使用原始值初始化枚举实例
let possiblePlanet = Planets(rawValue:1)

///递归枚举 indirect
//enum ArithmeticExpression {
//    case number(Int)
//    indirect case addition(ArithmeticExpression, ArithmeticExpression)
//    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
//}
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
func evaluate(_ expression: ArithmeticExpression) ->Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
print(evaluate(product))




