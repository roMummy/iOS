import UIKit

var str = "Hello, playground"


/// 机构型

// 将对象组合成树形结构以表示‘部分-整体’的层次结构。组合模式使得用户对单个对象和组合对象的使用具有一致性。

// 组件
protocol Shape {
  func draw(fillColor: String)
}

// 叶子节点
final class Square: Shape {
  func draw(fillColor: String) {
    print("square: \(fillColor)")
  }
}

final class Circle: Shape {
  func draw(fillColor: String) {
    print("circle: \(fillColor)")
  }
}

// 组合
class Whiteboard: Shape {
  private lazy var shapes: [Shape] = []
  
  init(_ shapes: Shape...) {
    self.shapes = shapes
  }
  
  func draw(fillColor: String) {
    for shape in shapes {
      shape.draw(fillColor: fillColor)
    }
  }
}

var wb = Whiteboard(Circle(), Square())
wb.draw(fillColor: "red")


// **** 安全模式 ****
// https://juejin.im/post/5aa0958f518825555e5d645c#heading-6

//// 抽象构件
//protocol Component {
//  func operation()
//}
//
//// 树枝构件
//class Composite: Component {
//
//  func operation() {
//  }
//  // 构件容器
//  var components: [Component] = []
//
//  // 增加一个叶子构件或树枝构件
//  func add(component: Component) {
//    components.append(component)
//  }
//  // 删除
//  func remove(component: Component) {
//    // TODO: 缺少标识
//    components.removeAll()
//  }
//  // 获取所有z叶子构件
//  func getChildren() -> [Component] {
//    return self.components
//  }
//}
//
//// s叶子构件
//final class Leaf: Component {
//  func operation() {
//
//  }
//}
//// client
//class Client {
//  func main() {
//    let root = Composite()
//    root.operation()
//    let branch = Composite()
//    let leaf = Leaf()
//    root.add(component: branch)
//    branch.add(component: leaf)
//  }
//
//  static func showTree(root: Composite) {
//    for c in root.getChildren() {
//      if c is Leaf { // 如果是叶子节点
//        c.operation()
//      }else {
//        showTree(root: c as! Composite)
//      }
//    }
//  }
//}


// *** 透明模式 ***

// 抽象构件
protocol Component {
  // 个体和整体都具有
  func operation()
  
  // 增加叶子
  func add(component: Component)
  
  // 移除叶子
  func remove(component: Component)
  
  // 获取所有子节点
  func getChildren() -> [Component]
}
extension Component {
  func operation() {
    // 业务逻辑 ....
  }
}

// 树枝构件
class Composite: Component {
  
  // 构件容器
  var components: [Component] = []

  // 增加一个叶子构件或树枝构件
  func add(component: Component) {
    components.append(component)
  }
  // 删除
  func remove(component: Component) {
    // TODO: 缺少标识
    components.removeAll()
  }
  // 获取所有z叶子构件
  func getChildren() -> [Component] {
    return self.components
  }
}

// 叶子
final class Leaf: Component {
  func add(component: Component) {
    
  }
  
  func remove(component: Component) {
      
  }
  
  func getChildren() -> [Component] {
    return []
  }

}

//// client
//class Client {
//  func main() {
//    let root = Composite()
//    root.operation()
//    let branch = Composite()
//    let leaf = Leaf()
//    root.add(component: branch)
//    branch.add(component: leaf)
//  }
//
//  static func showTree(root: Component) {
//    for c in root.getChildren() {
//      if c is Leaf { // 如果是叶子节点
//        c.operation()
//      }else {
//        showTree(root: c)
//      }
//    }
//  }
//}


// 抽象构件 族员类
class PersonMode {
  var name: String
  var sex: String
  var age: Int
  
  init(name: String, sex: String, age: Int) {
    self.name = name
    self.sex = sex
    self.age = age
  }
  
  func getPersonInfo() -> String {
    let info = "姓名：" + name + "\t 性别：" + sex + "\t 年龄：" + "\(age)"
    return info
  }
}

// 树叶
class PersonLeaf: PersonMode {
  override init(name: String, sex: String, age: Int) {
    super.init(name: name, sex: sex, age: age)
  }
}

// 树枝构件
class PersonBranch: PersonMode {
  private var persons: [PersonMode] = []
  
  override init(name: String, sex: String, age: Int) {
    super.init(name: name, sex: sex, age: age)
  }
  
  func add(person: PersonMode) {
    self.persons.append(person)
  }
  
  func getPersonModelList() -> [PersonMode] {
    return persons
  }
}

class Client {
  static func main() {
    let persionBranch = getPersonInfo()
    print("main run")
    showTree(root: persionBranch)
  }
  
  private static func getPersonInfo() -> PersonBranch {
    let oneJ = PersonBranch(name: "1", sex: "男", age: 100)
    let ja = PersonBranch(name: "ja", sex: "男", age: 89)
    let jb = PersonBranch(name: "jb", sex: "男", age: 70)
    
    oneJ.add(person: ja)
    oneJ.add(person: jb)
    return oneJ
  }
  
  private static func showTree(root: PersonBranch) {
    for c in root.getPersonModelList() {
      if c is PersonLeaf {
        print(c.getPersonInfo())
      }else {
        showTree(root: c as! PersonBranch)
      }
    }
  }
}

Client.main()



