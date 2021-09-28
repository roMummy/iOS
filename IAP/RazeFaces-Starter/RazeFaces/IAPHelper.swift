/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject {
    private let productIdentifiers: Set<ProductIdentifier>

    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        // 从本地取出已经购买的商品
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }

    // 跟踪已购买商品
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    // iap 请求
    private var productsRequest: SKProductsRequest?
    // 请求回调
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
}

// MARK: - StoreKit API

extension IAPHelper {
    /// 请求所有商品
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler

        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    /// 购买商品
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    /// 是否是已购买产品
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }

    /// 是否允许支付
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    /// 恢复购买
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    /// 响应请求回调
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        DispatchQueue.main.async {
            self.productsRequestCompletionHandler?(true, products)
            self.clearRequestAndHandler()
        }
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }

    /// 请求错误
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.productsRequestCompletionHandler?(false, nil)
            self.clearRequestAndHandler()
        }
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    /// 观察支付对象变化
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased: // 购买完成
                complete(transaction: transaction)
                break
            case .failed: // 购买失败
                fail(transaction: transaction)
                break
            case .restored: // 恢复购买
                restore(transaction: transaction)
                break
            case .purchasing: // 购买中
                break
            case .deferred: // 延期
                break
            }
        }
    }

    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else {
            return
        }
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let error = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           error.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    /// 保存到本地 发送通知
    private func deliverPurchaseNotificationFor(identifier: ProductIdentifier?) {
        guard let identifier = identifier else {
            return
        }

        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.setValue(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
}
