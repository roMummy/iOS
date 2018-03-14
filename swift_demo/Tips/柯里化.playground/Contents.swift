//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
///柯里化 把接受多个参数的方法进行一些变成，使其更加灵活的方法
func addOne(num: Int) -> Int {
    return num + 1
}
func addTo(_ adder: Int) -> (Int) -> Int {
    return { num in
        return num + adder
    }
}

func greaterThan(_ comparer: Int) -> (Int) -> Bool {
    return {$0 > comparer}
}
let greaterThan10 = greaterThan(10)
greaterThan10(13)

//实际运用 解决selector只能是字符串的问题
protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject>: TargetAction {
    weak var target: T?
    let action: (T) -> () -> Void
    
    func performAction() -> Void {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside
    case ValueChanged
}

class Control {
    var actions = [ControlEvent: TargetAction]()
    func setTarget<T: AnyObject>(target: T,
                                 action: @escaping (T) -> () -> (),
                                 controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}
//使用
class MyViewController {
    let button = Control()
    func viewDidload() {
        button.setTarget(target: self, action: MyViewController.onButtonTap, controlEvent: .ValueChanged)
    }
    func onButtonTap() {
        print("button")
    }
}

///将protocol的方法声明成mutating
protocol Vehicel {
    var numberOfWheels: Int {get}
    var color: UIColor {get set}
    
    mutating func changeColor()
}
struct MyCar: Vehicel {
    var numberOfWheels: Int = 4
    
    var color: UIColor = UIColor.blue
    
    mutating func changeColor() {
        color = .red
    }
    
    
}

