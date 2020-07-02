//
//  MedicineListBaseViewController.swift
//  Demo
//
//  Created by ZQ on 2020/5/22.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit

class MedicineListBaseViewController: UIViewController {
  
  lazy var searchBar: UISearchBar = {
    let bar = UISearchBar(frame: CGRect.zero)
    bar.delegate = self
    return bar
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "畅销药品清单"
    setupUI()
  }
  
  func setupUI() {
    view.addSubview(searchBar)
    
    searchBar.snp.makeConstraints { (make) in
      make.top.equalTo(88)
      make.left.right.equalTo(view)
      make.height.equalTo(50)
    }
  }
  
}

extension MedicineListBaseViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    
  }
  
  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    return true
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
  }
  
}
