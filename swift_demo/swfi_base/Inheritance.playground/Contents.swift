//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      继承
 */
class Vehicle {
    var currentSpeed = 0.0
    var description:String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        
    }
}
let someVehicle = Vehicle()
print(someVehicle.description)

///子类
class Bicycle:Vehicle {
    var hasBasket = false
}
let bicycle = Bicycle()
bicycle.hasBasket = true
bicycle.currentSpeed = 15.0

///重写 override 可以用super来访问超类版本的方法
class Train:Vehicle {
    override func makeNoise() {
        print("123")
    }
    var gear = 1
    
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}
let train = Train()
train.makeNoise()
print(train.description)

///防止重写 final

