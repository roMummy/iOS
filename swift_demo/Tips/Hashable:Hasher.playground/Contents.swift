import UIKit

var str = "Hello, playground"
/// https://nshipster.cn/hashable/  
// Hashable 4.1以前
// 存储到Set中需要遵循Equatable和Hashable协议
struct Color {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
}

extension Color: Equatable {
    static func ==(lhs: Color, rhs: Color) -> Bool {
        return lhs.red == rhs.red &&
               lhs.green == rhs.green &&
               lhs.blue == rhs.blue
    }
}
extension Color: Hashable {
    var hashValue: Int {
        return  self.red.hashValue ^
                self.green.hashValue ^
                self.blue.hashValue
    }
}
let cyan = Color(red: 0x00, green: 0xff, blue: 0xff)
let yellow = Color(red: 0xff, green: 0xff, blue: 0x00)
cyan.hashValue == yellow.hashValue

// 4.2 引入Hasher 在上层完成比较
struct Colors: Hashable {
    let red: UInt8
    let green: UInt8
    let blue: UInt8
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.red)
        hasher.combine(self.green)
        hasher.combine(self.blue)
    }
    
    var hashValue: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
}

let cyans = Colors(red: 0x00, green: 0xff, blue: 0xff)
let yellows = Colors(red: 0xff, green: 0xff, blue: 0x00)
cyans.hashValue == yellows.hashValue


