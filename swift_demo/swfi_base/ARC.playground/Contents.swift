//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      自动引用计数 只适用于类
 */

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) init")
    }
    
    deinit {
        print("\(name) deinit")
    }
}
var reference1:Person?
var reference2:Person?
var reference3:Person?

reference1 = Person(name:"111")
reference2 = reference1
reference3 = reference1

reference1 = nil
reference2 = nil

reference3 = nil //只有所有的强引用都被销毁之后 Person实例才会被销毁

///类实例之间的循环强引用
class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
    }
    var tenant: Person?
    deinit {
        print("\(unit) deinit")
    }
    
}

///解决实例之间的循环强引用 “两个属性的值都允许为nil，并会潜在的产生循环强引用。这种场景最适合用弱引用来解决--weak “一个属性的值允许为nil，而另一个属性的值不允许为nil，这也可能会产生循环强引用。这种场景最适合通过无主引用来解决--unowned

///闭包引起的循环强引用
class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML:(Void) -> String = {
        [unowned self] in//设置捕获列表 [weak self]
        if let text = self.text {
            return "\(self.name) \(self.text)"
        }else {
            return "\(self.name)"
        }
    }
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) deinit")
    }
}
let heading = HTMLElement(name:"p")
let defaultText = "text"
heading.asHTML = {
    return "333"
}
print(heading.asHTML())

var paragraph: HTMLElement? = HTMLElement(name:"p", text:"444")
print(paragraph!.asHTML())
paragraph = nil

		