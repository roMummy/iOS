//: Playground - noun: a place where people can play

import UIKit
import MapKit


var str = "Hello, playground"
enum a: Int {
    case b
    func test() -> String {
        return String(self.rawValue)
    }
}

extension String {
    var phoneRegularExpression: String { return "^0[0-9]{2,3}-[0-9]{7,8}$" }
    
    func detection(with regularRule: String) -> Bool {
        let predicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regularRule)
        return predicate.evaluate(with: self)
    }
    func phoneRegularDetection() -> Bool {
        return detection(with: phoneRegularExpression)
    }
}

let ss = "4005$请联系客服进行提单，13132303039服务电话：028-6817926842"

func hahah(_ t: String) -> String{
    guard !t.isEmpty else {return ""}
    
    let phones = t
        .split(maxSplits: 12, omittingEmptySubsequences: true){ !"0123456789-".contains(String($0))}
        .filter {$0 != ""}
        .sorted {$0 < $1}
        .filter {String($0).phoneRegularDetection()}
    print(phones)
    return String(phones.first ?? "")
}

hahah(ss)
print("111")

ss.replacingOccurrences(of: "4005$", with: "")


