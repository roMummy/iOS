//
//  BestMedicineListViewController.swift
//  Demo
//
//  Created by ZQ on 2020/5/22.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit
import SnapKit

class BestMedicineListViewController: MedicineListBaseViewController {
  
  lazy var tableView: UITableView = {
    let table = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    table.dataSource = self
    table.rowHeight = 45
    return table
  }()
  
  lazy var searchView: SearchView = {
    let view = SearchView(frame: CGRect.zero)
    view.delegate = self
    view.isHidden = true
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()    
  }
  
  override func setupUI() {
    super.setupUI()
    view.addSubview(tableView)
    view.addSubview(searchView)
    
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(searchBar.snp.bottom).offset(0)
      make.left.right.bottom.equalTo(view)
    }
    
    searchView.snp.makeConstraints { (make) in
      make.top.equalTo(searchBar.snp.bottom)
      make.left.right.bottom.equalTo(view)
    }
  }
  
  
//  override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//    searchView.isHidden = false
//    searchView.count = 0
//    return true
//  }
  
  override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count == 0 {
      searchView.count = 0
      searchView.isHidden = true
    }else {
      searchView.count = 5
      searchView.isHidden = false
    }
  }
}
extension BestMedicineListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = "\(indexPath.row)"
    return cell
  }
  
}

extension BestMedicineListViewController: SearchViewDelegate {
  func didSelectRowAt(id: String) {
    let vc = MedicineSearchResultViewController()
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
