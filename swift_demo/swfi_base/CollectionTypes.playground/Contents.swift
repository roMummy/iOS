//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//数组
var someInts = [Int]() //通过构造函数创建数组
print("数组个数\(someInts.count)")
someInts.append(3) //添加一个元素

var threeDoubles = Array(repeatElement(0.0, count: 3))//创建一个带有初始值的数组
print("\(threeDoubles)")

var anotherThreeDoules = Array(repeatElement(2.5, count: 3))
var sixDoubles = threeDoubles + anotherThreeDoules

var shoppingList:[String] = ["Eggs", "Milk"]

if shoppingList.isEmpty {
    print("empty")
}else {
    print("not empty")
}

shoppingList += ["Baking Pwoder"]

var fistItem = shoppingList[0]

shoppingList[0...2] = ["1", "2"]
//插入
shoppingList.insert("3", at: 0)
//移除
shoppingList.remove(at: 0)

print(shoppingList)
//遍历数组
for item in shoppingList {
    print(item)
}
//获取index
for (index,value) in shoppingList.enumerated() {
    print(String(index + 1) + ":" + value)
}

/*
 * 集合 能存到集合中的值必须是可哈希化的 “符合Hashable协议的类型需要提供一个类型为Int的可读属性hashValue”
 
 */
var letters = Set<String>()
//插入
letters.insert("Jazz");
letters.insert("1");
letters.insert("2");
//检查是否包含一个特定的值
if letters.contains("Jazz") {
    print("yes")
}else {
    print("no")
}
//普通遍历是无序的
for item in letters {
    print(item)
}
//有序的遍历
for item in letters.sorted() {
    print(item)
}

//基本集合操作
let oddDigits: Set = [1,3,5,7,9]
let evenDigits: Set = [0,2,4,6]
let singleDigitPrimeNumbers: Set = [2,3,5,7]

//两个集合中都包含的值创建一个新的集合
oddDigits.intersection(singleDigitPrimeNumbers).sorted()

//根据两个集合创建一个新的集合
oddDigits.union(evenDigits).sorted()

//不在该集合中的值创建一个新的集合
oddDigits.subtracting(singleDigitPrimeNumbers).sorted()

//都不在两个集合相同的值创建一个新的集合
oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()

let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

//判断一个集合中的值是否也包含在另外一个集合中
houseAnimals.isSubset(of: farmAnimals)
// true
//判断一个集合中包含另外一个集合中所有的值
farmAnimals.isSuperset(of: houseAnimals)
// true
//判断两个集合是否不含有相同的值
farmAnimals.isDisjoint(with: cityAnimals)

/*
 *  字典 一个字典的key类型必须遵循Hashable协议
 */

//创建一个确定类型的字典
var namesOfIntegers = [Int: String]()
//赋值
namesOfIntegers[16] = "sixteen"
//重新设置成空字典
namesOfIntegers = [:]

var airports:[String: String] = ["YYZ":"Toronto Pearson"]

airports["YYZ"] = "123"
//添加新的键值对
airports["1"] = "2"
//更新一个新的值 会返回原来旧的值
if let oldValue = airports.updateValue("Dublin", forKey: "1") {
    print(oldValue)
}
//给某个键赋值一个nil 删除这个键
airports["1"] = nil
//移除一个键 会返回移除的值
if let removedValue = airports.removeValue(forKey: "YYZ") {
    
    print(removedValue)
}
//遍历字典
for (code,name) in airports {

    print(code+name)
}

