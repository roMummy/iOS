//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 *      枚举
 */

enum Encoding {
    case ASCII
    case UTF8
    case NEXTSTEP
    case JapaneseEUC
}

//let myEncoding = Encoding.ASCII + Encoding.JapaneseEUC

enum LookupError: Error {
    case CapitalNotFound
    case PopulationNotFound
}

enum PopulationResult {
    case Success(Int)
    case Error(LookupError)
}
let exampleSuccess:PopulationResult = .Success(1000)
let capitals = [
    "111": 111,
    "222": 222,
    "333": 333
]
let cities = [
    111: 111 * 1000,
    222: 222 * 1000,
    333: 333 * 1000
]

func populationOfCapital(country: String) -> PopulationResult {
    guard let capital = capitals[country] else {
        return .Error(.CapitalNotFound)
    }
    guard let population = cities[capital] else {
        return .Error(.PopulationNotFound)
    }
    return .Success(population)
}

switch populationOfCapital(country: "111") {
case let .Success(population):
    print(population)
case let .Error(error):
    print(error)
}

///添加泛型
let mayors = [
    "Paris": "Hidalgo",
    "Madrid": "Carmena",
    "Amsterdam": "van der Laan",
    "Berlin": "Müller"
]
//func mayorsOfCapital(country: String) -> String? {
//    return capitals[country].flatMap{mayors[$0]}
//}

enum Result<T> {
    case Success(T)
    case Error(Error)
}

///swift中的错误处理

//使用throws
func populationOfCapital1(country: String) throws -> Int {
    guard let capital = capitals[country] else {
        throw LookupError.CapitalNotFound
    }
    guard let population = cities[capital] else {
        throw LookupError.PopulationNotFound
    }
    return population
}

//调用throws函数
do {
    let population = try populationOfCapital1(country: "1111")
    print(population)
}catch {
    print(error)
}

func ??<T>(result: Result<T>, handleError: (Error) -> T) -> T {
    switch result {
    case let .Success(value):
        return value
    case let .Error(error):
        return handleError(error)
    }
}

/*如果两个类型A和B在相互转换时不会丢失任何信息，那么它们就是同构的
 * enum Zero{} ---空枚举
 * typealias One = () ---空类型
 */
