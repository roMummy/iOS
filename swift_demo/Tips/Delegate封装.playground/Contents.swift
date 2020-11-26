import UIKit

var str = "Hello, playground"


// 目的：替换swift中繁琐使用delegate的问题
// 把delegate 封装成闭包的形式 并且在闭包中使用weak 防止强引用
// https://onevcat.com/2020/03/improve-delegate/


class Delegate<Input, Output> {
  private var block: ((Input) -> Output?)?
  
  func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> Output)?) {
    self.block = { [weak target] input in
      guard let target = target else {
        return nil
      }
      return block?(target, input)
    }
  }
  
  func call(_ input: Input) -> Output? {
    return block?(input)
  }
}

public protocol OptionalProtocol {
    static var createNil: Self { get }
}

extension Optional : OptionalProtocol {
    public static var createNil: Optional<Wrapped> {
         return nil
    }
}

extension Delegate where Output: OptionalProtocol {
  internal func call(_ input: Input) -> Output {
        if let result = block?(input) {
            return result
        } else {
            return .createNil
        }
    }
}

class TextInputView: UIView {
  let onSuccess = Delegate<String?, Void>()
  
  func onClick(text: String) {
    onSuccess.call(text)
  }
}

class ViewController: UIViewController {
  
  @IBOutlet weak var textLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let inputView = TextInputView()
    inputView.onSuccess.delegate(on: self) { (weakSelf, text) in // 这里的不需要写weak 直接用weakSelf 替代
      
      print(text ?? "")
    }
    
    view.addSubview(inputView)
  }
}

let vc = ViewController()
let view = TextInputView()
view.onClick(text: "hhhh")


