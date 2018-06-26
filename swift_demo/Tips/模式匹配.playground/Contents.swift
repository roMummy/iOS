//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///模式匹配 正则匹配是模式匹配的子集

/// 重载~=操作符
///
/// - Parameters:
///   - pattern: 匹配规则
///   - input: 输入string
/// - Returns: 是否匹配
func ~=(pattern: NSRegularExpression, input: String) -> Bool {
    return pattern.numberOfMatches(in: input,
                                   options: [],
                                   range: NSRange(location: 0, length: input.count)) > 0
}
//将String转成NSRegularExpression
prefix operator ~/
prefix func ~/(pattern: String) -> NSRegularExpression? {
    return try? NSRegularExpression(pattern: pattern)
}

let contact = ("http://www.baidu.com", "tianwen520@outlook.com")

let mailRegex: NSRegularExpression
let httpRegex: NSRegularExpression

mailRegex = ~/"^[a-z0-9]" ?? NSRegularExpression()
httpRegex = ~/"^(http:)" ?? NSRegularExpression()

switch contact {
case (httpRegex, mailRegex):
    print("1111")
default:
    print("other")
}

///...和..<
/*...:全闭合
  ..<:半闭合不包含最后一个
 */
for item in 0..<4 {
    print(item)
}

let test = "Hello"
let interval =  "a" ... "z"
let forward = 1 ..< 4

for c in test {
    if !interval.contains(String(c)) {
        print("\(c)不是小写")
    }
}

///AnyClass,元类型和.self
//typealias AnyClass = AnyObject.Type  是一个元类型
class A {
    static func method() {
        print("class A")
    }
}
//let typeA: A.Type = A.self
//let typeA: AnyClass = A.self
A.method()
class MusicViewController: UIViewController {}
class AlbumViewController: UIViewController {}
let usingVCTypes: [AnyClass] = [MusicViewController.self,AlbumViewController.self]

func setupViewControllers(_ vcTypes:[AnyClass]) {
    for vcType in vcTypes {
        if vcType is UIViewController.Type {
            let vc = (vcType as! UIViewController.Type).init()
            print("vc+\(vc)")
        }
    }
}
setupViewControllers(usingVCTypes)
protocol tests {}
tests.self

///协议和类方法中的Self
protocol Copyable {
    func copy() -> Self
}
class MyClass: Copyable {
    var num = 0
    required init() {
        
    }
    func copy() -> Self {
        let result = type(of: self).init()
        result.num = num
        return result
    }
}
let object = MyClass()
object.num = 100
let newObject = object.copy()
object.num = 1
print(object.num)
print(newObject.num)


///动态类型和多方法
class Pet{}
class Cat: Pet{}
class Dog: Pet {
}
func printPet(_ pet: Pet) {
    print("pet")
}
func printPet(_ cat: Cat) {
    print("cat")
}
func printPet(_ dog: Dog) {
    print("dog")
}
printPet(Dog())

func printThem(_ pet: Pet, _ cat: Cat) {
    printPet(pet)
    printPet(cat)
}
printThem(Dog(), Cat())

///final 不允许对改内容进行继承或者重写

/**权限控制
 1.类或者方法的功能确实已经完备了
 2.子类继承和修改是一个危险的事情
 3.为了父类中某些代码一定会被执行
 4.性能改善
 */
class Parent {
    final func method() {
        print("开始配置")
        //...必要的代码
        print("结束配置")
    }
    func methodImpl() {
        fatalError("子类必须实现这个方法")
        //或者默认实现
    }
}
class Child: Parent {
    override func methodImpl() {
        //..
    }
}

///Reflection && Mirror
///发射机制现在只是用到REPL环境和Playground中

struct Person {
    let name: String
    let age: Int
}

let xiaoMing = Person(name: "xiaoming", age: 11)
let r = Mirror(reflecting: xiaoMing)

print("xiaoMing是\(r.displayStyle!)")
print("属性个数：\(r.children.count)")
for child in r.children {
    print("属性名：\(String(describing: child.label)), 值:\(child.value)")
}
dump(xiaoMing)//打印镜像

func valueFrom(_ object: Any, key: String) -> Any? {
    let mirror = Mirror.init(reflecting: object)
    for child in mirror.children {
        let (targetKey, targetMirror) = (child.label, child.value)
        if key == targetKey {
            return targetMirror
        }
    }
    return nil
}
if let name = valueFrom(xiaoMing, key: "name") as? String {
    print("通过key得到值：\(name)")
}

///隐士解包Optional
///编译器会自动为我们加入 ！
var maybeObject: MyClass! = MyClass()
maybeObject.copy()
maybeObject!.copy()

///多重Optional
///可以通过 fr v -R 来打印出变量未加工的信息
var aNil: String? = nil
var anotherNil: String?? = aNil
var literalNil: String?? = nil

if anotherNil != nil {
    print("anotherNil")
}
if literalNil != nil {
    print("literalNil")
}

///Optional Map
let arr = [1,2,3]
let double = arr.map{
    $0 * 2
}
print(double)

let num: Int? = 3
//var result: Int?
//if let realNum = num {
//    result = realNum * 2
//}else {
//    result = nil
//}

let result = num.map{
    $0 * 2
}

///Protocol Extension
protocol A2 {
    func method1() -> String
}
extension A2 {
    func method1() -> String {
        return "hi"
    }
    func method2() -> String {
        return "hi"
    }
}
struct B2: A2 {
    func method1() -> String {
        return "hello"
    }
    func method2() -> String {
        return "hello"
    }
}

let b2 = B2()
b2.method1()
b2.method2()

let a2 = b2 as A2
a2.method2()
a2.method1()

///where 和模式匹配
let name = ["1111", "2222", "3333", "4444"]
name.forEach{
    switch $0 {
    case let x where x.hasPrefix("1"):
        print(x)
    default:
        break
    }
}

let numm: [Int?] = [1, 44, 2, nil]
let n = numm.flatMap{$0}
for score in n where score > 40 {
    print("及格\(score)")
}
//协议限制
//extension Sequence where Self.Iterator.Element: Comparable {
//    public func sortedd() -> [Self.Iterator.Element]
//}


///indirect和嵌套enum indirect简洁保存 可以使值类型递归
indirect enum LinkedList<Element: Comparable> {
    case empty
    case node(Element, LinkedList<Element>)
    func removing(_ element: Element) -> LinkedList<Element> {
        guard case let .node(value, next) = self else {
            return .empty
        }
        return value == element ? next : LinkedList.node(value, next.removing(element))
    }
}
let linkedList = LinkedList.node(1, .node(2, .node(3, .empty)))

let resultt = linkedList.removing(2)
print(resultt)

