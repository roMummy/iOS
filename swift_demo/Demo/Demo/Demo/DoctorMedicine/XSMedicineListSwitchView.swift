//
//  XSMedicineListSwitchView.swift
//  Demo
//
//  Created by ZQ on 2020/5/28.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit

protocol XSMedicineListSwitchViewDelegate: class {
  func onClickLeft()
  func onClickRight()
}

class XSMedicineListSwitchView: UIView {
  
  weak var delegate: XSMedicineListSwitchViewDelegate?
  
  lazy var leftBtn: UIButton = {
    let btn = UIButton(type: .custom)
    btn.addTarget(self, action: #selector(leftClick(sender:)), for: .touchUpInside)
    btn.setTitle("left", for: .normal)
    return btn
  }()
  
  lazy var rightBtn: UIButton = {
    let btn = UIButton(type: .custom)
    btn.addTarget(self, action: #selector(rightClick(sender:)), for: .touchUpInside)
    btn.setTitle("right", for: .normal)
    return btn
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    self.addSubview(leftBtn)
    self.addSubview(rightBtn)
    
    leftBtn.snp.makeConstraints { (make) in
      make.left.top.bottom.equalTo(self)
      make.width.equalTo(WIDTH/2)
    }
    rightBtn.snp.makeConstraints { (make) in
      make.right.top.bottom.equalTo(self)
      make.width.equalTo(WIDTH/2)
    }
  }
  
  @objc
  func leftClick(sender: UIButton) {
    if let delegate = delegate {
      delegate.onClickLeft()
    }
  }
  
  @objc
  func rightClick(sender: UIButton) {
    if let delegate = delegate {
      delegate.onClickRight()
    }
  }
  
}
