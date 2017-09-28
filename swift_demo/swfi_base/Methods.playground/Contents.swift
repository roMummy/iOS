//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///在实例方法中修改值类型 mutating 可以改变结构体中的属性 实例必须是可变类型
struct Point {
    var x = 0.0,y = 0.0
    mutating func moveByX(deltaX:Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var somePoint = Point(x:1.0,y:1.0)
somePoint.moveByX(deltaX: 2.0, y: 3.0)

///在可变方法中给self赋值
//struct Point {
//    var x = 0.0,y = 0.0
//    mutating func moveByX(deltaX:Double, y deltaY: Double) {
//        self = Point(x:x + deltaX, y:y + deltaY)
//    }
//}
enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case .Off:
            self = .Low
        case .Low:
            self = .High
        case .High:
            self = .Off
        }
    }
}
var ovenLight = TriStateSwitch.Low
ovenLight.next()

///类型方法
class SomeClass {
    static func someTypeMethed() {
        
    }
}
SomeClass.someTypeMethed()

struct LevelTracher {
    static var highestUnlockedLevel = 1
    var currenLevel = 1
    //解锁等级
    static func unlock(_ level:Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    @discardableResult //不会产生编译警告
    mutating func advance(to level:Int) -> Bool {
        if LevelTracher.isUnlocked(level) {
            currenLevel = level
            return true
        }else {
            return false
        }
    }
}
//玩家数据更新
class Player {
    var tracker = LevelTracher()
    let playerName:String
    func complete(level:Int) {
        LevelTracher.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}
//第一个玩家
var player = Player(name:"123")
player.complete(level: 1)
print(LevelTracher.highestUnlockedLevel)
//第二个玩家
player = Player(name:"111")
if player.tracker.advance(to: 6) {
    print("6")
}else {
    print("not unlocked")
}
		