//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      Map Filter Reduce
 */
//传入一个数组 根据传入的规则进行计算 返回一个新的数组
func computeIntArray(_ xs: [Int], _ transform: (Int) -> Int) -> [Int] {
    var result:[Int] = []
    for x in xs {
        result.append(transform(x))
    }
    return result
}
//返回传入数组各项值的2倍
func doubleArray(xs: [Int]) -> [Int] {
    return computeIntArray(xs){x in x * x}
}

//泛型 传入一个数组 然后根据传入的规则 返回一个新的数组
extension Array {
    func map<T>(_ transform: (Element) -> T) -> [T] {
        var result:[T] = []
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

///Filter

let exampleFiles = ["README.md","hello.swift","123.swift"]
func getSwiftFiles1(_ files: [String]) -> [String] {
    var result:[String] = []
    for file in files {
        if file.hasSuffix(".swift") {//hasSuffix是否是以一个字符串结束
            result.append(file)
        }
    }
    return result
}
getSwiftFiles1(exampleFiles)

extension Array {
    //对于数组中的所有元素 判断是否包含在结果中
    func filter(includeElement: (Element) -> Bool) -> [Element] {
        var result:[Element] = []
        for x in self where includeElement(x) {
            result.append(x)
        }
        return result
    }
}
func getSwiftFiles2(_ files: [String]) -> [String] {
    return files.filter{file in file.hasSuffix(".swift")}
}

///Reduce 遍历数组并计算结果

//计算数组中的所有和
func sum(_ xs: [Int]) -> Int {
    var result: Int = 0
    for x in xs {
        result += x
    }
    return result
}

extension Array {
    func reduce<T>(_ initial: T, _ combine: (T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
}

func sumUsingReduce(xs: [Int]) -> Int {
//    return xs.reduce(0){result,x in result + x}
//    return xs.reduce(0, { (x, result) -> Int in
//        result + x
//    })
    return xs.reduce(0){$0 + $1}
    return xs.reduce(0, +)
}

//将一个双重数组展开成一个数组
func flatten<T>(xss:[[T]]) -> [T] {
    var result:[T] = []
    for xs in xss {
        result += xs
    }
    return result
}

func flattenUsingReduce<T>(xss:[[T]]) -> [T] {
    return xss.reduce([], {result,xs in result + xs})
}
//使用reduce重新定义map 和 filter
extension Array {
    func mapUsingReduce<T>(transform: (Element) -> T) -> [T] {
        return reduce([]){result,x in
            return result + [transform(x)]
        }
    }
    func filterUsingReduce(includeElement:  (Element) -> Bool) -> [Element] {
        return reduce([]){result,x in
            return includeElement(x) ? (result + [x]) : result
        }
    }
}

///实际运用

struct City {
    let name: String
    let population:Int
}

extension City {
    //换算数量
    func cityByScalingPopulation() -> City {
        return City(name: name, population: population * 1000)
    }
}
let paris = City(name: "Paris", population: 2241)
let madrid = City(name: "Madrid", population: 3165)
let amsterdam = City(name: "Amsterdam", population: 827)
let berlin = City(name: "Berlin", population: 3562)
let cities = [paris, madrid, amsterdam, berlin]
//筛选数组中数量大于1000的城市
let citieScreening = cities.filter{$0.population > 1000}.map{$0.cityByScalingPopulation()}.reduce("City:Population"){result,c in
    return result + "\n" + "\(c.name):\(c.population)"
}
print(citieScreening)

///泛型和Any类型 区别：1.泛型可以用于定义灵活的函数，类型检查仍然由编译器负责；2.Any类型可以避开swift的类型检查(少用)
//返回参数本身 泛型
func noOp<T>(x: T) -> T {
    return x
}
//返回参数本身 Any 返回的类型不一定和参数是一样的
func noOpAny(x: Any) -> Any {
    return x
}

infix operator >>> {associativity left}
func >>><A, B, C>(f:@escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return {x in g(f(x))}//x代表A 最终得到 (A) -> C
}

func curry<A, B, C>(f:@escaping (A, B) -> C) -> (A) -> (B) -> C {
    return {x in {y in f(x,y)}} //x代表A，y代表B 最终得到 (A) -> (B) -> C
}



