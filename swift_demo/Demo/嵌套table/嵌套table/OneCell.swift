//
//  OneCell.swift
//  Moretable
//
//  Created by ZQ on 2020/10/28.
//  Copyright © 2020 grdoc. All rights reserved.
//

import UIKit
import SnapKit

class OneCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var oneTable: OneTableView = {
    let table = OneTableView(frame: CGRect(x: 0, y: 0, width: 418, height: 500))
    return table
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setupUI() {
    self.contentView.addSubview(oneTable)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    oneTable.snp.makeConstraints { (make) in
      make.edges.equalTo(self.contentView)
    }
  }
  
}
