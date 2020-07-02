//
//  ZNContentView.swift
//  pageFlowView
//
//  Created by cocoboy on 2017/3/29.
//  Copyright © 2017年 zn. All rights reserved.
//

import UIKit

class ZNTitleStyle: UIView {

    var titleHeight : CGFloat = 55
    var normalColor = UIColor(hexString:"#484848")
    var selectColor = UIColor(hexString:"#2C2C2C")
    var normalFontSize : CGFloat = 12.0
    var selectFontSize : CGFloat = 13.0
    
    var isScrollEnable : Bool = true
    var itemMargin : CGFloat = 35.0
    
    var isShowScrollLine : Bool = false
    var scrollLineHeight : CGFloat = 2
    var scrollLineColor : UIColor = .orange
  
    /// 问号按钮所在页 0开始
    var showQuestionIndex = -1
    /// 自定义下划线
    var customLineView: UIView? = nil
    /// 是否有角标
    var hasAngle: Bool = false
}
