//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
///结构体和类的不同点
//1.结构体是值类型，类是引用类型 
//2.结构体可以被直接持有及访问，类的实例只能通过引用来间接的访问。结构体的持有者是唯一的，类可以拥有多个持有者
//3.类可以通过继承来共享，结构体是不能被继承的

///值类型 没有生命周期的就是结构体；结构体只有一个持有者，不可能造成引用循环；

///可变性
//let mutableArray: NSMutableArray = [1,2,3]
//for _ in mutableArray {
//    mutableArray.removeLastObject() 崩溃
//}

var mutableArray = [1,2,3]
for _ in mutableArray {
    mutableArray.removeLast() //不会崩溃，因为持有了数组的一个本地独立的复制
}

class BinaryScanner {
    var posttion: Int
    let data: Data
    init(data: Data) {
        self.posttion = 0
        self.data = data
    }
    //扫描字节
    func scanByte() -> UInt8? {
        guard posttion < data.endIndex  else {
            return nil
        }
        self.posttion += 1
        return data[self.posttion - 1]
    }
    //打印扫描的字符
    func scanRemainingBytes(scanner: BinaryScanner) {
        while let byte = scanner.scanByte() {
            print(byte)
        }
    }
}

let scanner = BinaryScanner(data: "hi".data(using: .utf8)!)
scanner.scanRemainingBytes(scanner: scanner)

//会造成竞太条件 造成数组越界
//for _ in 0..<Int.max {
//    let newScanner = BinaryScanner(data: "hi".data(using: .utf8)!)
//    DispatchQueue.global().async {
//        newScanner.scanRemainingBytes(scanner: newScanner)
//    }
//    newScanner.scanRemainingBytes(scanner: newScanner)
//
//}

///结构体  所有的结构体只有一个持有者
struct Point {
    var x: Int
    var y: Int
}
extension Point {
    static let origin = Point(x: 0, y: 0) //静态属性
}
struct Size {
    var width: Int
    var height: Int
}
struct Rectangle {
    var origin: Point
    var size: Size
    init(x: Int = 0, y: Int = 0, width: Int, height: Int) {
        origin = Point(x: x, y: y)
        size = Size(width: width, height: height)
    }
}

//Rectangle(origin: Point.origin, size: Size(width: 10, height: 10))
var screen = Rectangle(width: 100, height: 100) {
    
    didSet {//每当screen改变时 都会调用
        print(screen)
    }
}

//screen.origin = Point.origin
var screens = [Rectangle.init(width: 100, height: 100)]{//数组是结构体也需要改变
    
    didSet {
        
        print("array change")
    }
}
screens[0].origin.x = 200

func +(lhs: Point, rhs: Point) -> Point {//重载+操作符
    
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
screen.origin + Point(x: 10, y: 10)

extension Rectangle {
    
    mutating func translate(by offset: Point) {//只能var进行调用
        origin = origin + offset
    }
    
    func translated(by offset: Point) -> Rectangle {// 不可变版本
        var copy = self
        copy.translate(by: offset)
        return copy
    }
}
let otherScreen = screen
//otherScreen.translate(by: Point(x: 0, y: 0))

func translatedByTenTen(rectangle: Rectangle) -> Rectangle {
    
    return rectangle.translated(by: Point(x: 10, y: 10))
}
print(screen)

screen = translatedByTenTen(rectangle: screen)

/// 改变偏移量
///
/// - Parameter rectangle: 传入一个结构体
func translateByTwentyTwenty(rectangle: inout Rectangle) {//将复制过来的值改变之后覆盖原来的值  只能对var使用
    
    rectangle.translate(by: Point(x: 20, y: 20))
}
translateByTwentyTwenty(rectangle: &screen)
//let immutableScreen = screen
//translateByTwentyTwenty(rectangle: &immutableScreen)


