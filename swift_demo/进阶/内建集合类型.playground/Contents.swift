//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///Map 对数组中的每一个元素都进行转换
var fibs = [1, 2, 3]
let squares = fibs.map{$0*$0}
print(squares)

//标准库函数
/*
map 和 flatMap — 如何对元素进行变换

filter — 元素是否应该被包含在结果中

reduce — 如何将元素合并到一个总和的值中

sequence — 序列中下一个元素应该是什么？

forEach — 对于一个元素，应该执行怎样的操作

sort，lexicographicCompare 和 partition — 两个元素应该以怎样的顺序进行排列

index，first 和 contains — 元素是否符合某个条件

min 和 max — 两个元素中的最小/最大值是哪个

elementsEqual 和 starts — 两个元素是否相等

split — 这个元素是否是一个分割符
*/
 
//在逆序数组中寻找第一个满足特定条件的元素

let names = ["Paula", "Ele", "Zoe"]
var lastNameEndingInA: String?
for name in names.reversed() where name.hasSuffix("a") {
    lastNameEndingInA = name
    break
}

//通过扩展Sequence来简化代码
extension Sequence {
    func last(where predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}
let match = names.last { (s) -> Bool in
    s.hasSuffix("a")
}
match

///Filter 对一个数组进行检查，将这个数组中符合一定条件的元素过滤出来,返回一个新的数组
let nums = [1,3,4,5,6,7,8,9,10]
let numsOfTwo = nums.filter{num in num % 2 == 0}
numsOfTwo
//100以内满足1到10的平方并且能被2整除的树
let ten = (1..<10).map{$0 * $0}.filter{$0 % 2 == 0}
ten

//contains 检查数组中的元素是否满足某个特定条件，满足就立即返回

extension Sequence {
    func all(matching predicate: (Iterator.Element) -> Bool) -> Bool {
        //对于一个条件，如果没有元素不满足它的话，意味着所有元素都满足它
        return !contains{!predicate($0)}
    }
}

let evenNums = nums.filter{$0 % 2 == 0}
evenNums
evenNums.all{$0 % 2 == 0}
//Reduce 将初始值和中间值与元素进行合并
fibs
let sum = fibs.reduce(0) { (total, num) -> Int in
    total * 2 + num
}
fibs.reduce(1, +)

extension Array {
    func reduce<Result>(_ initalResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> Result {
        var result = initalResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }
}

//使用reduce实现map和filter
extension Array {
    func map2<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]){$0 + [transform($1)]}
    }
    func filter2(_ isIncluded: (Element) -> Bool) -> [Element] {
        return reduce([]){isIncluded($1) ? ($0 + [$1]) : $0}
    }
}

///flatMap 构建的函数返回的参数是一个数组

extension Array {
    func flatMap<T>(_ transform: (Element) -> [T]) -> [T] {
        var result:[T] = []
        for x in self {
            result.append(contentsOf: transform(x))
        }
        return result
    }
}
//两个数组合并 返回所有的组合结果
let suits = ["1", "2", "3", "4"]
let ranks = ["J", "Q", "K", "A"]
let result = suits.flatMap{suit in
    ranks.map{ rank in
        (suit, rank)
    }
}
print(result)

///使用forEach进行迭代
for element in [1,2,3] {
    print(element)
}
[1,2,3].forEach { (element) in
    print(element)
}

//for 和forEach的区别：当使用return时，for可以返回到函数本身，而forEach只能返回到闭包本身

extension Array where Element: Equatable {
    func index(of element: Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
}
let index = [1,2,3].index(of: 3)

extension Array where Element: Equatable {
    func index_forEach(of element: Element) -> Int? {
        self.indices.filter{idx in
            self[idx] == element
            }.forEach{idx in
                return idx
        }
        return nil
    }
}
let index_forEach = [1,2,3].index_forEach(of: 2)

///数组类型

//切片 切片类型只是数组的一种表示方式，它背后的数据仍然是原来的数组，原来的数组不需要被复制，切下了原来数组的一部分，是值类型，与原来数组互不影响,切片的下标与原来数组的下标保持一致
fibs
var slice = fibs[1..<fibs.endIndex]
slice.append(12)
fibs
slice[1]
type(of: slice)
Array(slice)//将切片转换成数组

//将切片转换成枚举 切片的与原来数组的下标关系将不存在
let eunmerate = slice.enumerated()
dump(eunmerate)
eunmerate.forEach { (a) in
    print("a = \(a), a.0 = \(a.0), a.1 = \(a.1)")
}

///字典 通过键去找值，返回一个可选值

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSetting:[String: Setting] = [
    "A": .bool(true),
    "N": .text("Iphone")
]
print(defaultSetting["N"])

//合并两个字典
extension Dictionary {
    mutating func merge<S>(_ other: S) where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
        for (k,v) in other {
            self[k] = v
        }
    }
}

var settings = defaultSetting
let overriddenSettings: [String: Setting] = ["N": .text("O")]
settings.merge(overriddenSettings)
print(settings)

//从序列创建数组
extension Dictionary {
    init<S: Sequence>(_ sequance: S) where S.Iterator.Element == (key: Key, value: Value) {
        self = [:]
        self.merge(sequance)
    }
}
let defaultAlarms = (1..<5).map{(key: "Alarm\($0)", value: false)}
print(defaultAlarms)
let alarmsDictionary = Dictionary(defaultAlarms)

//只对value进行扩展
extension Dictionary {
    func mapValues<NewValue>(transform: (Value) -> NewValue) -> [Key: NewValue] {
        return Dictionary<Key, NewValue>(map{(key,value) in
            return (key, transform(value))
        })
    }
}
let settingsAsStrings = settings.mapValues{setting -> String in
    switch setting {
    case .text(let text): return text
    case .int(let number): return String(number)
    case .bool(let value): return String(value)
    }
}
print(settingsAsStrings)

//hashable要求
struct Person {
    var name: String
    var zipCode: Int
    var birthday: Date
}
//添加 == 运算符
extension Person: Equatable {
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
            && lhs.birthday == rhs.birthday
            && lhs.zipCode == rhs.zipCode
    }
}
//添加hashValue
extension Person: Hashable {
    var hashValue: Int {
        return name.hashValue ^ zipCode.hashValue ^ birthday.hashValue
    }
}

//Set 
let naturals: Set = [1,2,3,1]
naturals

//集合代数
let numbers: Set = [1,3,5,7,9]
let discontinuedNumbers: Set = [1,2,3,4,5]

let currentNumbers = numbers.subtracting(discontinuedNumbers)//补集
let sameNumbers = numbers.intersection(discontinuedNumbers)//交集
let mergeNumbers = numbers.union(discontinuedNumbers)

//索引集合和字符集合 IndexSet()表示正整数集合 CharacterSet()高效的存储Unicode字符
var indices = IndexSet()
indices.insert(integersIn: 1..<5)
indices.insert(integersIn: 11..<15)
let evenIndices = indices.filter{$0 % 2 == 0}
evenIndices

//在闭包中使用集合
extension Sequence where Iterator.Element: Hashable {
    //验证所有的值是否是唯一的
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter{
            if seen.contains($0){
                return false
            } else {
                seen.insert($0)
                return true
            }
        }
    }
}
print([1,2,2,4].unique())

//Range

let singleDigitNumbers = 0..<10
let lowercaseLetters = Character("a")...Character("z")




