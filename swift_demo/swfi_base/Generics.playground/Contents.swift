//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      泛型
 */

func swapTwoValues<T>(_ a:inout T,_ b:inout T){
    let temporaryA = a
    a = b
    b = temporaryA
    print(a)
    print(b)
}
var a = 2
var b = 3
swapTwoValues(&a, &b)

///泛型类型

struct IntStack {
    var items = [Int]()
    //入栈
    mutating func puch(_ item:Int) {
        items.append(item)
    }
    //出栈
    mutating func pop() -> Int{
        return items.removeLast()
    }
}
//泛型版本 栈
//struct Stact<Element> {
//    var items = [Element]()
//    //入栈
//    mutating func push(_ item:Element) {
//        items.append(item)
//    }
//    //出栈
//    mutating func pop() -> Element{
//        return items.removeLast()
//    }
//}
//var stack = Stact<String>()
//stack.push("12")

///扩展一个泛型类型
//extension Stact {
//    var topItem:Element? {
//        return items.isEmpty ? nil : items[items.count - 1]
//    }
//}
//if let topItem = stack.topItem {
//    print(topItem)
//}

///类型约束 Equatable协议要求所有的都遵循 == 和 !=
func findIndex<T:Equatable>(array:[T],_ valueToFind:T) -> Int? {
    for (index,value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex(array: [1,2,3], 12)
print(doubleIndex ?? "not find")

///关联类型 协议占位 associatedtype

protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count:Int{get}
    subscript(i:Int) -> ItemType {get}
    
}
struct Stact<Element>:Container {
//    internal var count: Int

//    typealias ItemType = Int //类型别名

    var items = [Element]()
    //入栈
    mutating func push(_ item:Element) {
        items.append(item)
    }
    //出栈
    mutating func pop() -> Element{
        return items.removeLast()
    }
    //Container
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i:Int) ->Element {
        return items[i]
    }
    
}

///泛型约束 where
func allItemsMatch<C1:Container, C2:Container>(_ someContainer:C1, _ anotherContainer:C2) -> Bool where C1.ItemType == C2.ItemType, C2.ItemType:Equatable {
    //检查个数是否相同
    if someContainer.count != anotherContainer.count {
        return false
    }
    //检查每一项是否相同
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    //两个元素都一样
    return true
}
extension Array:Container{}

var stackOfStrings = Stact<String>()
stackOfStrings.push("11111")
stackOfStrings.push("22222")
stackOfStrings.push("33333")
var arrayOfStrings = ["11111","22222","33333"]
if allItemsMatch(stackOfStrings, arrayOfStrings) {
    print("YES")
}else {
    print("NO")
}

///扩展通用Where
extension Stact where Element:Equatable {
    func isTop(_ item:Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
if stackOfStrings.isTop("33333") {
    print("top")
}else {
    print("not top")
}
//扩展数组 传入的值是否和第一个元素相同
extension Container where ItemType:Equatable {
    func startsWith(_ item:ItemType) -> Bool {
        return count >= 1 && self[0] == item
    }
}
if [1,1,1].startsWith(1) {
    print("yes square")
}else {
    print("not square")
}


		