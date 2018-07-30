//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///codable
struct Cat: Codable {
    let name: String
    let age: Int
}
let kitten = Cat(name: "kitten", age: 1)
let encode = JSONEncoder()
//JSONEncodern 内部把编码转成了字典， 再把字典转成了data 再把data转成了字典
do {
    let data = try encode.encode(kitten)
    _ = try JSONSerialization.jsonObject(with: data, options: [])
}catch {
    print(error)
}

///Mirror
//let mirror = Mirror.init(reflecting: kitten)
//for child in mirror.children {
//    print("\(child.label)-\(child.value)")
//}


protocol DictionaryValue {
    var value: Any {get}
}
extension Int: DictionaryValue {var value: Any{return self}}
extension Float: DictionaryValue {var value: Any{return self}}
extension String: DictionaryValue {var value: Any{return self}}
extension Bool: DictionaryValue {var value: Any{return self}}
//extension Array: DictionaryValue where Element: DictionaryValue {
//    var value: Any {return map{$0.value}}
//}
//extension Dictionary: DictionaryValue where Value: DictionaryValue {
//    var value: Any {return mapValues{$0.value}}
//}
extension Array: DictionaryValue {
    var value: Any { return map { ($0 as! DictionaryValue).value } }
}
extension Dictionary: DictionaryValue {
    var value: Any { return mapValues { ($0 as! DictionaryValue).value } }
}

extension DictionaryValue {
    var value: Any {
        let mirror = Mirror(reflecting: self)
        var result = [String: Any]()
        for child in mirror.children {
            //如果无法获取到正确的key ，报错
            guard let key = child.label else {
                fatalError("Invaild key in child: \(child)")
            }
            //
            if let value = child.value as? DictionaryValue {
                result[key] = value.value
            }else {
                fatalError("Invaild value in child: \(child)")
            }
        }
        return result
    }
}

struct Cats: DictionaryValue {
    let name: String
    let age: Int
}
struct Wizard: DictionaryValue {
    let name: String
    let cat: Cats
}
struct Gryffindor: DictionaryValue {
    let wizards: [Wizard]
}


let crooks = Cats(name: "Crookshanks", age: 2)
let hermione = Wizard(name: "Hermione", cat: crooks)

let hedwig = Cats(name: "hedwig", age: 3)
let harry = Wizard(name: "Harry", cat: hedwig)

let gryffindor = Gryffindor(wizards: [harry, hermione])

print(gryffindor.value)




