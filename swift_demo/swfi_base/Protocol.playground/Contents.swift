//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      协议
 */

protocol FullyNamed {
    var fullName: String {get}
    
}

struct Person:FullyNamed {
    var fullName: String
}
let john = Person(fullName:"111")

class Starship:FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? (prefix! + "") : "") + name
    }
}
var ncc = Starship(name:"222",prefix:"11 ")
print(ncc.fullName)

//mutating 方法

protocol Togglabel {
    mutating func toggle()
}
enum OnOffSwitch: Togglabel {
    case Off, On
    mutating func toggle() {
        switch self {
        case .Off:
            self = .On
        default:
            self = .Off
        }
    }
}
var lightSwitch = OnOffSwitch.Off
lightSwitch.toggle()
print(lightSwitch)

///协议作为类型 协议也是一种类型
protocol RandomNumberGenerator {
    func random() -> Double
}
class Dice {

    let sides: Int
    let generator: RandomNumberGenerator
    init(sides:Int, generator:RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

class LinearCongruentialGenerator:RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    func random() -> Double {
        lastRandom = (lastRandom * a + c).truncatingRemainder(dividingBy: m) //swift3 之后对浮点型数据取余计算只能用truncatingRemainder
        return lastRandom / m
    }
}

var d6 = Dice(sides:6, generator:LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}

///代理模式

protocol DiceGame {
    var dice:Dice {get}
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game:DiceGame, didStartNewTurnWithDiceRoll diceRoll:Int)
    func gameDidEnd(_ game:DiceGame)
}
class SnakesAndLadders:DiceGame {
    let finalSquare = 25
    let dice = Dice(sides:6, generator:LinearCongruentialGenerator())
    var square = 0
    var board:[Int]
    init() {
        board = [Int](repeating:0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate:DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop:while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
            
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("new game")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("lasted for \(numberOfTurns)")
    }
    
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()

///通过扩展添加协议一致性

protocol TextRepresentable {
    var textualDescription:String {get}
}

extension Dice:TextRepresentable {
    var textualDescription: String {
        return "\(sides)"
    }
}
let d12 = Dice(sides:11, generator:LinearCongruentialGenerator())
print(d12.textualDescription)

///通过扩展遵循协议
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable{}

let simonTheHamster = Hamster(name:"123")
//let somethingText:TextRepresentable = simonTheHamster
print(simonTheHamster.textualDescription)

///协议类型的集合

let things:[TextRepresentable] = [d12, simonTheHamster]
for thing in things {
    print(thing.textualDescription)
}

///协议的继承

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextRepresentable: String {get}
}
extension SnakesAndLadders: PrettyTextRepresentable {
    internal var textualDescription: String {
        return "text"
    }
    var prettyTextRepresentable: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "+"
            case let snake where snake < 0:
                output += "-"
            default:
                output += "0"
            }
        }
        return output
    }
}
print(game.prettyTextRepresentable)

///类类型专属协议 在协议的最前面添加class

///协议合成 协议合成只是生成一个临时的协议，并不是生成一个永久的协议
protocol Named {
    var name:String {get}
}
protocol Aged {
    var age:Int {get}
}
struct PersonOne: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator:Named & Aged) {
    print("\(celebrator.name) + \(celebrator.age)")
}
let birthdayPerson = PersonOne(name: "123", age: 123)
wishHappyBirthday(to: birthdayPerson)

///定义协议的可选要求 optional @objc标记的东西只能被继承自oc类的类或者@objc类遵循

@objc protocol CounterDataSource {
    @objc optional func incrementForCount(count: Int) -> Int
    @objc optional var fixedIncrement:Int {get}
}
class Counter {
    var count = 0
    var dataSource:CounterDataSource?
    func increment() {
        if let amount = dataSource?.incrementForCount?(count: count) {
            count += amount
        }else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}
class ThreeSource:NSObject, CounterDataSource {
//    let fixedIncrement:Int = 3
    func incrementForCount(count: Int) -> Int {
        return 3
    }
}
//var counter = Counter()
//counter.dataSource = ThreeSource()
//for _ in 1...4 {
//    counter.increment()
//    print(counter.count)
//}
class TowardsZeroSource:NSObject,CounterDataSource {
    func incrementForCount(count: Int) -> Int {
        if count == 0 {
            return 0
        }else if count < 0 {
            return 1
        }else {
            return -1
        }
    }
}
var counter = Counter()
counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

///协议扩展 通过给协议扩展方法，使所有实现过这个协议的类都能使用这个方法
extension CounterDataSource {
    func printHello() {
        print("Hello")
    }
}
let counterData = TowardsZeroSource()
counterData.printHello()
///为协议添加默认实现
extension PrettyTextRepresentable {
    var prettyTextDesciption:String {
        return textualDescription
    }
}
d12.textualDescription

///为协议扩展添加限制条件
extension Collection where Iterator.Element:TextRepresentable {
    var textualDescription:String {
        let itemsAsText = self.map {$0.textualDescription}
        return "[" + itemsAsText.joined(separator: ",") + "]"
    }
}
let murrayTheHamster = Hamster(name: "murray")
let twTheHamster = Hamster(name: "tw")
let hamsters = [murrayTheHamster, twTheHamster]
print(hamsters.textualDescription)



