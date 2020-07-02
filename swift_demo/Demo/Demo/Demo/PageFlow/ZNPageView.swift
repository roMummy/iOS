//
//  ZNPageView.swift
//  pageFlowView
//
//  Created by cocoboy on 2017/3/29.
//  Copyright © 2017年 zn. All rights reserved.
//

import UIKit

class ZNPageView: UIView {
    static let switchNotificationName = "ZNPageViewswitchNotificationName"
    fileprivate var titles : [String]
    fileprivate var numbers : [String]
    fileprivate var childsVc : [UIViewController]
    fileprivate weak var parentVc : UIViewController?
    fileprivate var style : ZNTitleStyle
    public var titleView : ZNTitleView!
    
     fileprivate var currentIndex : Int = 0
  init(frame: CGRect,titles :[String],childsVc : [UIViewController],parentVc : UIViewController,style : ZNTitleStyle,currentIndex : Int,numbers:[String]) {
        self.titles = titles
        self.childsVc = childsVc
        self.parentVc = parentVc
        self.style = style
        self.currentIndex = currentIndex;
        self.numbers = numbers;
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: 设置UI
extension ZNPageView{

    fileprivate func setupUI(){
        setupTitleView()
        setupContentView()
    }
    
    private func setupTitleView() {
        
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
      titleView = ZNTitleView(frame: titleFrame, titles: titles,style : style,currentIndex:self.currentIndex,numbers:self.numbers)
        addSubview(titleView)
        titleView.backgroundColor = UIColor.white
        
    }
    
    private func setupContentView() {
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = ZNContentView(frame: contentFrame, childVcs: childsVc, parentVc: parentVc,currentIndex:self.currentIndex)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        
        //设置代理
        titleView.delegate = contentView
        contentView.delegate = titleView
      
    }

}

