import UIKit

var str = "Hello, "

/*:

 * asfsdf
 * asdf
 ###### asdf
 
 # 111111
 
*/


/// 策略模式：在类中封装算法，使它们在运行时可重用和可互换。
/// 用法：1.做同样的不同方法
///      2.扩建新的方法
///      3.替代if/else

// 做什么
protocol LoggerStrategy {
    func log(_ message: String)
}

// 谁来做
struct Logger {
    let strategy: LoggerStrategy
    func log(_ message: String) {
        strategy.log(message)
    }
}

// 怎么做
struct LowercaceStrategy: LoggerStrategy {
    func log(_ message: String) {
        print(message.lowercased())
    }
}

struct UppercaceStrategy: LoggerStrategy {
    func log(_ message: String) {
        print(message.uppercased())
    }
}

struct CapitalizedStrategy: LoggerStrategy {
    func log(_ message: String) {
        print(message.capitalized)
    }
}

// test
var logger = Logger(strategy: CapitalizedStrategy())
logger.log("heLlo")

logger = Logger(strategy: UppercaceStrategy())
logger.log("hello")

logger = Logger(strategy: LowercaceStrategy())
logger.log("hello")


protocol ValidateStrategy {
    func validate(_ message: String) -> Bool
}

struct Validater {
    let strategy: ValidateStrategy
    func validate(_ message: String) -> Bool {
        return strategy.validate(message)
    }
}

struct PasswdValidate: ValidateStrategy {
    func validate(_ message: String) -> Bool {
        if message.count < 4 {
            return false
        }
        if message.count > 8 {
            return false
        }
        return true
    }
}

struct NameValidate: ValidateStrategy {
    func validate(_ message: String) -> Bool {
        // 正则
        if message.count < 11 {
            return false
        }
        return true
    }
}

var validater = Validater(strategy: PasswdValidate())
validater.validate("123")

validater = Validater(strategy: NameValidate())
validater.validate("哈哈哈")

