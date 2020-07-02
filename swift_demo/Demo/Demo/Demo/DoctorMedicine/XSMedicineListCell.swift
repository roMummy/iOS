//
//  XSMedicineListCell.swift
//  XSFamilySignUserClient
//
//  Created by ZQ on 2020/5/28.
//  Copyright © 2020 com.xieshou. All rights reserved.
//

import UIKit

class XSMedicineListCell: UITableViewCell {
  
  lazy var scrollView:UIScrollView = {
    let scroll = UIScrollView(frame: CGRect.zero)
    scroll.backgroundColor = .yellow
    return scroll
  }()
  
  lazy var leftView: XSMedicineListOnDoctorView = {
    let vc = XSMedicineListOnDoctorView()
    vc.view.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 500)
    vc.view.backgroundColor = .red
    return vc
  }()
  
  lazy var rightView: XSMedicineListOnMoreView = {
    let vc = XSMedicineListOnMoreView()
    vc.view.frame = CGRect(x: WIDTH, y: 0, width: WIDTH, height: 500)
    vc.view.backgroundColor = .blue
    return vc
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func setupUI() {
    contentView.addSubview(scrollView)
    
    scrollView.addSubview(leftView.view)
    scrollView.addSubview(rightView.view)
    
    scrollView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(contentView)
      make.left.equalTo(contentView)
      make.width.equalTo(WIDTH * 2)
    }
    
  }
  
  func switchPage(by index: Int) {
    scrollView.setContentOffset(CGPoint(x: index * Int(WIDTH), y: 0), animated: true)
  }
  
}
