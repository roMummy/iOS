//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      扩展 和oc的分类相似，不同的是swift中扩展没有名字，扩展可以为一个类型添加新的功能，但是不能重写已有的功能
 */

///计算型属性 不能添加存储型属性，也不可以为已有属性添加属性观察器

extension Double {
    var km:Double { return self * 1_000.0}
    var m:Double { return self}
}
let onelnch = 12.8.km
print(onelnch)

///构造器 扩展能为类添加新的遍历构造器，但是不能为类添加新的指定构造器或析构器

struct Size {
    var width = 0.0,height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect{
    var origin = Point()
    var size = Size()
}
let defaultRect = Rect()
//let memberwiseRect = Rect(origin:Point(x:2, y:2), size:Size(width:5, height:5))

//扩展Rect的构造器
extension Rect {
    init(center:Point, size:Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin:Point(x:originX, y:originY), size:size)
    }
}
let centerRect = Rect(center:Point(x:4, y:4), size:Size(width:3, height:3))
let memberwiseRect = Rect(origin:Point(x:2, y:2), size:Size(width:5, height:5))
print(memberwiseRect)
print(centerRect)

///方法

extension Int {
    func repetitions(task:() -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

3.repetitions {
    print("123")
}

//可变实例方法 结构体和枚举需要加上mutating
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 2
someInt.square()
print(someInt)

///下标

extension Int {
    subscript(digitIndex:Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
123123[0]
131313[3]

///嵌套类型
extension Int {
    enum Kind {
        case Negative, Zero, Positive
    }
    var kind:Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
    
}

func printIntKinds(_ numbers:[Int]) {
    for number in numbers {
        switch number.kind {
        case .Negative:
            print("+")
        case .Zero:
            print("Zero")
        default:
            print("-")
        }
    }
}
printIntKinds([12,-12,0,123,123,0,123,-12])

