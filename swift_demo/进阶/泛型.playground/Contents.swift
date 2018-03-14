//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

//自由函数的重载
func raise(_ base: Double, to exponent: Double) -> Double {
    return pow(base, exponent)
}
func raise(_ base: Float, to exponent: Float) -> Float {
    return powf(base, exponent)
}
let double = raise(2.0, to: 2.0)
type(of: double)
let float: Float = raise(2.0, to: 2.0)
type(of: float)

func log<View: UIView>(_ view: View) {
    print("it`s a \(type(of: view)), frame:\(view.frame)")
}
func log(_ view: UILabel) {
    let text = view.text ?? ""
    print(text)
}
let label = UILabel()
label.text = "label"
log(label)
let button = UIButton()
log(button)
//编译器会依据变量的静态类型来决定要调用哪一个重载，不是在运行时来决定的
let views = [label,button]
for view in views {
    log(view)
}

///运算符的重载
//定义幂运算
precedencegroup tt{//优先级定义
    associativity: left //结合方向
    higherThan: MultiplicationPrecedence //高于乘法类型
}
infix operator **: tt
func **(lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}
func **(lhs: Float, rhs: Float) -> Float {
    return powf(lhs, rhs)
}
2*2.0**3.0

//让所有整数都支持
//func **<i: SignedInteger>(lhs: i, rhs: i) -> i {
//    let result = Double(lhs.max) ** Double(rhs.max)
//    return numericCast(IntMax(result))
//}

///使用泛型约束进行重载

extension Sequence where Iterator.Element: Hashable {
    func isSubset(of other: [Iterator.Element]) -> Bool {//判断是不是子集
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

let oneToThere = [1,2,3]
let fiveToOne = [5,4,3,2,1]
oneToThere.isSubset(of: fiveToOne)

extension Sequence where Iterator.Element: Hashable {//泛型版本
    func isSubset<S: Sequence>(of other: S) -> Bool
        where S.Iterator.Element == Iterator.Element {
            let otherSet = Set(other)
            for element in self {
                guard otherSet.contains(element) else {
                    return false
                }
            }
            return true
    }
}
func dPrint(_ item: @autoclosure () -> Any) {//debug才打印
    #if DEBUG
        print(item())
    #endif
}
dPrint("123456")
[1,3,5].isSubset(of: 1...10)

///使用闭包对行为进行参数化

extension Sequence {
    func isSubset<S: Sequence>(of other: S,
                               by areEquivalent: (Iterator.Element, S.Iterator.Element) -> Bool)
        -> Bool {
            for element in self {
                guard other.contains(where: {areEquivalent(element, $0)}) else{return false}
            }
            return true
    }
}
//[[1,2]].isSubset(of: [[1,2],[3,4]]){$0 == $1}
let ints = [1,2]
let strings = ["1","2","3"]
//ints.isSubset(of: strings){String($0) == $1}

///对集合采用泛型操作
//二分查找
extension Array {
    func binarySearch
        (for value: Element, areInIncreasingOrder:(Element,Element) -> Bool)
        -> Int? {
            var left = 0
            var right = count - 1
            
            while left <= right {
                let mid = (left + right) / 2
                let candidate = self[mid]
                
                if areInIncreasingOrder(candidate, value) {
                    left = mid + 1
                }else if areInIncreasingOrder(value, candidate) {
                    right = mid - 1
                }else {//只有左右两个相等才会返回中间值
                    return mid
                }
            }
            return nil
    }
}

extension Array where Element: Comparable {
    func binarySearch(for value: Element) -> Int? {
        return self.binarySearch(for: value, areInIncreasingOrder: <)
    }
}

extension RandomAccessCollection where Index == Int, IndexDistance == Int{//只满足Int的二分查找
    public func binarySearch(for value: Iterator.Element,
                             areInIncreasingOrder: (Iterator.Element, Iterator.Element) -> Bool)
        -> Index? {
            var left = 0
            var right = count - 1
            
            while left <= right {
                let mid = (left + right) / 2
                let candidate = self[mid]
                
                if areInIncreasingOrder(candidate, value) {
                    left = mid + 1
                }else if areInIncreasingOrder(value, candidate) {
                    right = mid - 1
                }else {//只有左右两个相等才会返回中间值
                    return mid
                }
            }
            return nil
    }
}
let binaryInt = [1,3,2,6,4]
//let bin = binaryInt[1..<3]
//bin.binarySearch(for: 2, areInIncreasingOrder: <)
print(binaryInt ?? 000)

//泛型二分查找
extension RandomAccessCollection {
    public func binarySearch(for value: Iterator.Element,
                             areInIncreasingOrder: (Iterator.Element, Iterator.Element) -> Bool)
        -> Index? {
            guard !isEmpty else {
                return nil
            }
            var left = startIndex
            var right = index(before: endIndex)
            while left <= right {
                let dist = distance(from: left, to: right)  //计算left到right的距离
                let mid = index(left, offsetBy: dist/2)
                let candidate = self[mid]
                
                if areInIncreasingOrder(candidate, value) {
                    left = index(after: mid)
                }else if areInIncreasingOrder(value, candidate) {
                    right = index(before: mid)
                }else {
                    return mid
                }
            }
            return nil
    }
}
extension RandomAccessCollection where Iterator.Element: Comparable {
    func binarySearch(for value: Iterator.Element) -> Index? {
        return binarySearch(for: value, areInIncreasingOrder: <)
    }
}

let a = ["a", "c", "d", "g"]
let r = a.reversed()
r.binarySearch(for: "d", areInIncreasingOrder: >) == r.startIndex
let s = a[1..<3]
s.startIndex
s.binarySearch(for: "d")

///集合随机排列
extension Array {
    mutating func shuffle(){
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else {//保证不会将一个元素与自己交换
                continue
            }
            
            self.swapAt(i, j)//将两个元素交换
        }
    }
    
    func shuffled() -> [Element] {//不可变版本
        var clone = self
        clone.shuffle()
        return clone
    }
}
//extension MutableCollection where Self: RandomAccessCollection {
//    mutating func shuffle() {
//        var i = startIndex
//        let beforeEndIndex = index(before: endIndex)
//        while i < beforeEndIndex {
//            let dist = distance(from: i, to: endIndex)
//            let randomDistance = IndexDistance.distance(dist)
//            let j = index(i, offsetBy: randomDistance)
//            guard i !=  else {
//                continue
//            }
//            swap(&self[i], &self[j]
//            formIndex(after: &i))
//        }
//    }
//}


///subsequence 和泛型算法
extension Collection where Iterator.Element: Equatable {
    func search<Other: Sequence>(for pattern: Other) -> Index?
       where Other.Iterator.Element == Iterator.Element {
        return indices.first(where: { (idx) -> Bool in
            suffix(from: idx).starts(with: pattern)
        })
    }
}
let text = "it was the best of times"
text.search(for: ["w","a","s"])

extension RandomAccessCollection
    where Iterator.Element: Equatable,
        Indices.Iterator.Element == Index,
        SubSequence.Iterator.Element == Iterator.Element,
        SubSequence.Indices.Iterator.Element == Index {
    func search<Other: RandomAccessCollection>(for pattern: Other) -> Index?
    where Other.IndexDistance == IndexDistance,
        Other.Iterator.Element == Iterator.Element{
            guard !isEmpty && pattern.count <= count else {
                return nil
            }
            let stopSearchIndex = index(endIndex, offsetBy: -pattern.count)
            return prefix(upTo: stopSearchIndex).indices.first(where: { (idx) -> Bool in
                suffix(from: idx).starts(with: pattern)
            })
    }
}
let numbers = 1..<100
numbers.search(for: 80..<90)

///使用泛型进行代码设计
class User {
    init(_ name: String) {
        
    }
}
//func loadUsers(callback: ([User]?) -> Void) {
//    let usersURL = URL.init(string: "www.baidu.com")
//    let data = try? Data.init(contentsOf: usersURL!)
//    let json = data.flatMap{
//        try? JSONSerialization.jsonObject(with: $0, options: [])
//    }
////    let users = (json as? [Any]).flatMap{
////        $0.flatMap(User.init())
////    }
////    callback(users)
//}
func loadResource<A>(at path: String,
                     parse: (Any) -> A?,
                     callBack: (A?) -> Void) {
    let resourceURL = URL.init(string: "www.baidu.com")?.appendingPathComponent(path)
    let data = try? Data.init(contentsOf: resourceURL!)
    let json = data.flatMap{
        try? JSONSerialization.jsonObject(with: $0, options: [])
    }
    callBack(json.flatMap(parse))
}
func loadUsers(callBack: ([User]?) -> Void) {
//    loadResource(at: "/users", parse: jsonArray(User.init), callBack: callBack)
}
func jsonArray<A>(_ transform: @escaping (Any) -> A?) -> (Any) -> [A]? {
    return { array in
        guard let array = array as? [Any] else {
            return nil
        }
        return array.flatMap(transform)
    }
}

//穿件泛型数据类型
struct Resource<A> {
    let path: String    //路径
    let parse: (Any) -> A?  //转换方法
}
extension Resource {
    func loadSynchronously(callback: (A?) -> Void) {//请求方法
        let resourceURL = URL.init(string: "www.baidu.com")?.appendingPathComponent(path)
        let data = try? Data.init(contentsOf: resourceURL!)
        let json = data.flatMap{
            try? JSONSerialization.jsonObject(with: $0, options: [])
        }
        callback(json.flatMap(parse))
    }
}
extension Resource {
    func loadAsynchronously(callback: @escaping (A?) -> Void) {
        let resourceURL = URL.init(string: "www.baidu.com")?.appendingPathComponent(path)
        let session = URLSession.shared
        session.dataTask(with: resourceURL!) { (data, response, error) in
            let json = data.flatMap{
                try? JSONSerialization.jsonObject(with: $0, options: [])
            }
            callback(json.flatMap(self.parse))
        }.resume()
    }
}

///泛型的工作方式
func min<T: Comparable>(_ x: T, _ y: T) -> T {
    return y < x ? y : x
}
//泛型的所有泛型参数都是存在一个容器中的，同时还有一个协议目击表来存储泛型参数对应的关系，只有满足这个关系表的参数才能使用协议目击表派发的函数 编译一次，动态派发

///泛型特化 “编译器按照具体的参数参数类型 (比如 Int)，将 min<T> 这样的泛型类型或者函数进行复制。特化后的函数可以将针对 Int 进行优化，移除所有的额外开销” 避免额外开销
func min(_ x: Int, _ y: Int) -> Int {//泛型特化后的min函数
    return y < x ? y : x
}

///全模块优化 “ swiftc 传递 -whole-module-optimization 来开启全模块优化”



