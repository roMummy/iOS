//: Playground - noun: a place where people can play

import UIKit
///解决异步操作不执行的问题
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

///随机数生成
//这种方法在32位机器上可能会造成数组越界，5s以下机型
let diceFaceCount = 6
let randomRoll = Int(arc4random())%diceFaceCount + 1
print(randomRoll)

//改良版本
let diceFaceCount2: UInt32 = 6
let randomRoll2 = Int(arc4random_uniform(diceFaceCount2)) + 1
print(randomRoll2)

//设计random函数
func random(in range: Range<Int>) -> Int {

    let count = UInt32(range.upperBound - range.lowerBound)
    return Int(arc4random_uniform(count)) + range.lowerBound
}
for _ in 0...100 {
    let range = Range<Int>(1...6)
//    print(random(in: range))
}

///print 和 debugPrint
class MyClass {
    var num: Int
    init() {
        num = 1
    }
}
//CustomStringConvertible 重写打印消息
extension MyClass: CustomStringConvertible {
    var description: String {
        return "num:\(num)"
    }
}
let obj = MyClass()
print(obj)

///错误和异常处理
enum LoginError: Error {
    case UserNotFound, UserPasswdNotMatch
}
func login(user: String, passwd: String) throws {
    let users = ["tw":"123456"]
    if !users.keys.contains(user) {
        throw LoginError.UserNotFound
    }
    if users[user] != passwd {
        throw LoginError.UserPasswdNotMatch
    }
    print("登录成功")
}

//测试
do {
    try login(user: "tww", passwd: "123456")
} catch let error as LoginError {
    switch error {
    case .UserNotFound:
        print("UserNotFound")
    case .UserPasswdNotMatch:
        print("UserPasswdNotMatch")
    }
}
//异步的异常处理
enum Result {
    case Success(String)
    case Error(NSError)
}
//func doSomethingParam(param: AnyObject) -> Result {
//    if success {
//        return Result.Success("成功")
//    }else {
//        let error = NSError(domain: "errorDomain", code: 1, userInfo: nil)
//        return Result.Error(error)
//    }
//}

//rethrows throws的子类 用来重载被标记为throws的方法和参数
enum E: Error {
    case Negative
}
func methodThrows(num: Int) throws {
    if num < 0 {
        print("异常")
        throw E.Negative
    }
    print("没异常")
}
func methodRethrows(num: Int, f: (Int) throws -> ()) rethrows {
    try f(num)
}
do {
    try methodRethrows(num: 1, f: methodThrows)
} catch _ {
}

///断言 只有在debug编译的时候有效，在运行时是不被编译执行的
func convertToKelvin(_ celsius: Double) -> Double {
    assert(celsius < -273.15, "输入的温度不能小于绝对零度")
    return celsius + 273.15
}
let tooCold = convertToKelvin(-300)

///fatalError 直接终止程序
//@noreture 表示这个函数不在需要返回值
enum MyEnum {
    case value1,value2,value3
}
func check(someValue: MyEnum) -> String {
    switch someValue {
    case .value1:
        return "ok"
    default:
        fatalError("should not show")//没有返回也能通过编译
    }
}

class MyClasss {
    func methodSubclass() {
        fatalError("这个方法必须在子类中重写")
    }
}
class YourClass: MyClasss {
    override func methodSubclass() {
        print("子类实现了这个方法")
    }
}
class TheirClass: MyClasss {
    func someMethod() {
    }
}
YourClass().methodSubclass()
//TheirClass().methodSubclass()

///可视化
let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
label.backgroundColor = .white
label.font = UIFont.systemFont(ofSize: 32)
label.text = "Hello world"
label.textAlignment = .center
PlaygroundPage.current.liveView = label

///数学
//NaN 不存在的数
let num = Double.nan
if num == num {
    print("num is \(num)")
}else {
    print("NaN")
}

///NSNull
let jsonValue = NSNull()
if let string = jsonValue as? String {
    print(string)
}else {
    print("不能解析")
}

///Log输出
func printLog<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)],\(method):\(message)")
    #endif
}

printLog("123")

///溢出 &+ 溢出加 &- &* &/ &% 不会使程序崩溃
var max = Int.max
max = max &+ 1

///权限管理
class MyyClass {
    //可以外部读取但是不能修改
    private(set) var name: String?
}

///@dynamic 在swift中使用@NSManaged替代
class MyModel {
    @NSManaged var title: String
}

///泛型扩展 对于特定的某个方法可以添加除开T以外的泛型符号
extension Array {
    var random: Element? {
        return self.count != 0 ?
        self[Int(arc4random_uniform(UInt32(self.count)))] :
        nil
    }
    func appendRandomDescription<U: CustomStringConvertible>(_ input: U) -> String {
        if let element = self.random {
            return "\(element)" + input.description
        }else {
            return "empty array"
        }
    }
}
let lll = ["111", "222", "333"]
lll.random
lll.appendRandomDescription(lll.random!)

///循环枚举
enum Suit: String {
    case s = "♠️"
    case h = "♥️"
    case c = "♣️"
    case d = "♦️"
}
enum Rank: Int, CustomStringConvertible {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    var description: String {
        switch self {
        case .ace:
            return "A"
        case .jack:
            return "J"
        case .queen:
            return "Q"
        case .king:
            return "K"
        default:
            return String(self.rawValue)
        }
    }
}

protocol EnumeratableEnum {
    static var allValues: [Self] {get}
}
extension Suit: EnumeratableEnum {
    static var allValues: [Suit] {
        return [.s, .h, .c, .d]
    }
}
extension Rank: EnumeratableEnum {
    static var allValues: [Rank] {
        return [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
    }
}

for suit in Suit.allValues {
    for rank in Rank.allValues {
        print("\(suit.rawValue)\(rank)")
    }
}


///尾递归
//一般的递归 数大了会溢出
func sum(_ n: UInt) -> UInt {
    if n == 0 {
        return 0
    }
    return n + sum(n - 1)
}
sum(4)
//尾递归
func tailSum(_ n: UInt) -> UInt {
    func sumInt(_ n: UInt, current: UInt) -> UInt {
        if n == 0 {
            return current
        }else {
            return sumInt(n - 1, current: current + 1)
        }
    }
    return sumInt(n, current: 0)
}

tailSum(4)
tailSum(1000000)

