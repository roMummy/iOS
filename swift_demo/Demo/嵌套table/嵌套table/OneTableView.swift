//
//  OneTableView.swift
//  嵌套table
//
//  Created by ZQ on 2020/10/28.
//  Copyright © 2020 grdoc. All rights reserved.
//

import UIKit
import SnapKit

class OneTableView: UIView {
  
  var footer: UITableView?

  lazy var tableView: UITableView = {
    let table = UITableView(frame: CGRect.zero, style: .plain)
    
    table.delegate = self
    table.dataSource = self
    
    return table
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setupUI() {
    self.addSubview(tableView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.snp.makeConstraints { (make) in
      make.edges.equalTo(self)
    }
  }
  
  func setupView(table: UITableView) {
    self.footer = table
    self.tableView.reloadData()
  }
}

extension OneTableView: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.backgroundColor = .red
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = .green
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50;
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if let view = self.footer {
      return view
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if let view = self.footer {
      return 800
    }
    return 0.00001
  }
  
}
