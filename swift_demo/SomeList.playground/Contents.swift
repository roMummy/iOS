import UIKit
import Foundation

var str = "Hello, playground"

public protocol SomeList: class {
  associatedtype Cell = SomeCell
  func set(ids: [String])
  func getIds() -> [String]
  func getSomeCell(position: Int) -> Cell
}

public protocol SomeView: UIView {

  func set(id: String)
  func getId() -> String
  func addedToView(view: UIView)
}

public protocol SomeCell {
  func getView<T: SomeView>(_ clazz: T.Type) -> T
  func getId() -> String
  func set(id: String)
}

final class SomeViewPoolManager {
  private var lock: NSRecursiveLock = NSRecursiveLock()
  private var allPool_: [String: Any] = [:]
  private static let shared_ = SomeViewPoolManager()
  
  static func shared() -> SomeViewPoolManager {
    return shared_
  }
  
  func getViewPool<T: SomeView>(_ clazz: T.Type) -> SomeViewPoolHelper<T> {
    let clazzName = NSStringFromClass(clazz)
    var pool: SomeViewPoolHelper<T>
    // 锁
    lock.lock()
    if allPool_.contains(where: {$0.key == clazzName}) {
      pool = allPool_[clazzName] as! SomeViewPoolHelper<T>
    } else {
      pool = SomeViewPoolHelper<T>()
      allPool_[clazzName] = pool
    }
    lock.unlock()
    return pool
  }
}

protocol SomeViewPool {
  associatedtype T: SomeView
  associatedtype GC
  
  var maxCount: Int? {get set}
  var minCount: Int? {get set}
  
  var idleTime: TimeInterval? {get set}
  
  func getView() -> T
  func putView(view: T)
  
  func installGC(gc: GC)
}

final class SomeViewPoolHelper<T: SomeView>: SomeViewPool {
  typealias GC = GCManager
  
  private var views_ = [T]()
  
  var maxCount: Int?
  var minCount: Int?
  
  var idleTime: TimeInterval?
  
  func getView() -> T {
    // TODO:
    if views_.isEmpty {
      putView(view: T())
    }
    print("数量: \(views_.count)")
    return views_.removeLast()
  }
  
  func putView(view: T) {
    // TODO:
    views_.append(view)
  }
  
  func installGC(gc: GC) {
    // TODO:
  }
    
}

class GCManager {}

class SomeViewTest: UIView, SomeView {
  private var id_: String = ""
  func set(id: String) {
    id_ = id
  }
  
  func getId() -> String {
    return id_
  }
  
  func addedToView(view: UIView) {
    
  }
  
  
}
class SomeViewTest1: UIView, SomeView {
  private var id_: String = ""
  func set(id: String) {
    id_ = id
  }
  
  func getId() -> String {
    return id_
  }
  
  func addedToView(view: UIView) {
    
  }
}

class SomeCellTest: SomeCell {
  private var id_ = ""
  func getView<T>(_ clazz: T.Type) -> T where T : SomeView {
    let pool = SomeViewPoolManager.shared().getViewPool(clazz)
    let view = pool.getView()
    view.set(id: id_)
    return view
  }
  
  func getId() -> String {
    return id_
  }
  
  func set(id: String) {
    id_ = id
  }
}

class SomeListTest: SomeList {
  func getSomeCell(position: Int) -> SomeCell {
    let cell = SomeCellTest()
    cell.set(id: ids_[position])
    return cell
  }
  
  private var ids_: [String] = []
  func set(ids: [String]) {
    ids_ = ids
  }
  
  func getIds() -> [String] {
    return ids_
  }
  
//  func getSomeCell<T>(position: Int) -> T where T : SomeCell {
//    let cell = SomeCellTest()
//    cell.set(id: ids_[position])
//    return cell as! T
//  }
}

let list = SomeListTest()
list.set(ids: ["1", "2"])
let cell = list.getSomeCell(position: 0)
let view = cell.getView(SomeViewTest.self)
let view1 = cell.getView(SomeViewTest1.self)
let view2 = cell.getView(SomeViewTest1.self)

print(cell.getId())
print(view.getId())
print(view)
print(view1.getId())
print(view1)
print(view2.getId())
print(view2)



