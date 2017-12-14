//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func doubler(i: Int) -> Int {
    return i * 2
}
[1,2,3,4].map(doubler)
//使用闭包表达式
let doublerAlt = {$0 * 2}
[1,2,3,4].map(doublerAlt)

let arc = (0..<3).map{_ in arc4random()}
arc

let isEven = {$0 % 2 == 0}

protocol ExpressibleByIntegerLiteral {
    associatedtype IntegerLiteralType
    init(integerLiteral value: Self.IntegerLiteralType)
}
typealias IntegerLiteralType = Int

extension BinaryInteger {
    var isEven: Bool {return self%2 == 0}
}
//func isEven<T: IntegerType>(i: T) -> Bool {
//    return i % 2 == 0
//}
let int8isEven = isEven

// 排序
var numberStrings = [(2,"two"),(3,"three"),(1,"one")]
numberStrings.sort(by: <)
numberStrings

let animals = ["elephant","zebra","dog"]
animals.sorted { (lhs, rhs) -> Bool in
    let l = lhs.reversed()
    let r = rhs.reversed()
    return l.lexicographicallyPrecedes(r)
}
animals

final class Person: NSObject {
    @objc var first: String
    @objc var last: String
    @objc var yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
    }
}

let people = [
    Person(first: "Jo", last: "Smith", yearOfBirth: 1970),
    Person(first: "Joe", last: "Smith", yearOfBirth: 1970),
    Person(first: "Joe", last: "Smyth", yearOfBirth: 1970),
    Person(first: "Joanne", last: "smith", yearOfBirth: 1985),
    Person(first: "Joanne", last: "smith", yearOfBirth: 1970),
    Person(first: "Robert", last: "Jones", yearOfBirth: 1970),
]

//设定排序标准 localizedCaseInsensitiveCompare-本地化比较（不区分大小写）
let lastDescriptor = NSSortDescriptor(key: #keyPath(Person.last), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
let firstDescriptor = NSSortDescriptor(key: #keyPath(Person.first), ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
let yearDescriptor = NSSortDescriptor(key: #keyPath(Person.yearOfBirth), ascending: true)

let descriptors = [lastDescriptor, firstDescriptor, yearDescriptor]
let newPeople = (people as NSArray).sortedArray(using: descriptors)
debugPrint(newPeople)

//使用localizedCaseInsensitiveCompare来排序
var strings = ["Hello", "hallo", "Hallo", "hello"]
strings.sort{$0.localizedCaseInsensitiveCompare($1) == .orderedAscending}
strings
//使用对象的某个属性排序
people.sorted { (l, h) -> Bool in
    return l.yearOfBirth < h.yearOfBirth
}
//lexicographicalCompare 可以同时排序多个属性
people.sorted { (p0, p1) -> Bool in
    let left = [p0.last, p0.first]
    let right = [p1.last, p1.first]
    return left.lexicographicallyPrecedes(right, by: { (l, r) -> Bool in
        l.localizedCaseInsensitiveCompare(r) == .orderedAscending
    })
}

///函数作为数据
typealias SortDescriptor<Value> = (Value, Value) -> Bool
let sortByYear: SortDescriptor<Person> = {$0.yearOfBirth < $1.yearOfBirth}
let sortByLastName: SortDescriptor<Person> = {
    $0.last.localizedCaseInsensitiveCompare($1.last) == .orderedAscending
}

//封装排序函数
func sortDescriptor<Value, Key>(key: @escaping (Value)-> Key,
                                _ areIncreasingOrder: @escaping (Key, Key)-> Bool)
    -> SortDescriptor<Value> {
    return {areIncreasingOrder(key($0), key($1))}
}
let sortByYearAlt: SortDescriptor<Person> = sortDescriptor(key: {$0.yearOfBirth}, <)
people.sorted(by: sortByYearAlt)

//为comparable类型定义一个重载版本的函数
func sortDescriptor<Value, Key>(key: @escaping (Value) -> Key) -> SortDescriptor<Value> where Key: Comparable {
    return {key($0) < key($1)}
}
let sortByYearAlt2: SortDescriptor<Person> = sortDescriptor(key: {$0.yearOfBirth})

//增加支持NSSortDescriptor的函数
func sortDescriptor<Value, Key>(key: @escaping (Value) -> Key,
                                ascending: Bool = true,
                                _ comparator: @escaping (Key) -> (Key) -> ComparisonResult)
    -> SortDescriptor<Value> {
        return {lhs, rhs in
            let order: ComparisonResult = ascending
                ? .orderedAscending
                : .orderedDescending
            return comparator(key(lhs))(key(rhs)) == order
        }
}
let sortByFirstName: SortDescriptor<Person> = sortDescriptor(key: {$0.first}, String.localizedCaseInsensitiveCompare)
people.sorted(by: sortByFirstName)

//添加一个支持Sequence协议 类似NSArray.sortedArray(using:)的方法
func combine<Value>(sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {
    return {lhs, rhs in
        for areIncreasingOrder in sortDescriptors {
            if areIncreasingOrder(lhs, rhs) {return true}
            if areIncreasingOrder(rhs, lhs) {return false}
        }
        return false
    }
}
let combined: SortDescriptor<Person> = combine(sortDescriptors: [sortByLastName, sortByFirstName, sortByYear])  //没有使用运行时完成的排序
people.sorted(by: combined)

//自定义运算符 合并两个排序函数
infix operator <||>: LogicalDisjunctionPrecedence
func <||><A>(lhs: @escaping (A,A) -> Bool, rhs: @escaping (A,A) -> Bool) -> (A,A) -> Bool {
    return {x, y in
        if lhs(x,y) {return true}
        if lhs(y,x) {return false}
        if rhs(x,y) {return true}
        return false
    }
}
let combinedAlt = sortByLastName<||>sortByFirstName<||>sortByYear
people.sorted(by: combinedAlt)

//增加有可选值的情况
func lift<A>(_ compare: (A) -> (A) -> ComparisonResult) -> (A?) -> (A?) -> ComparisonResult {
    return {lhs in {rhs in
        switch (lhs, rhs) {
        case (nil, nil): return .orderedSame
        case (nil, _):   return .orderedAscending
        case (_, nil):   return .orderedDescending
        default: fatalError()
            }
        }
    }
}
let lcic = lift(String.localizedCaseInsensitiveCompare)
//let result = strings.sorted(by: sortDescriptor(key: {$0.fileExtension}, lcic))

///局部函数和变量捕获

//归并排序
extension Array where Element: Comparable {
    private mutating func merge(lo: Int, mi: Int, hi: Int) {
        var tmp: [Element] = []
        var i = lo, j = mi
        while i != mi && j != hi {
            if self[j] < self[i] {
                tmp.append(self[j])
                j += 1
            }else {
                tmp.append(self[i])
                i += 1
            }
        }
        tmp.append(contentsOf: self[i..<mi])
        tmp.append(contentsOf: self[j..<hi])
        replaceSubrange(lo..<hi, with: tmp)//替换
    }
    
    mutating func mergeSortInPlacelnefficient() {
        let n = count
        var size = 1
        
        while size < n {
            for lo in stride(from: 0, to: n - size, by: size*2) {
                merge(lo: lo, mi: (lo + size), hi: Swift.min(lo+size*2, n))
            }
            size *= 2
        }
    }
}

///函数作为代理

//结构体代理 在代理和协议的模式中，并不适合使用结构体
//protocol AlertViewDelegate{
//    mutating func buttonTapped(index: Int)
//}
//class AlertView {
//    var buttons: [String]
//    var delegate: AlertViewDelegate? //不能使用弱引用
//    init(buttons: [String] = ["ok","cancel"]) {
//        self.buttons = buttons
//    }
//    func fire() {
//        delegate?.buttonTapped(index: 1)
//    }
//}
//struct TapLogger: AlertViewDelegate {
//    var taps: [Int] = []
//    mutating func buttonTapped(index: Int) {
//        taps.append(index)
//    }
//}
//
//let av = AlertView()
//var logger = TapLogger()
//av.delegate = logger
//av.fire()
//logger.taps //值被复制了 当前的结构体已经不是原来的结构体了

// 使用函数，而非结构体

class AlertView {
    var buttons: [String]
    var buttonTapped: ((Int) -> ())?
    init(buttons: [String] = ["ok","cancel"]) {
        self.buttons = buttons
    }
    func fire() {
        buttonTapped?(1)
    }
}
struct TapLogger {
    var taps: [Int] = []
    mutating func buttonTapped(index: Int) {
        taps.append(index)
    }
}
let av = AlertView()
var logger = TapLogger()
av.buttonTapped = {logger.buttonTapped(index: $0)} // 对logger变量进行捕获
av.fire()
logger.taps

// inout 参数和可变方法 不能改变只读属性
// inout参数将一个值传递给函数，函数可以改变这个值，然后将原来的值替换掉，并从函数中传出
// lvalue描述的是一个内存地址;rvalue描述的是一个值

func increment(value: inout Int) {
    value += 1
}
var i = 0
increment(value: &i)

var array = [1, 2, 3]
increment(value: &array[0])
array

struct Point{
    var x: Int
    var y: Int
    var squaredDistance: Int {
        return x*x + y*y
    }
}
var point = Point(x: 0, y: 0)
increment(value: &point.x)
point
//increment(value: &point.squaredDistance)

postfix func ++(x: inout Int) {
    x += 1
}
point.x++
point
var dic = ["one": 1] //可选字典
dic["one"]?++
dic

///嵌套函数和inout
func incrementTenTimes(value: inout Int) {
    func inc(){
        value += 1
    }
    for _ in 0 ..< 10 {
        inc()
    }
}
var x = 0
incrementTenTimes(value: &x)

//func escapelncrement(value: inout Int) -> () -> () {//inout 参数不能逃逸
//    func inc() {
//        value += 1
//    }
//    return inc
//}

//& 可以将变量转换成不安全的指针
func incref(pointer: UnsafeMutablePointer<Int>) -> () -> Int{
    //将指针的复制存储在闭包中
    return {
        pointer.pointee += 1
        return pointer.pointee
    }
}
let fun: () -> Int
do {
    var array = [0]
    fun = incref(pointer: &array)
}
//debugPrint(fun())

///计算属性和下标
struct GPSTrack{
    private(set) var record: [(Int, Date)] = [] //外部只读，内部可写
    var dates: [Date] {
        return record.map{$0.1}
    }
    mutating func test() {
        self.record = []
    }
}

var gps = GPSTrack()
//gps.record = [(1,Date())]
//debugPrint(gps.record)

///使用不同参数重载下标
/* 自定义运算符
左：prefix
右：postfix
中：infix
 */
let fibs = [0,1,2,3,4]
let first = fibs[0]
fibs[1..<1]

//半有界区间
struct RangeStart<l>{let start : l}
struct RangeEnd<l>{let end : l}

postfix operator ..<
postfix func ..<<l>(lhs: l) -> RangeStart<l> {
    return RangeStart(start: lhs)
}

prefix operator ..+
prefix func ..+<l>(rhs: l) -> RangeEnd<l> {
    return RangeEnd(end: rhs)
}

extension Collection {
    subscript(r: RangeStart<Index>) -> SubSequence {
        return suffix(from: r.start)
    }
    subscript(r: RangeEnd<Index>) -> SubSequence {
        return prefix(upTo: r.end)
    }
}
fibs[2..<]
fibs[..+3]

extension Dictionary {
    subscript(key: Key, or defaultValue: Value) -> Value {
        get {
            return self[key] ?? defaultValue
        }
        set {
           self[key] = newValue
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    var frequencies: [Iterator.Element: Int] {
        var result: [Iterator.Element: Int] = [:]
        for x in self {
            result[x, or: 0] += 1
        }
        return result
    }
}
"hello".frequencies

///自动闭包 @autoclosure
let evens = [2,3,4]
if !evens.isEmpty && evens[0] > 10 {//&& 会先执行左边的 然后再执行右边的
}
//短路求职
func and(_ l: Bool, _ r: @autoclosure () -> Bool) -> Bool {
    guard l else {
        return false
    }
    return r()
}
if and(!evens.isEmpty, evens[0] > 10) {
}

func loggg(condition: Bool, message: @autoclosure ()-> String, file: String = #file, _ function: String = #function, line: Int = #line) {
    if condition{return}
    debugPrint("myAssert failed:\(message()),\(file):\(function)(line\(line)")
}
loggg(condition: false, message: "error")
