//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      析构 析构器只适用于类类型，当一个类的实例被释放之前，析构器会被立即调用 deinit
 */

///析构过程原理 每个类最多只能有一个析构器，而且析构器不带任何参数；析构器是在实例释放发生之前被自动调用

class Bank {
    static var coinslnBank = 10_000
    static func distribute(coins numberOfCoinsRequested:Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinslnBank)
        coinslnBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins:Int) {
        coinslnBank += coins
    }
}

class Player {
    var coinsInPurse: Int
    init(coins:Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins:Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}
var playerOne:Player? = Player(coins:100)
print(playerOne!.coinsInPurse)
playerOne!.win(coins: 2_000)
print(playerOne!.coinsInPurse)
print(Bank.coinslnBank)
//销毁玩家
playerOne = nil
print(Bank.coinslnBank)

