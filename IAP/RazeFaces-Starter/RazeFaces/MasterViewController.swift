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

import UIKit
import StoreKit

class MasterViewController: UITableViewController {
  
  let showDetailSegueIdentifier = "showDetail"
  
  var products: [SKProduct] = []
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == showDetailSegueIdentifier {
      guard let indexPath = tableView.indexPathForSelectedRow else {
        return false
      }
      
      let product = products[indexPath.row]
      
      return RazeFaceProducts.store.isProductPurchased(product.productIdentifier)
    }
    
    return true
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showDetailSegueIdentifier {
      guard let indexPath = tableView.indexPathForSelectedRow else { return }
      
      let product = products[indexPath.row]
      
      if let name = resourceNameForProductIdentifier(product.productIdentifier),
             let detailViewController = segue.destination as? DetailViewController {
        let image = UIImage(named: name)
        detailViewController.image = image
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "RazeFaces"
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(MasterViewController.reload), for: .valueChanged)
    
    let restoreButton = UIBarButtonItem(title: "Restore",
                                        style: .plain,
                                        target: self,
                                        action: #selector(MasterViewController.restoreTapped(_:)))
    navigationItem.rightBarButtonItem = restoreButton
    
    NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.handlePurchaseNotification(_:)),
                                           name: .IAPHelperPurchaseNotification,
                                           object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    reload()
  }
  
  @objc func reload() {
    products = []
    
    tableView.reloadData()
    
    RazeFaceProducts.store.requestProducts{ [weak self] success, products in
      guard let self = self else { return }
      if success {
        self.products = products!
        
        self.tableView.reloadData()
      }
      self.refreshControl?.endRefreshing()
    }
  }
  
  @objc func restoreTapped(_ sender: AnyObject) {
    RazeFaceProducts.store.restorePurchases()
  }

  @objc func handlePurchaseNotification(_ notification: Notification) {
    guard
      let productID = notification.object as? String,
      let index = products.index(where: { product -> Bool in
        product.productIdentifier == productID
      })
    else { return }
    
    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
  }
}

// MARK: - UITableViewDataSource

extension MasterViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductCell
    
    let product = products[indexPath.row]
    
    cell.product = product
    cell.buyButtonHandler = { product in
      RazeFaceProducts.store.buyProduct(product)
    }
    
    return cell
  }
}
