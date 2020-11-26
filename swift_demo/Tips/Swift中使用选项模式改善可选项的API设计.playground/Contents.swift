import UIKit

var str = "Hello, playground"

// soucre: https://onevcat.com/2020/10/use-options-pattern/

/// 交通灯
/// 不易扩展
public class TrafficLight {
  public enum State {
    case stop
    case proceed
    case caution
        
  }
  // 带有私有方法的公有属性
  public private(set) var state: State = .stop {
    didSet {onStateChanged?(state)}
  }
  
  public var onStateChanged:((State) -> Void)?
   
  
  private var options = [ObjectIdentifier: Any]()
  
  public subscript<T: TrafficLightOption>(option type: T.Type) -> T.Value {
    get {
      options[ObjectIdentifier(type)] as? T.Value ?? type.defaultValue
    }
    set {
      options[ObjectIdentifier(type)] = newValue
    }
  }
}

/// 期权模式
/// 不添加存储属性的情况下扩展

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
  
  public var preferredGreenLightColor: TrafficLight.GreenLightColor {
    get {self[option: GreenLightColor.self]}
    set {self[option: GreenLightColor.self] = newValue}
  }
}

let light = TrafficLight()
light.preferredGreenLightColor = .turquoise


