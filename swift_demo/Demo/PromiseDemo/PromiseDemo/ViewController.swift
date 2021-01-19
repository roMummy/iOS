//
//  ViewController.swift
//  PromiseDemo
//
//  Created by ZQ on 2021/1/18.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  
  }
  
  func fetch() -> Promise<String> {
    return Promise.init { (seal) in
      
    }
  }

}

