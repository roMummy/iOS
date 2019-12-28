import UIKit
import PlaygroundSupport

var str = "Hello, playground"


let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))

view.backgroundColor = .red

PlaygroundPage.current.liveView = view

public struct Animation {
  public let duration: TimeInterval
  public let closure: (UIView) -> Void
}
extension Animation {
  static func fadeIn(duration: TimeInterval = 0.3) -> Animation {
    return Animation(duration: duration, closure: {$0.alpha = 1})
  }
  
  static func resize(to size: CGSize, duration: TimeInterval = 0.3) -> Animation {
    return Animation(duration: duration, closure: {$0.bounds.size = size})
  }
  
}

public extension UIView {
  // 串行
  func animate(_ animations: [Animation]) {
    guard !animations.isEmpty else {
      return
    }
    var animations = animations
    // 使用递归的方式执行所有的动画
    let animation = animations.removeFirst()
    
    UIView.animate(withDuration: animation.duration, animations: {
      animation.closure(self)
    }) { _ in
      self.animate(animations)
    }
  }
  // 并行
  func animate(inParallel animations: [Animation]) {
    for animation in animations {
      UIView.animate(withDuration: animation.duration) {
        animation.closure(self)
      }
    }
  }
  
  
}

//let animationView = UIView(frame: CGRect(
//  x: 0, y: 0,
//  width: 50, height: 50
//))
//
//animationView.backgroundColor = .blue
//animationView.alpha = 0
//
//view.addSubview(animationView)
//animationView.animate([
//  .fadeIn(),
//  .resize(to: CGSize(width: 400, height: 400),duration: 3),
//  .fadeIn()
//])


internal enum AnimationMode {
  case inSequence
  case inParallel
}

public final class AnimationToken {
  private let view: UIView
  private let animations: [Animation]
  private let mode: AnimationMode
  private var isValid = true
  
  internal init(view: UIView, animations: [Animation], mode: AnimationMode) {
    self.view = view
    self.animations = animations
    self.mode = mode
  }
  
  deinit {
    perform {}
  }
  
  internal func perform(completionHandler: @escaping () -> Void) {
    guard isValid else {return}
    
    isValid = false
    switch mode {
    case .inSequence:
      view.performAnimations(animations, completionHandler: completionHandler)
    case .inParallel:
      view.performAnimationsInParallel(animations, completionHandler: completionHandler)
    }
  }
  
  
}

public extension UIView {
  @discardableResult
  func animate(_ animations: [Animation]) -> AnimationToken {
    return AnimationToken(view: self, animations: animations, mode: .inSequence)
  }
  // 并行
  @discardableResult
  func animate(inParallel animations: [Animation]) -> AnimationToken {
    return AnimationToken(view: self, animations: animations, mode: .inParallel)
  }
}

internal extension UIView {
  func performAnimations(_ animations: [Animation], completionHandler: @escaping () -> Void) {
    guard !animations.isEmpty else {
      return completionHandler()
    }
    var animations = animations
    let animation = animations.removeFirst()
    UIView.animate(withDuration: animation.duration, animations: {
      animation.closure(self)
    }) { _ in
      self.performAnimations(animations, completionHandler: completionHandler)
    }
  }
  
  func performAnimationsInParallel(_ animations: [Animation], completionHandler: @escaping () -> Void) {
    guard !animations.isEmpty else {
      return completionHandler()
    }
    
    let animationCount = animations.count
    var completionCount = 0
    let animationCompletionHandler = {
      completionCount += 1
      if completionCount == animationCount {
        completionHandler()
      }
    }
    
    for animation in animations {
      UIView.animate(withDuration: animation.duration, animations: {
        animation.closure(self)
      }) { _ in
        animationCompletionHandler()
      }
    }
  }
  
}

public func animate(_ tokens: [AnimationToken]) {
  guard !tokens.isEmpty else {return}
  
  var tokens = tokens
  let token = tokens.removeFirst()
  token.perform {
    animate(tokens)
  }
}

public func animate(_ tokens: AnimationToken...) {
  animate(tokens)
}

public extension UIView {
  @discardableResult
  func animate(_ animations: Animation...) -> AnimationToken {
    return animate(animations)
  }
  
  @discardableResult
  func animate(inParallel animations: Animation...) -> AnimationToken {
    return animate(inParallel: animations)
  }
}

let label = UILabel()
label.text = "Let's animate..."
label.sizeToFit()
label.center = view.center
label.alpha = 0
view.addSubview(label)

let button = UIButton(type: .system)
button.setTitle("...multiple views!", for: .normal)
button.sizeToFit()
button.center.x = view.center.x
button.center.y = label.frame.maxY + 50
button.alpha = 0
view.addSubview(button)

//animate([
//  label.animate([
//    .fadeIn(duration: 3),
//    .resize(to: CGSize(width: 100, height: 100), duration: 3)
//  ]),
//  button.animate([
//    .fadeIn(duration: 3)
//  ])
//])

animate(
    label.animate(
        .fadeIn(duration: 3)
    ),
    button.animate(.fadeIn(duration: 3))
)
