//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      可选值 用来表示可能缺失或是计算失败的值
 */

///字典
let cities = ["Paris": 2241, "Madrid": 3165, "Amsterdam": 827, "Berlin": 3562]
let madridPopulation:Int? = cities["Madrid"]
//可选绑定
if let madridPopulation = cities["Madrid"] {
    print(madridPopulation)
}else {
    print("nil")
}

//可选默认值
infix operator ?? {associativity right precedence 110}

func ??<T>(optional: T?, defaultValue: @autoclosure () -> T) -> T {
    if let x = optional {//如果可选值存在 那么就使用可选值
        return x
    }else {//如果不存在就使用默认值 而且只有在调用了默认值的情况下才会执行这个
        return defaultValue()
    }
}

///可选值链

struct Order {
    var orderNumber: Int
    var person: Person?
}
struct Person {
    let name: String
    let address: Address?
}
struct Address {
    let streetName: String
    let city: String
    let state: String?
}
let address = Address(streetName: "222", city: "333", state: "444")

let person = Person(name: "111", address: nil)

let order = Order(orderNumber: 3, person: person)


if let myState = order.person?.address?.state {
    print(myState)
}else {
    print("nil")
}
//可选值在switch上的应用
switch madridPopulation {
case 0?: print("Nobody in Madrid")
case (1..<1000)?: print("Less than a million in Madrid")
case .some(let x): print("\(x) people in Madrid")
case .none: print("We don't know about Madrid")
}
//可选值在guard上的应用
func populationDescriptionForCity(city: String) -> String? {
    guard let population = cities[city] else {
        return nil
    }
    return "\(population * 1000)"
}

///可选映射
func incrementOptional(_ optional: Int?) -> Int? {
    guard let x = optional else {
        return nil
    }
    return x + 1
}
extension Optional {
    //如果可选值存在就进行计算 否则就返回nil
    func map<T>(_ tranform: (Wrapped) -> T) -> T? {
        guard let x = self else {
            return nil
        }
        return tranform(x)
    }
}
func incrementOptional2(_ optional: Int?) -> Int? {
    return optional.map{$0 + 1}
}

///可选绑定
let x: Int? = 3
let y: Int? = nil
//let z: Int? = x! + y!

func addOptionals(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    guard let x = optionalX, let y = optionalY else {
        return nil
    }
    return x + y
}

extension Optional {
    func flatMap<T>(_ f: (Wrapped) -> T?) -> T? {
        guard let x = self else {
            return nil
        }
        return f(x)
    }
}

func addOptionals2(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    return optionalX.flatMap{x in
        optionalY.flatMap{y in
            x + y}}
}

