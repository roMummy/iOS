//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      嵌套类型
 */

struct BlackjackCard {
    //嵌套枚举
    enum Suit: Character {
        case Spades = "1",Hearts = "2"
    }
    enum Rank: Int {
        case Two = 2,Three,Four
        case Jack
        struct Values {
            let first:Int, second:Int?
        }
        var values:Values {
            switch self {
            case .Jack:
                return Values(first:1, second:11)
            default:
                return Values(first:self.rawValue,second:nil)
            }
        }
        
    }
}