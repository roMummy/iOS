//
//  MedicineSearchResultViewController.swift
//  Demo
//
//  Created by ZQ on 2020/5/22.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit

class MedicineSearchResultViewController: MedicineListBaseViewController {
  
  lazy var tableView: UITableView = {
    let table = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    table.dataSource = self
    table.rowHeight = 45
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func setupUI() {
    super.setupUI()
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(searchBar.snp.bottom).offset(0)
      make.left.right.bottom.equalTo(view)
    }
    
  }
}
extension MedicineSearchResultViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    return cell
  }
  
  
}
