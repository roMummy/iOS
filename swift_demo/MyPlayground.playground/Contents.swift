//: Playground - noun: a place where people can play

import UIKit
import MapKit


var str = "Hello, playground"

//enum a: Int {
//    case b
//    func test() -> String {
//        return String(self.rawValue)
//    }
//}
//
//extension String {
//    var phoneRegularExpression: String { return "^0[0-9]{2,3}-[0-9]{7,8}$" }
//
//    func detection(with regularRule: String) -> Bool {
//        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regularRule)
//        return predicate.evaluate(with: self)
//    }
//    func phoneRegularDetection() -> Bool {
//        return detection(with: phoneRegularExpression)
//    }
//}
//
//let ss = "4005$请联系客服进行提单，13132303039服务电话：028-6817926842"
//
//func hahah(_ t: String) -> String{
//    guard !t.isEmpty else {return ""}
//
//    let phones = t
//        .split(maxSplits: 12, omittingEmptySubsequences: true){ !"0123456789-".contains(String($0))}
//        .filter {$0 != ""}
//        .sorted {$0 < $1}
//        .filter {String($0).phoneRegularDetection()}
//    print(phones)
//    return String(phones.first ?? "")
//}
//
//hahah(ss)
//print("111")
//
//ss.replacingOccurrences(of: "4005$", with: "")
//
//
//
//func test() {
//
//  for ball in 0...10 {
//    let racket = ball + 100
//    if ball + racket == 110 {
//      print(ball)
//      continue
//    }
//  }
//}
//
//test()



extension Int {
  func asDate() -> Date {
    let timeInterval = TimeInterval(self)
    return Date(timeIntervalSince1970: timeInterval)
  }
  
  func reMill() -> Int {
    return self / 1000
  }
  
  func toMill() -> Int {
    return self * 1000
  }
}

extension Date {
  func intervalYear(to date: Date) -> Int {
    let calendar = Calendar.current.dateComponents([.year], from: self, to: date)
    return abs(calendar.year ?? 0)
  }
 
  func addYear(by year: Int) -> Self? {
    return Calendar.current.date(byAdding: .year, value: year, to: self)
  }
  
  func asInt() -> Int {
    return Int(self.timeIntervalSince1970)
  }
  
}


struct ContractTool {
  
  static func getCurrentStartTime(by st: Int?) -> Int? {
    guard let startTime = st?.reMill().asDate() else {
      return nil
    }
    let year = startTime.intervalYear(to: Date())
    let time = startTime.addYear(by: year)?.asInt().toMill()
    return time
  }
  /// 通过开始时间计算结束时间
  static func getCurrentEndTime(by st: Int?) -> Int? {
    
    guard let startTime = getCurrentStartTime(by: st) else {
      return nil
    }
    
    let time = startTime.reMill().asDate().addYear(by: 1)?.asInt().toMill()
    return time
  }
}

ContractTool.getCurrentStartTime(by: 1519802417000)
ContractTool.getCurrentEndTime(by: 1519802417000)


