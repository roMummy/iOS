//
//  StoreHelper.swift
//  RazeFaces
//
//  Created by FSKJ on 2021/8/24.
//  Copyright © 2021 Razeware LLC. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyStoreKit

class STError: Error {
    let localizedDescription: String
    init(_ localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }
}

open class StoreHelper: NSObject {
    static let shared = StoreHelper()
    override private init() {
        super.init()
    }

    func completeTransactions() -> Promise<Void> {
        return Promise<Void>.init { seal in
            SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                for purchase in purchases {
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                          seal.fulfill(())
                        }
                    case .failed, .purchasing, .deferred:
                        seal.reject(STError("failed"))
                        break
                    }
                }
            }
        }
    }

    func buy(productId: String) -> Promise<Void> {
      return Promise { seal in
        SwiftyStoreKit.purchaseProduct(productId, atomically: false) { result in
            switch result {
            case let .success(product):
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                seal.fulfill(())
                break
            case let .error(error):
                seal.reject(error)
            }
        }
      }
    }
    
    
}
