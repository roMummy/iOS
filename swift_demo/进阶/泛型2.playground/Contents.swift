import UIKit

// from: https://xiaozhuanlan.com/topic/7651204893

var greeting = "Hello, playground"

protocol Food {}
/// 动物
protocol Animal {
    associatedtype Feed: AnimalFeed
    /// 吃
    func eat(_ food: Feed)
}

/// 食物
protocol AnimalFeed {
    associatedtype CropType: Crop where CropType.FeedType == Self
    /// 生长
    static func grow() -> CropType
}
/// 植物
protocol Crop {
    associatedtype FeedType: AnimalFeed where FeedType.CropType == Self
    /// 收获
    func harvest() -> FeedType
}

struct Farm {
    
    // 泛型写法
    func feed<A: Animal>(_ animal: A) {
        let crop = type(of: animal).Feed.grow()
        let feed = crop.harvest()
        animal.eat(feed)
    }
//    func feed<A>(_ animal: A) where A: Animal {}
    // 简化写法 16新特性
//    func feed(_ animal: some Animal) {}
    /// 投喂所有食物
    func feedAll<A: Animal>(_ animals: [A]) {
        animals.forEach(feed)
    }
}

//protocol Animal {
//  var isHungry: Bool { get }
//  associatedtype Feed: AnimalFeed
//  associatedtype CommodityType: Food
//  func eat(_ food: Feed)
//  func produce() -> CommodityType
//}
//
//struct Cow: Animal {
//  func eat(_ food: Hay) {}
//  func produce() -> Milk {
//    Milk()
//  }
//}
//
//struct Chicken: Animal {
//  func eat(_ food: Grain) {}
//  func produce() -> Egg {
//    Egg()
//  }
//}
//
//struct Horse: Animal {
//  func eat(_ food: Carrot) {}
//}
//
//protocol AnimalFeed {
//  associatedtype CropType: Crop where CropType.Feed == Self
//  static func grow() -> CropType
//}
//
//struct Hay: AnimalFeed {
//  static func grow() -> Alfalfa {
//    Alfalfa()
//  }
//}
//
//struct Carrot: AnimalFeed {
//  static func grow() -> Root {
//    Root()
//  }
//}
//
//struct Grain: AnimalFeed {
//  static func grow() -> Wheat {
//    Wheat()
//  }
//}
//
//protocol Crop {
//  associatedtype Feed: AnimalFeed where Feed.CropType == Self
//  func harvest() -> Feed
//}
//
//struct Alfalfa: Crop {
//  func harvest() -> Hay {
//    Hay()
//  }
//}
//
//struct Wheat: Crop {
//  func harvest() -> Grain {
//    Grain()
//  }
//}
//
//struct Root: Crop {
//  func harvest() -> Carrot {
//    Carrot()
//  }
//}
//
//protocol Food {}
//
//struct Milk: Food {}
//
//struct Egg: Food {}
//
//struct Farm {
//  var animals: [any Animal]
//  var hungryAnimals: some Collection <any Animal> {
//    animals.filter(\.isHungry)
//  }
//
//  func feed(_ animal: some Animal) {
//    let crop = type(of: animal).Feed.grow()
//    let produce = crop.harvest()
//    animal.eat(produce)
//  }
//
//  func feedAll(_ animals: [any Animal]) {
//    for animal in animals {
//      feed(animal)
//    }
//  }
//
//  func feedAnimals() {
//    for animal in hungryAnimals {
//      feed(animal)
//    }
//  }
//
//  func produceCommodities() -> [any Food] {
//    return animals.map { animal in
//      animal.produce()
//    }
//  }
//}
