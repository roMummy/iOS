//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *   属性
 */

///存储属性 存储在特定类或结构体实例里的一个常量或变量
struct FixedLengthRange {
    var firstValue:Int
    let length:Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6

///常量结构体的存储属性 不能改变变量属性的值
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length:4)
//rangeOfFourItems.firstValue = 3

///延迟存储属性 必须将延迟存储属性声明成var变量  如果一个被标记为lazy的属性在没有初始化时就同时被多个线程访问，则无法保证该属性只会被初始化一次
class Datalmporter {
    var fileName = "data.text"
}
class DataManager {
    lazy var importer = Datalmporter()
    var data = [String]()
}

let mannager = DataManager()
mannager.data.append("some data")
mannager.data.append("some more data")

///计算属性
struct Point {
    var x = 0.0,y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y:centerY)
        }
        set (newCenter){
            origin.x = newCenter.x - (size.width/2)
            origin.y = newCenter.y - (size.height/2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y:0.0), size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y:15.0)
print(square.origin.x + square.origin.y)

//只读计算属性 可以去掉get关键字和花括号
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume:Double {
        
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height:5.0, depth:2.0)
print(fourByFiveByTwo.volume)

///属性观察器
class StepCounter {
    
    var totalSteps:Int = 0 {
        willSet {
            print(newValue)
        }
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
stepCounter.totalSteps = 360

///全局变量和局部变量
//全局的常量或变量都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记lazy修饰符。
//局部范围的常量或变量从不延迟计算。

///类型属性
//跟实例的存储型属性不同，必须给存储型类型属性指定默认值，因为类型本身没有构造器，也就无法在初始化过程中使用构造器给类型属性赋值。
//存储型类型属性是延迟初始化的，它们只有在第一次被访问的时候才会被初始化。即使它们被多个线程同时访问，系统也保证只会对其进行一次初始化，并且不需要对其使用 lazy 修饰符。

struct SomeStructure {
    static var storedTypeProperty = "Some value"
    static var computedTypeProperty:Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value"
    static var computedTypeProperty:Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value"
    static var computedTypeProperty:Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
print(SomeStructure.storedTypeProperty)
SomeStructure.storedTypeProperty = "anther value"
print(SomeStructure.storedTypeProperty)
print(SomeEnumeration.computedTypeProperty)

//模拟声音
struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel:Int = 0 {
        didSet {
            //限制音量的最大值
            if currentLevel > AudioChannel.thresholdLevel {
                currentLevel  = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                //存储当前音量当做最大音量
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
    
}
var leftChannal = AudioChannel()
var rightChannal = AudioChannel()

leftChannal.currentLevel = 7
rightChannal.currentLevel = 11
print(rightChannal.currentLevel)
print(AudioChannel.maxInputLevelForAllChannels)


