//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      可选链式调用
 *
 *     可以在当前值可能为nil的可选值上请求和调用属性、方法及下标的方法。如果可选值有值，那么调用就会成功；如果可选值是nil，那么调用将返回nil。多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为nil，整个调用链都会失败，即返回nil。
 */

class Person {
    var residence:Residence?
    
}
//class Residence {
//    var numberOfRooms = 1
//}
//let john = Person()
//john.residence = Residence() //为residence添加一个实例，使他不为nil
//let roomCount = john.residence?.numberOfRooms

///为可选链式调用定义模型类
class Residence {
    var numberOfRooms: Int {
        return rooms.count
    }
    var rooms = [Room]()
    subscript(i: Int) -> Room {
        get{
            return rooms[i]
        }
        set{
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print(numberOfRooms)
    }
    var address: Address?
    
}
class Room {
    let name: String
    init(name: String) {
        self.name = name
    }
}
class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        }else if buildingNumber != nil && street != nil {
            return "\(buildingNumber) \(street)"
        }else {
            return nil
        }
    }
}
let john = Person()
let someAddress = Address()
someAddress.buildingName =  "tw"
func createAddress() -> Address {
    print("func")
    let someAddress = Address()
    someAddress.buildingName =  "tw"
    return someAddress
}

john.residence?.address = createAddress()
if let roomCount = john.residence?.numberOfRooms {
    print(roomCount)
}else {
    print("nil")
}
///通过可选链式调用调用方法
if john.residence?.printNumberOfRooms() != nil {
    print("print")
}else {
    print("print is nil")
}

if (john.residence?.address = someAddress) != nil {
    print("address")
}else {
    print("address is nil")
}
///通过可选链式调用访问下标


//john.residence?[0] = Room(name: "tw")

let johnsHouse = Residence()
johnsHouse.rooms.append(Room(name:"tw2"))
johnsHouse.rooms.append(Room(name:"tw1"))
john.residence = johnsHouse //给residence赋值一个实例 可选链的值不为nil

if let firstRoomName = john.residence?[0].name {
    print("Room")
}else {
    print("Room is nil")
}

//访问可选类型的下标

var testScores = ["Dave":[12,13,14], "Bev":[10,10,10]]
testScores["Dave"]?[0] = 99
testScores["Bev"]?[0] += 1
print(testScores)

///连接多层可选链式调用 多层可选链式调用不会增加返回值的可选层级

let johnsAddress = Address()
johnsAddress.buildingName = "twtw"
johnsAddress.street = "chengdu"
john.residence?.address = johnsAddress


if let johnsStreet = john.residence?.address?.street {
    print(johnsStreet)
}else {
    print("johnsStreet is nil")
}

///在方法的可选返回值上进行可选链式调用

if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
    print(buildingIdentifier)
}
//调用的是方法的可选返回值  所以要加上可选符号
if let beginsWithTw = john.residence?.address?.buildingIdentifier()?.hasPrefix("tw") {
    if beginsWithTw {
        print("tw")
    }else {
        print("not tw")
    }
}

		