import UIKit

var str = "Hello, playground"

// 外观模式为子系统中的一组接口提供一个统一的高层接口，使得子系统更容易使用。

final class Defaults {
  private let defaults: UserDefaults
  
  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }
  
  subscript(key: String) -> String? {
    get {
      return defaults.string(forKey: key)
    }
    
    set {
      defaults.set(newValue, forKey: key)
    }
  }
}

let storage = Defaults()

storage["one"] = "hhhh"

storage["one"]

