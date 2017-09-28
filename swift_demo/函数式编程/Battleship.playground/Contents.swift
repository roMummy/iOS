//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 * 在swift中函数是一等值，函数式编程的核心观念就是函数是一个值
 */

typealias Distance = Double
//区域
typealias Region = (Position) -> Bool

struct Position {
    var x: Double
    var y: Double
}
extension Position {
    //是否在范围中
    func inRange(range: Distance) -> Bool {
        return sqrt(x*x + y*y) <= range
    }
}
struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}
extension Position {
    //计算相差值
    func minus(p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    //计算半径
    var length: Double {
        return sqrt(x*x + y*y)
    }
}
//extension Ship {
//    func canSafelyEngageShipTwo(target: Ship, friendly: Ship) -> Bool {
//        let targetDistance = target.position.minus(p: position).length
//        let friendlyDistance = friendly.position.minus(p: position).length
//        return (targetDistance <= firingRange) && (targetDistance > unsafeRange) && (friendlyDistance > unsafeRange)
//    }
//}
//一个以原点为圆心的圆
func circle(radius: Distance) -> Region {
    return {point in point.length <= radius
    }
}
//一个圆心在任意位置的圆
func circleAtAnyWhere(radius: Distance, center: Position) -> Region {
    return {point in point.minus(p: center).length <= radius}
}
//区域变换函数
func shift(region: @escaping Region, offset: Position) -> Region {
    return {point in region(point.minus(p: offset))}
}
//创建一个原点为5，5半径为2的圆
shift(region: circle(radius: 2), offset: Position(x: 5, y: 5))
//一个区域之外的区域
func invert(_ region: @escaping Region) -> Region {
    return { point in !region(point) }
}
//交集
func intersection(_ region1: @escaping Region,_ region2: @escaping Region) -> Region {
    return {point in region1(point) && region2(point)}
}
//并集
func union(_ region1: @escaping Region, _ region2: @escaping Region) -> Region {
    return {point in region1(point) || region2(point)}
}
//减去一个区域 在第一个区域没有在第二个区域的合并成一个区域
func difference(region: @escaping Region, minus: @escaping Region) -> Region {
    return intersection(region, invert(minus))
}

//重构canSafelyEngageShipTwo
extension Ship {
    func canSafelyEngageShipTwo(_ target: Ship, _ friendly: Ship) -> Bool {
        let rangeRegion = difference(region: circle(radius: firingRange), minus: circle(radius: unsafeRange))
        let firingRegion = shift(region: rangeRegion, offset: position)
        let friendlyRegion = shift(region: circle(radius: unsafeRange), offset: friendly.position)
        let resultRegion = difference(region: firingRegion, minus: friendlyRegion)
        return resultRegion(target.position)
    }
}

