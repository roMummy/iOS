import UIKit

// source: https://www.jianshu.com/p/a4a2a523d215


var str = "Hello, playground"


public struct HashTable<Key: Hashable, Value> {
  // 键值对
  private typealias Element = (key: Key, value: Value)
  private typealias Bucket = [Element]
  // 主要存储空间
  private var buckets: [Bucket]
  
  public private(set) var count = 0
  public var isEmpty: Bool {return count == 0}
  
  // 最大容纳数
  public init(capacity: Int) {
    assert(capacity > 0)
    buckets = Array<Bucket>(repeatElement([], count: capacity))
  }
  
}
extension HashTable {
  private func index(forKey key: Key) -> Int {
    return abs(key.hashValue) % buckets.count
  }
  
  public subscript(key: Key) -> Value? {
    get {
      return value(forKey: key)
    }
    
    set {
      if let value = newValue {
        updateValue(value, forKey: key)
      } else {
        removeValue(forKey: key)
      }
    }
  }
  
  public func value(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    for element in buckets[index] {
      if element.key == key {
        return element.value
      }
    }
    return nil
  }
  
  public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        let oldValue = element.value
        buckets[index][i].value = value
        return oldValue
      }
    }
    buckets[index].append((key: key, value: value))
    count += 1
    return nil
  }
  
  public mutating func removeValue(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        buckets[index].remove(at: i)
        count -= 1
        return element.value
      }
    }
    return nil
  }
}


//var hashTable = HashTable<String, String>(capacity: 5)
//
//hashTable["1"] = "1++"
//hashTable["1"] = "1--"
////hashTable["1"] = nil
//print(hashTable["1"])
//print(hashTable.count)
//
//
//let maxTime = 60
//var frequency = 0
//
//func update(time: Int) -> Int {
//
//  print("-----\(time)")
//  if time > maxTime {
//    return -1
//  } else {
//    frequency += 5
//    let result = update(time: time + frequency)
//    return result
//  }
//}
//
//update(time: 0)

enum RepeatBehavior {
  case immediate (maxCount: UInt)
  case delayed (maxCount: UInt, time: Double)
  case customTimerDelayed (maxCount: UInt, delayCalculator: (UInt) -> DispatchTimeInterval)
}
extension RepeatBehavior {
  func calculateConditions(_ currentRepetition: UInt) -> (maxCount: UInt, delay: DispatchTimeInterval) {
    switch self {
    case .immediate(let max):
      return (maxCount: max, delay: .never)
    case .delayed(let max, let time):
      return (maxCount: max, delay: .milliseconds(Int(time * 1000)))
    case .customTimerDelayed(let max, let delayCalculator):
      return (maxCount: max, delay: delayCalculator(currentRepetition))
    }
  }
}


private let customCalculator: (UInt) -> DispatchTimeInterval = { attempt in
  switch attempt {
  case 1: return .seconds(5)
  case 2: return .seconds(10)
  default: return .seconds(20)
  }
}

private func retry<T>(_ currentAttempt: UInt, behavior: RepeatBehavior, task: @escaping (_ completion:@escaping (Result<T, Error>) -> Void) -> Void,  completion:@escaping (Result<T, Error>) -> Void) {
  guard currentAttempt > 0 else {
    return
  }
  
  let conditions = behavior.calculateConditions(currentAttempt)
  
  task({ result in
    switch result {
    case .success(_):
      completion(result)
    case .failure(let error):
      
      print("retries left \(currentAttempt) and error = \(error.localizedDescription)")
      
      guard conditions.maxCount > currentAttempt else {
        // 结束
        completion(result)
        return
      }
      
      if conditions.delay == .never {
        retry(currentAttempt + 1, behavior: behavior, task: task, completion: completion)
        return
      }
      
      DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + conditions.delay) {
        retry(currentAttempt + 1, behavior: behavior, task: task, completion: completion)
      }
    }
  })
}

struct TError: Error {
  
}

private func p_loginMX(completion: @escaping (Result<String, Error>) -> Void) {
  completion(.failure(TError()))
}

retry(1, behavior: RepeatBehavior.delayed(maxCount: 3, time: 5), task: { (result) in
  p_loginMX(completion: result)
}) { (newResult) in
  switch newResult {
  case .success(let mxId):
    print("success--\(mxId)")
  case .failure(let error):
    print("fail-----")
  }
}

