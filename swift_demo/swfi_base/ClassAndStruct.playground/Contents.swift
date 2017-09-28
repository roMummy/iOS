//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
///类和结构体对比  “结构体总是通过被复制的方式在代码中传递，不使用引用计数。”

struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name:String?
}

let someResolution = Resolution()
let someVideoModel = VideoMode()

///结构体类型的成员逐一构造器 类没有
let vga = Resolution(width:11, height:22)

///结构体和枚举是值类型 它们的实例，以及实例中所包含的任意值类型，在代码中传递的时候都会被复制
let hd = Resolution(width: 1920, height: 1080)
///类是引用类型 用的是本身，不会被拷贝
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty

///恒等运算符
if tenEighty === alsoTenEighty {
    print("123")
}

///“Swift 中，许多基本类型，诸如String，Array和Dictionary类型均以结构体的形式实现。这意味着被赋值给新的常量或变量，或者被传入函数或方法中时，它们的值会被拷贝。
///Objective-C 中NSString，NSArray和NSDictionary类型均以类的形式实现，而并非结构体。它们在被赋值或者被传入函数或方法时，不会发生值拷贝，而是传递现有实例的引用。

