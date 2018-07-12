//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///Whole 泛指数据结构本身的类型 Subpart 指代了结构中特定字段的类型
typealias Lens<Subpart, Whole> = (@escaping (Subpart) -> (Subpart)) -> (Whole) -> Whole
func lens<Subpart, Whole>(view: @escaping(Whole) -> Subpart, set: @escaping(Subpart, Whole) -> Whole) -> Lens<Subpart, Whole> {
    return {mapper in {set(mapper(view($0)), $0)}}
}
struct Point {
    let x: CGFloat
    let y: CGFloat
}
extension Point {
    static let xLens = lens(view: {$0.x}, set: {Point(x: $0, y: $1.y)})
    static let yLens = lens(view: {$0.y}, set: {Point(x: $1.x, y: $0)})
}
struct Line {
    let start: Point
    let end: Point
}
extension Line {
    static let startLens = lens(view: {$0.start}, set: {Line(start: $0, end: $1.end)})
    static let endLens = lens(view: {$0.end}, set: {Line(start: $0, end: $1.end)})
}

func over<Subpart, Whole>(mapper: @escaping(Subpart) -> Subpart, lens: Lens<Subpart, Whole>) -> (Whole) -> Whole {
    return lens(mapper)
}
func set<Subpart, Whole>(value: Subpart, lens: Lens<Subpart, Whole>) -> (Whole) -> Whole {
    return over(mapper: {_ in value}, lens: lens)
}

func >>> <A, B, C> (lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return rhs{lhs{$0}}
}
func <<< <A, B, C> (lhs: @escaping (B) -> C, rhs: @escaping (A) -> B) -> (A) -> C {
    return lhs{rhs{$0}}
}

extension WritableKeyPath {
    var toLens: Lens<Value, Root> {
        return lens(view: {$0[keyPath: self]}, set: {
            var copy = $1
            copy[KeyPath: self] = $0
            return copy
        })
    }
}
let lineStartXLens = Line.startLens <<< Point.xLens
let startMoveRight3 = over(mapper: {$0 + 3}, lens: lineStartXLens)
//let bLine = startMoveRight3(aLine)

let test = ""[{\"k\":\"A\",\"v\":\"\U6d4b\U8bd5\"},{\"k\":\"B\",\"v\":\"\U6d4b\U8bd5\"},{\"k\":\"C\",\"v\":\"\U6d4b\U8bd5\"},{\"k\":\"D\",\"v\":\"\U6d4b\U8bd5\"},{\"k\":\"E\",\"v\":\"\U6d4b\U8bd5\"},{\"k\":\"F\",\"v\":\"\U6d4b\U8bd5\"}]""

