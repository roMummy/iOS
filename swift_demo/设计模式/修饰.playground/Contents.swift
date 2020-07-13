import UIKit

var str = "Hello, playground"

// 修饰模式，是面向对象编程领域中，一种动态地往一个类中添加新的行为的设计模式。 就功能而言，修饰模式相比生成子类更为灵活，这样可以给某个对象而不是整个类添加一些功能。

protocol CostHaving {
  var cost: Double {get}
}

protocol IngredientsHaving {
  var ingredients: [String] {get}
}

typealias BeverageDataHaving = CostHaving & IngredientsHaving

struct SimpleCoffee: BeverageDataHaving {
  var cost: Double = 1.0
  var ingredients: [String] = ["water", "coffee"]
}

protocol BeverageHaving: BeverageDataHaving {
  var beverage: BeverageDataHaving {get}
}

struct Milk: BeverageHaving {
  var beverage: BeverageDataHaving
  
  var cost: Double {
    return beverage.cost + 0.5
  }
  
  var ingredients: [String] {
    return beverage.ingredients + ["milk"]
  }
}

struct WhipCoffee: BeverageHaving {
  var beverage: BeverageDataHaving
  
  var cost: Double {
    return beverage.cost + 0.5
  }
  
  var ingredients: [String] {
    return beverage.ingredients + ["whip"]
  }
}

var someCoffee: BeverageDataHaving = SimpleCoffee()
print("cost: \(someCoffee.cost) ingredients: \(someCoffee.ingredients)")

someCoffee = Milk(beverage: someCoffee)
print("cost: \(someCoffee.cost) ingredients: \(someCoffee.ingredients)")

someCoffee = WhipCoffee(beverage: someCoffee)
print("cost: \(someCoffee.cost) ingredients: \(someCoffee.ingredients)")

