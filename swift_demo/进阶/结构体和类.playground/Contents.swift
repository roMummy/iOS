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
//        print(screen)
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
print("screen1->\(screen)")

screen = translatedByTenTen(rectangle: screen)
print("screen2->\(screen)")

/// 改变偏移量
///
/// - Parameter rectangle: 传入一个结构体
func translateByTwentyTwenty(rectangle: inout Rectangle) {//将复制过来的值改变之后覆盖原来的值  只能对var使用
    
    rectangle.translate(by: Point(x: 20, y: 20))
}
translateByTwentyTwenty(rectangle: &screen)
//let immutableScreen = screen
//translateByTwentyTwen·ty(rectangle: &immutableScreen)

func +=(lhs: inout Point, rhs: Point) {//重写+= 运算符， 只改变左边的值
    lhs = lhs + rhs
}

//结构体并不意味着能做到线程安全
//for _ in 0..<Int.max {
//    let newScanner = BinaryScanner.init(data: "hi".data(using: .utf8)!)
//    DispatchQueue.global().async {
//        while let byte = newScanner.scanByte() {
//            print(byte)
//        }
//    }
//    while let byte = newScanner.scanByte() {
//        print(byte)
//    }
//}


///写时复制  结构体中的引用在结构体被改变的瞬间是唯一的话，就不会发生复制
var x = [1,2,3]
var y = x
x.append(5)
y.removeLast()
y
x

var input: [UInt8] = [0x0b, 0xad, 0xf0, 0x0d]
var other: [UInt8] = [0x0d]
var d = Data.init(bytes: input)
var e = d
d.append(contentsOf: other)
d
e

var f = NSMutableData(bytes: &input, length: input.count)
var g = f
f.append(&other, length: other.count)
f
g

//struct MyData {
//    fileprivate var _data: NSMutableData
//    var _dataForWriting: NSMutableData {
//        mutating get {
//            _data = _data.mutableCopy() as! NSMutableData
//            return _data
//        }
//    }
//    init(_ data: NSData) {
//        self._data = data.mutableCopy() as! NSMutableData
//    }
//    mutating func append(_ other: MyData) {
//        _dataForWriting.append(other._data as Data)
//    }
//}
//let theData = NSData(base64Encoded: "wAEP/w==", options: [])!
//var x1 = MyData(theData)
//let y1 = x1
//x1._data == y1._data
//x1.append(x1)
//print("x1\(x1)")
//print("y1\(y1)")
////复制两次需要
//var buffer = MyData(NSData())
//for _ in 0..<5 {
//    buffer.append(x1)
//}

///高效的写时复制
final class Box<A> {//将oc对象封装成swift对象
    var unbox: A
    init(_ value: A) {
        self.unbox = value
    }
}
var xx = Box(NSMutableData())
isKnownUniquelyReferenced(&xx)  //唯一存在
var yy = xx
isKnownUniquelyReferenced(&xx)
struct MyData {
    fileprivate var _data: Box<NSMutableData>
    var _dataForWriting: NSMutableData {
        mutating get {
            if !isKnownUniquelyReferenced(&_data) {//不是唯一的就进行复制
                _data = Box(_data.unbox.mutableCopy() as! NSMutableData)
                print("copy")
            }
            return _data.unbox
        }
    }
    init(_ data: NSData) {
        self._data = Box(data.mutableCopy() as! NSMutableData)
    }
    mutating func append(_ other: MyData) {
        _dataForWriting.append(other._data.unbox as Data)
    }
}

///写时复制的陷阱
final class Empty{}
struct COWStruct {
    var ref = Empty()
    
    mutating func change() -> String{
        if isKnownUniquelyReferenced(&ref) {
            return "No copy"
        }else {
            return "copy"
        }
    }
}
var s = COWStruct()
s.change()
//变量复制
var original = COWStruct()
var copy = original
original.change()
//将结构体放到数组中
var array = [COWStruct()]
array[0].change()

var otherArray = [COWStruct()]
var xOther = array[0]
xOther.change()

var dict = ["key": COWStruct()]
dict["key"]?.change()

struct ContainerStruct<A> {
    var storage: A
    subscript(s: String) -> A {
        get {return storage}
        set {storage = newValue}
    }
}
var dd = ContainerStruct(storage: COWStruct())
dd.storage.change()
dd["test"].change()

//测试
let someBytes = MyData(NSData(base64Encoded: "waep/w==", options: [])!)
var empty = MyData(NSData())
var emptyCopy = empty
for _ in 0..<5 {
    empty.append(someBytes)
}
empty
emptyCopy

enum Trade {
    case Buy(stock: String, amount: Int)
    case Sell(stock: String, amount: Int)
}
func trade(type: Trade){}
let trade = Trade.Buy(stock: "appl", amount: 500)
if case let Trade.Buy(_, _) = trade {
    
}

///类

//闭包和可变性
var i = 0
func uniqueInteger() -> Int{
    i += 1
    return i
}

let otherFunction: ()->Int = uniqueInteger

func uniqueIntegerProvider() -> () -> Int {
    var i = 0
    return{
        i += 1
        return i
    }
}
//封装成AnyIterator
func uniqueIntegerProvider() -> AnyIterator<Int> {
    var i = 0
    return AnyIterator{
        i += 1
        return i
    }
}
/*
 * Swift的结构体一般被存储在栈上，当结构体变量被一个函数闭合的时候，结构体会被存储到堆上
 */

///内存

//结构体不会发生循环引用，因为值类型只有一个持有者
struct Person {
    let name: String
    var parents: [Person]
}
var john = Person(name: "jshn", parents: [])
john.parents = [john]
john

//类的循环引用
class View {
    unowned var window: Window
    init(window: Window) {
        self.window = window
    }
    deinit {
        print("Deinit view")
    }
}
class Window {
    var rootView: View?
    deinit {
        print("Deinit Window")
    }
}
var myWindow: Window? = Window()
myWindow = nil
//会造成循环引用
var window: Window? = Window()
var view: View? = View(window: window!)
window?.rootView = view
view = nil
window = nil

///weak引用 不增加引用计数，并且当被引用的对象被释放时，将weak引用自身设置成nil

///unowned 引用 不持有引用的对象，但是却假定该引用会一直有效 swift在运行时为这个对象创建了另外一个引用计数，当所有的强引用消失时，对象将把它的资源释放掉 不过这个对象本身的内存将继续存在 僵尸内存


////闭包和内存

///结构体和类使用实践
//1.类 使用类会存在线性不安全
typealias USDCents = Int
class Account {
    var funds: USDCents = 0
    init(funds: USDCents) {
        self.funds = funds
    }
}
let alice = Account(funds: 100)
let bob = Account(funds: 0)

func transfer(amount: USDCents, soucre: Account, destination: Account) -> Bool {//转账
    guard soucre.funds >= amount else {
        return false
    }
    soucre.funds -= amount
    destination.funds += amount
    return true
}
transfer(amount: 50, soucre: alice, destination: bob)

//纯结构体 线程安全
struct Account_struct {
    var funds: USDCents
}
func transfer(amount: USDCents, soucre: Account_struct, destination: Account_struct) -> (source: Account_struct, destination: Account_struct)? {//转账
    guard soucre.funds >= amount else {
        return nil
    }
    var newSoucre = soucre
    var newDestination = destination
    newSoucre.funds -= amount
    newDestination.funds += amount
    
    return(newSoucre, newDestination)
}
let alice_struct = Account_struct(funds: 100)
let bob_struct = Account_struct(funds: 0)

if let (newAilce, newBob) = transfer(amount: 50, soucre: alice_struct, destination: bob_struct) {
    debugPrint(newAilce)
    debugPrint(newBob)
}

//3.inout 结构体 保留类的处理方式，函数类部没有并发影响
func transfer(amount: USDCents, soucre: inout Account_struct, destination: inout Account_struct) -> Bool{
    guard soucre.funds >= amount else {
        return false
    }
    soucre.funds -= amount
    destination.funds += amount
    return true
}
var alice_inout = Account_struct(funds: 100)
var bob_inout = Account_struct(funds: 0)
transfer(amount: 50, soucre: &alice_inout, destination: &bob_inout)

////闭包和内存 函数和闭包也是引用类型
let handle = FileHandle(forWritingAtPath: "out.html")
let request = URLRequest(url: URL.init(string: "http://www.objc.io")!)
URLSession.shared.dataTask(with: request) { (data, _, _) in
    guard let theData = data else {return}
    handle?.write(theData)
}.resume()
handle

///捕获列表 可以用来初始化新的变量



