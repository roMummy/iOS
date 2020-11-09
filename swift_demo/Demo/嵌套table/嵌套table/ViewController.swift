//
//  ViewController.swift
//  嵌套table
//
//  Created by ZQ on 2020/10/28.
//  Copyright © 2020 grdoc. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

  lazy var oneTable: OneTableView = {
    let table = OneTableView(frame: CGRect(x: 0, y: 0, width: 418, height: 500))
    return table
  }()
  
  lazy var tableView: UITableView = {
    let table = UITableView.init(frame: CGRect.zero, style: .plain)
    
    table.delegate = self
    table.dataSource = self
    table.isScrollEnabled = false
    
    table.register(OneCell.self, forCellReuseIdentifier: "cell")
    
    return table
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(oneTable)
    oneTable.setupView(table: tableView)
//    self.view.addSubview(tableView)
//    tableView.tableHeaderView = oneTable;
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    oneTable.snp.makeConstraints { (make) in
      make.edges.equalTo(self.view)
    }
  }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    return 20
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      return cell
    }
    
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.backgroundColor = .purple
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 500
    }
    return 50
  }
  
  
}

