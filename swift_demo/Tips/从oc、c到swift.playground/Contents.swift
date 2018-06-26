//: Playground - noun: a place where people can play

import UIKit
import AudioToolbox

var str = "Hello, playground"
///Selector
//如果想要在oc中使用swift类型或者方法，需要在单个方法前面添加@objc
//如果想要整个类型可以使用的话，在类型名前添加@objcMembers
class A {
    @objc func commonFunc() {
    }
    @objc func commonFunc(input: Int) -> Int {
        return input
    }
//    let method1 = #selector(commonFunc as ()->())
//    let method2 = #selector(commonFunc(input:))
}

///实例方法的动态调用
class MyClass {
    func method(number: Int) -> Int {
        return number + 1
    }
    class func method(number: Int) -> Int {
        return number
    }
}
//普通调用
let object = MyClass()
let result = object.method(number: 1)
//第二种调用方法
let f = MyClass.method
let object2 = MyClass()
//let result2 = f(object2)(1)

///单利
class MyManager{
    static let shared = MyManager()
    private init(){}//确保只会执行一次 
}

///条件编译
//FREE_VERSION 免费版本

#if os(macOC)
    break
#else
    
#endif

///编译标记

//MARK:
//TODO:
//FIXME:

///@UIApplicationMain 程序的入口

///@objc和dynamic
@objc(MyClasss)
class 我的类: NSObject {
    @objc(greeting:)
    func 你好(名字: String) {
    }
}

///可选协议和协议扩展
//swift可选协议
@objc protocol OptionalProtocol {
    @objc optional func optionalMethod() //可选
    func necessaryMethod() //必选
}

protocol OptionalProtocoll {
    func optionalMethod() //可选
    func necessaryMethod() //必选
}
extension OptionalProtocoll {
    func optionalMethod() {
        print("默认实现")
    }
}

///UnsafePointer 用于转换成c指针
func method(_ num: UnsafePointer<CInt>) {
    print(num.pointee)
}

///GCD
//创建目标队列
let workingQueue = DispatchQueue.init(label: "my_queue")
//派发
workingQueue.async {
    print("努力工作")
    Thread.sleep(forTimeInterval: 2)
    DispatchQueue.main.async {
        print("结束工作")
    }
}

//封装延时操作
typealias Task = (_ cancel: Bool) -> Void

func delay(_ time: TimeInterval, task: @escaping () -> ()) -> Task? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure: (() -> Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    
    return result
}

func cancel(_ task: Task?) {
    task?(true)
}

let task = delay(5) {
    print("2m")
}
cancel(task)

///获取对象类型
let data = NSData()
//let name: AnyClass! = object_getClass(data)
let name = type(of: data)
print(name)

///自省 我是谁 isKindOfClass:->子类或者自身 isMemberOfClass:->自身
//swift 使用 is 来判断

///KeyPath 和 KVO
class MyClasss: NSObject {
    @objc dynamic var date = Date()
}
class AnotherClass: NSObject {
    var myObject: MyClasss!
    var observation: NSKeyValueObservation?
    override init() {
        super.init()
        myObject = MyClasss()
        print("初始化AnotherClass，当前时间\(myObject.date)")
        observation = myObject.observe(\MyClasss.date, options: [.new], changeHandler: { (_, change) in
            if let newDate = change.newValue {
                print("AnotherClass 日期发生变化\(newDate)")
            }
        })
        delay(1) {
            self.myObject.date = Date()
        }
    }
}

///局部 scope
//let titleLabel: UILabel = {
//    let label = UILabel()
//    return label
//}()

///哈希
let num = 11
print(num.hashValue)

///类簇 使用一个统一的公共的类来定制单一的接口，然后在表面之下对应若干个私有类进行实现的方式
class Drinking {
    typealias LiquidColor = UIColor
    var color: LiquidColor {
        return .clear
    }
    
    class func drinking(name: String) -> Drinking {
        var drinking: Drinking
        switch name {
        case "Coke":
            drinking = Coke()
        case "Beer":
            drinking = Beer()
        default:
            drinking = Drinking()
        }
        return drinking
    }
}
class Coke: Drinking {
    override var color: Drinking.LiquidColor {
        return .black
    }
}
class Beer: Drinking {
    override var color: Drinking.LiquidColor {
        return .yellow
    }
}
let coke = Drinking.drinking(name: "Coke")
coke.color
let beer = Drinking.drinking(name: "Beer")
beer.color

///输出格式化
extension Double {
    func format(_ f: String) -> String {
        return String.init(format: "%\(f)f", self)
    }
}
let ff = ".2"
let b = 0.2222222
print("double:\(b.format(ff))")

///Options 多选
struct YourOption: OptionSet {
    let rawValue: UInt
    static let none = YourOption(rawValue: 0)
    static let option1 = YourOption(rawValue: 1)
    static let option2 = YourOption(rawValue: 1 << 1)
}

///数组 enumerate
let arr: NSArray = [1,2,3,4,5]
var resultt:Int = 0
//计算数组前3之和  不推荐
arr.enumerateObjects { (num, idx, stop) in
    resultt += num as! Int
    if idx == 2 {//数组前3就停止
        stop.pointee = true
    }
}
print(resultt)

//swift 版本
resultt = 0
for (idx, num) in [1,2,3,4,5].enumerated() {
    resultt += num
    if idx == 2 {
        break
    }
}
print(resultt)

///类型编码 @encode 通过类型获取对应的类型编码
let int: Int = 0
let intNumber: NSNumber = int as NSNumber
String.init(validatingUTF8: intNumber.objCType)
let p = NSValue.init(cgPoint: CGPoint.init(x: 1, y: 1))
String.init(validatingUTF8: p.objCType)


sin(M_PI_2)

///associated object 动态的给类添加成员变量
class MyClassss {
}
private var key: Void?
extension MyClassss {
    var title: String? {
        get {
            return objc_getAssociatedObject(self, &key) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
//测试
func printTitle(_ input: MyClassss) {
    if let title = input.title {
        print(title)
    }else {
        print("没有设置")
    }
}
let a = MyClassss()
printTitle(a)
a.title = "aaaaaaaa"
printTitle(a)

///Lock 锁
func myMethod(anObj: AnyObject!) {
    objc_sync_enter(anObj)
    
    //在enter和exit之间持有anObj锁
    objc_sync_exit(anObj)
}
//封装
func synchronized(_ lock: AnyObject, closure: ()->()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
func myMethodLocked(anObj: AnyObject!) {
    synchronized(anObj) {
        //持有anObj锁
    }
}

///Toll-Free Bridging和Unmannaged   Core Foundation 框架 CF也在swift的arc管理之下

//cf和ns类型转换
let fileURL = NSURL.init(string: "someUrl")
var theSoundID: SystemSoundID = 0
AudioServicesCreateSystemSoundID(fileURL!, &theSoundID)


