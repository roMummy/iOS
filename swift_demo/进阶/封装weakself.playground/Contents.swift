import UIKit

var str = "Hello, playground"


//class TextInputView {
//  var onClick: ((String?) -> Void)?
//
//  func click(text: String) {
//    onClick?(text)
//  }
//}
//
//class ViewController {
//  var text: String?
//  func viewDidLoad() {
//    let input = TextInputView()
//    input.onClick = { text in
//      self.text = text
//      print(text)
//    }
//
//  }
//}

/// 隐蔽方式屏蔽
//class Delegate<Input, Output> {
//  private var block: ((Input) -> Output?)?
//  func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
//    self.block = {[weak target] input in
//      guard let target = target else {return nil}
//      return block?(target, input)
//    }
//  }
//  func call(_ input: Input) -> Output? {
//    return block?(input)
//  }
//}
//
//class TextInputView {
//  var onClick = Delegate<String?, Void>()
//
//  func click(text: String) {
//    onClick.call(text)
//  }
//}
//
//class ViewController {
//  var text: String?
//  func viewDidLoad() {
//    let input = TextInputView()
//    input.onClick.delegate(on: self) { (weakSelf, text) in
//      weakSelf.text = text
//    }
//  }
//}

/// callAsFunction swift5.2 able

struct Adder {
  let value: Int
  func callAsFunction(_ input: Int) -> Int {
    return input + value
  }
}



