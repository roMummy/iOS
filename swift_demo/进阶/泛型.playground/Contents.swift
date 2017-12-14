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



