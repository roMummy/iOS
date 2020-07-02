//
//  XSMedicineListOnMoreView.swift
//  Demo
//
//  Created by ZQ on 2020/5/28.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit

class XSMedicineListOnMoreView: UIViewController {


  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    
    let cVcs = [
    XSMedicineListOnMoreChildViewController(type: 0),
    XSMedicineListOnMoreChildViewController(type: 1),
    XSMedicineListOnMoreChildViewController(type: 2)
    ]
    
    let style = ZNTitleStyle()
    style.isScrollEnable = false
    
    let pageView = ZNPageView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 500), titles: ["1","2","3"], childsVc: cVcs, parentVc: self, style: style, currentIndex: 0, numbers: ["0","0","0"])
    
    self.view.addSubview(pageView)
  }
  
  
}


