//
//  SearchView.swift
//  Demo
//
//  Created by ZQ on 2020/5/22.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: class {
  func didSelectRowAt(id: String)
}

class SearchView: UIView {
  
  weak var delegate: SearchViewDelegate?
  
  lazy var tableView: UITableView = {
    let table = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
    table.dataSource = self
    table.delegate = self
    table.rowHeight = 45
    return table
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalTo(self)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var count: Int = 0 {
    willSet {
      tableView.backgroundColor = (newValue == 0 ? UIColor(white: 0, alpha: 0.3): .white)
      tableView.reloadData()
    }
  }
  
}
extension SearchView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    //    cell.contentView.backgroundColor = .clear
    cell.textLabel?.text = "index\(indexPath.row)"
    return cell
  }
}
extension SearchView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      delegate.didSelectRowAt(id: "")
    }
  }
}
