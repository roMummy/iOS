//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
///Sequence 反序排列
class ReverseIterator<T>: IteratorProtocol {
    
    typealias Element = T
    
    var array: [Element]
    var currentIndex = 0
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }
    func next() -> Element? {
        if currentIndex < 0 {
            return nil
        }else {
            let element = array[currentIndex]
            currentIndex -= 1
            return element
        }
    }
}
struct ReverseSequence<T>: Sequence {
    var array: [T]
    init(array: [T]) {
        self.array = array
    }
    typealias Iterator = ReverseIterator<T>
    func makeIterator() -> ReverseIterator<T> {
        return ReverseIterator(array: self.array)
    }
}

let arr = [1,2,3,4,5]
for i in ReverseSequence.init(array: arr) {
    print(i)
}

//for in 循环的原理
var iterator = arr.makeIterator()
while let obj = iterator.next() {
    print(obj)
}

///多元组
func swapMe1<T>(a: inout T, b: inout T) {
    let temp = a
    a = b
    b = temp
}
func swapMe2<T>(a: inout T, b: inout T) {
    (a,b) = (b,a)
}

//extension CGRect {
//    public func divided(atDistance: CGFloat, form fromEdge: CGRectEdge) -> (slice: CGRect, remainder: CGRect)
//
//}

///@autoclosure和？？
func logIfTrue(_ predicate: @autoclosure () -> Bool) {
    if predicate() {
        print("true")
    }
}
logIfTrue(2>1)

//??的实现
func ??<T>(optional: T?, defaultValue: @autoclosure () -> T) -> T {
    switch optional {
    case .some(let value)://不是nil
        return value
    case .none://是nil
        return defaultValue()
    }
}

///@escaping 逃逸闭包
func doWork(block: () -> Void) {
    block()
}
doWork {
    print("work")
}
func doWorkAsync(block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}

class S {
    var foo = "foo"
    
    func method1() {
        doWork {
            print("foo")
        }
        foo = "bar"
    }
    
    func method2() {
        doWorkAsync {[weak self] in
            print(self?.foo ?? "nil")
        }
        foo = "bar"
    }
}
//S().method1()
S().method2()
protocol P {
    func work(b: @escaping () -> Void)
}

class C: P {
    func work(b: @escaping () -> Void) {
        DispatchQueue.main.async {
            print("in C")
            b()
        }
    }
}

///可选值
class Toy {
    let name: String
    init(name: String) {
        self.name = name
    }
}
class Pet {
    var toy: Toy?
}
class Child {
    var pet: Pet?
}

let xiaoming = Child()
let toyName = xiaoming.pet?.toy?.name
if let toyName = xiaoming.pet?.toy?.name {
    
}
extension Toy {
    func play() {
        
    }
}

let playClosure = { (child: Child) -> () in
    child.pet?.toy?.play()
}
if let result: () = playClosure(xiaoming) {
    print("111")    
}else {
    print("222")
}

///字面量表达 3 "hello"等就是字面量
let aNumber = 3
let aString = "hello"

//实现自己的 bool类型
enum MyBool: String {
    case myTrue = "0"
    case myFalse = "1"
}
extension MyBool: ExpressibleByBooleanLiteral {
    
    typealias BooleanLiteralType = Bool
    
    init(booleanLiteral value: BooleanLiteralType) {
        self = value ? .myTrue : .myFalse
    }
}
let myTrue: MyBool = true
let myFalse: MyBool = false

// ExpressibleByStringLiteral

/*
 convenience:便利，使用convenience修饰的构造函数叫做便利构造函数
 便利构造函数通常用在对系统的类进行构造函数的扩充时使用。
 便利构造函数的特点：
 1、便利构造函数通常都是写在extension里面
 2、便利函数init前面需要加载convenience
 3、在便利构造函数中需要明确的调用self.init()
 4、不能被子类以super。init的形式调用，不能被重写
 */
class Person: ExpressibleByStringLiteral {
    var name: String
    init(name value: String) {
        self.name = value
    }
    required convenience init(extendedGraphemeClusterLiteral value: String) {
        self.init(name: value)
    }
    required init(unicodeScalarLiteral value: String) {
        self.name = value
    }
    required init(stringLiteral value: String) {
        self.name = value
    }
}

let person: Person = "张三"
print(person)
person.name

///下标
//取到特定位置的元素
extension Array {
    subscript(input: [Int]) -> ArraySlice<Element>{
        get{
            var result = ArraySlice<Element>()
            for i in input {
                assert(i < self.count, "index out of range")
                result.append(self[i])
            }
            return result
        }
        set{
            for (index, i) in input.enumerated() {
                assert(i < self.count, "index out of range")
                self[i] = newValue[index]
            }
        }
    }
}
var arrs = [1,2,3,4,5]
arrs[[0,2,4]]
arrs[[0,2,4]] = [-1,-1,-1]
arrs

///命名空间 解决名字重复的方法
// 1.创建多个module
// 2.使用struct 把方法写到struct中

///typealias 用来给存在的类型重新定义名字 指定的是一个特性的类型

//泛型
class Pig<T>{}

typealias Worker<T> = Pig<T>

//协议
protocol Cat {}
protocol Dog {}
typealias Pat = Cat & Dog

///associatedtype
protocol Food {}
//protocol Animal {
//    func eat(_ food: Food)
//}
struct Meat: Food {}
struct Grass: Food {}
//
//struct Tiger: Animal {
//    func eat(_ food: Food) {
//        if let meat = food as? Meat {
//            print("eat\(meat)")
//        }else{
//            fatalError("not eat")
//        }
//    }
//}
//let meat = Meat()
//Tiger().eat(meat)


protocol Animal {
    associatedtype F: Food
    func eat(_ food: F)
}
struct Tiger: Animal {
    func eat(_ food: Meat) {
        print("eat \(food)")
    }
}

// 在使用associatedtype之后协议就不能作为一个独立的类型来使用 应为swift在编译的时候需要确定所有类型
//func isDangerous(animal: Animal) -> Bool {
//    if animal is Tiger {
//        return true
//    }else {
//        return false
//    }
//}
func isDangerous<A: Animal>(animal: A) -> Bool {//泛化
    if animal is Tiger {
        return true
    }else{
        return false
    }
}


///可变参数函数 添加的参数个数不限制
// 限制：同一个方法中只能有一个参数是可变的，可变参数必须是同一种类型
func sum(input: Int...) -> Int {
    return input.reduce(0, +)
}

func myFunc(number: Int..., string: String) {
    number.forEach{
        for i in 0..<$0 {
            print("\(i + 1): \(string)")
        }
    }
}
myFunc(number: 1,2,3, string: "hello")




let name = "tom"
let date = NSDate()
let string = NSString.init(format: "1%@,2%@", name, date)
string

///init 只会调用一次 可以对let常量进行初始化

class ClassA{
    let numA: Int
    init(num: Int) {
        numA = num
    }
    convenience init(bigNum: Bool) {
        self.init(num: bigNum ? 100 : 1)
    }
}
class ClassBB: ClassA {
    let numB: Int
    override init(num: Int) {
        numB = num + 1
        super.init(num: num)
    }
}
//只要子类实现父类的convenience调用的init方法，子类可能用父类的convenience初始化方法
let anObj = ClassBB(bigNum: true)
// required 修饰init方法 子类必须要实现

///初始化返回 nil
extension Int{
    init?(fromString: String) {
        self = 0
        if fromString == "1" {
            return nil
        }
    }
}
Int.init(fromString: "1")
Int.init(fromString: "2")


///多类型和容器
let mixed: [CustomStringConvertible] = [1, "one", 2]

mixed.forEach{
    print($0.description)
}
enum IntOrString {
    case IntValue(Int)
    case StringValue(String)
}
let mixeds = [IntOrString.IntValue(1),
              IntOrString.StringValue("1")]

///正则表达式
struct RegexHelper{
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matchs = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matchs.count > 0
    }
}
let mailPattern = "^[0-9]$"
let matcher: RegexHelper
do {
    matcher = try RegexHelper(mailPattern)
    let maybeMail = "as@sdf.com"
    if matcher.match(maybeMail) {
        print("有效")
    }else {
        print("无效")
    }
    
} catch {
    print("catch")
}

//自定义操作符
precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}
infix operator =~: MatchPrecedence
func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(lhs).match(rhs)
    } catch {
        return false
    }
}
if "onev@12.com" =~ "^[0-9]$" {
    print("有效")
}


