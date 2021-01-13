import UIKit
import PlaygroundSupport

var str = "Hello, playground"

/// source: https://onevcat.com/2020/10/use-options-pattern/

/*
 Option Pattern 是一种受到 SwiftUI 的启发的模式，它帮助我们在不添加存储属性的前提下，提供了一种向已有类型中以类型安全的方式添加“存储”的手段。

 这种模式非常适合从外界对已有的类型进行功能上的添加，或者是自下而上地对类型的使用方式进行改造。这项技术可以对 Swift 开发和 API 设计的更新产生一定有益的影响。反过来，了解这种模式，相信对于理解 SwiftUI 中的很多概念，比如 PreferenceKey 和 alignmentGuide 等，也会有所助益。
 */

public protocol TrafficLightOption {
  associatedtype Value
  
  static var defaultValue: Value {get}
}


extension TrafficLight {
  public enum GreenLightColor: TrafficLightOption {
    case green
    case turquoise
    
    public static var defaultValue: GreenLightColor = .green
  }
}

extension TrafficLight {
  public var preferredGreenLightColor: TrafficLight.GreenLightColor {
    get {self[option: GreenLightColor.self]}
    set {self[option: GreenLightColor.self] = newValue}
  }
}

extension TrafficLight.GreenLightColor {
  var color: UIColor {
    switch self {
    case .green: return .green
    case .turquoise: return UIColor(red: 0.25, green: 0.88, blue: 0.82, alpha: 1.00)
    }
  }
  
}

public class TrafficLight {
  public enum State {
    case stop
    case proceed
    case caution
  }
  
  private var options = [ObjectIdentifier: Any]()
  
  public subscript<T: TrafficLightOption>(option type: T.Type) -> T.Value {
    get {
      options[ObjectIdentifier(type)] as? T.Value ?? type.defaultValue
    }
    
    set {
      options[ObjectIdentifier(type)] = newValue
    }
  }
  
  public private(set) var state: State = .stop {
    didSet {
      onStateChanged?(state)
    }
  }
  
  public var onStateChanged: ((State) -> Void)?
  
  public var stopDuration = 4.0
  public var proceedDuration = 6.0
  public var cautionDuration = 1.5
  
  private var timer: Timer?
  
  private func turnState(_ state: State) {
    switch state {
    case .proceed:
      timer = Timer.scheduledTimer(withTimeInterval: proceedDuration, repeats: false) { _ in
        self.turnState(.caution)
      }
    case .caution:
      timer = Timer.scheduledTimer(withTimeInterval: cautionDuration, repeats: false) { _ in
        self.turnState(.stop)
      }
    case .stop:
      timer = Timer.scheduledTimer(withTimeInterval: stopDuration, repeats: false) { _ in
        self.turnState(.proceed)
      }
    }
    self.state = state
  }
  
  public func start() {
    guard timer == nil else {
      return
    }
    
    turnState(.stop)
  }
  
  public func stop() {
    timer?.invalidate()
    timer = nil
  }
}

public class ViewController: UIViewController {
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    let light = TrafficLight()
    light.preferredGreenLightColor = .turquoise
    light.onStateChanged = { [weak self] state in
      guard let self = self else {
        return
      }
      let color: UIColor
      switch state {
      case .proceed: color = light.preferredGreenLightColor.color
      case .caution: color = .yellow
      case .stop: color = .red
      }
      UIView.animate(withDuration: 0.3) {
        self.view.backgroundColor = color
      }
      
    }
    
    light.start()
  }
}


PlaygroundPage.current.liveView = ViewController()


