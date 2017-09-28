//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      构造
 */

///存储属性的初始赋值

//构造器
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0 //初始赋值
    }
}
var f = Fahrenheit()
print(f.temperature)

///自定义构造过程
struct Celsius {
    var temperaturelnCelsius:Double
    init(fromFahrenheit fahrenheit: Double) {
        temperaturelnCelsius = (fahrenheit - 32) / 1.8
    }
    init(fromKelvin kelvin:Double) {
        temperaturelnCelsius = kelvin - 273
    }
    
}
let boiling = Celsius(fromFahrenheit: 200)
print(boiling.temperaturelnCelsius)
let freezing = Celsius(fromKelvin: 273)
print(freezing.temperaturelnCelsius)

///可选属性类型
class SurveyQuestion {
    var text: String
    var response: String?
    init(text:String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "12")
cheeseQuestion.ask()
cheeseQuestion.response = "2222"

///默认构造器  如果所有的属性都有默认值那么就会创建一个默认构造器

///值类型的构造器代理
struct Size {
    var width = 0.0,height = 0.0
}
struct Point{
    var x = 0.0,y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    init() {
    }
    init(origin:Point, size:Size) {
        self.origin = origin
        self.size = size
    }
    init(center:Point, size:Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin:Point(x:originX, y:originY),size:size)
    }
}
let centerRect = Rect(center:Point(x:4.0, y:4.0), size:Size(width:3.0, height:3.0))
print(centerRect)

///构造器的继承和重写

class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels)"
    }
}
let vehicle = Vehicle()
print(vehicle.description)

class Bicycle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 3
    }
}
let bicycle = Bicycle()
print(bicycle.description)

//构造器的自动继承

class Food {
    var name: String
    init(name:String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "Unnamed")
    }
}
let namedMeat = Food(name:"123") //使用指定构造器创建实例
let mysteryMeat = Food() //使用便利构造器创建实例

class Recipelngredient:Food {
    var quantity:Int
    init(name: String, quantity:Int) {
        self.quantity = quantity
        super.init(name:name)
    }
    override convenience init(name: String) {
        self.init(name:name, quantity:1)
    }
}
let oneMysteryItem = Recipelngredient()
let oneBacon = Recipelngredient(name:"bacon")
let sixEggs = Recipelngredient(name:"egg", quantity:12)

class ShoppingListItem: Recipelngredient {
    var purchased = false
    var description:String {
        var output = "\(quantity)x\(name)"
        output += purchased ? "y": "n"
        return output
    }
}
var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name:"22"),
    ShoppingListItem(name:"11", quantity:2)
]
breakfastList[0].name = "33"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

///可失败构造器
struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}
let someCreature = Animal(species: "")

if someCreature == nil {
    print("nil")
}

///枚举类型的可失败构造器
enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol:  Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}
let fahrenheitUnit = TemperatureUnit(symbol:"F")
if fahrenheitUnit != nil {
    print("succeeded")
}

///构造失败的传递
class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
}

class CartItem: Product {
    let quantity:Int
    init?(name: String, quantity: Int) {
        if quantity < 1 {
            return nil
        }
        self.quantity = quantity
        super.init(name: name)
    }
}
if let twoSocks = CartItem(name:"sock", quantity:1) {
    print(twoSocks.name)
    print(twoSocks.quantity)
}

///重写一个可失败构造器
class Document {
    var name: String?
    //创建了一个name为nil的实例
    init() {}
    //创建了一个name非空的实例
    init?(name: String) {
        self.name = name
        if name.isEmpty {
            return nil
        }
    }
}

class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "123"
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "123"
        }else {
            self.name = name
        }
    }
}

class UntitledDocument: Document {
    override init() {
        super.init(name:"123")!
    }
}

//可失败构造器init！ 

///必要构造器 required 表示该类的所有子类都必须实现这个构造器

///通过闭包或函数设置属性的默认值
struct Checkerboard {
    let boardColor:[Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    func squarelsBlackAtRow(row:Int, column:Int) -> Bool {
        return boardColor[(row * 8) + column]
    }
}
let board = Checkerboard()
print(board.squarelsBlackAtRow(row: 0, column: 1))


