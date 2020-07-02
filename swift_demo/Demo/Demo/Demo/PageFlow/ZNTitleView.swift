//
//  ZNTitleView.swift
//  pageFlowView
//
//  Created by cocoboy on 2017/3/29.
//  Copyright © 2017年 zn. All rights reserved.
//

import UIKit

protocol ZNTitleViewDelegate : class {
  func titleView(_ titleView: ZNTitleView , targetIndex : Int)
}

class ZNTitleView: UIView {
  //    fileprivate var lineView = UIView()
  fileprivate lazy var lineView: UIView = {
    let view = UIView()
    return view
  }()
  
  weak var delegate : ZNTitleViewDelegate?
  fileprivate var titles : [String]
  fileprivate var numbers : [String]
  fileprivate var style : ZNTitleStyle
  fileprivate var currentIndex : Int = 0
  fileprivate lazy var scrollView : UIScrollView = {
    let scrollView = UIScrollView(frame: self.bounds)
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.scrollsToTop = false
    scrollView.backgroundColor = UIColor.white
    return scrollView
  }()
  fileprivate lazy var bottomLine : UIView = {
    let view = UIView()
//    view.backgroundColor = UIColor(hexString:"#CCCCC")
    return view
  }()
  fileprivate var titleLables : [UILabel] = [UILabel]()
  fileprivate var numLables : [UILabel] = [UILabel]()
  
  init(frame: CGRect,titles : [String] ,style : ZNTitleStyle,currentIndex:Int,numbers:[String]) {
    self.titles = titles
    self.style = style
    self.currentIndex = currentIndex;
    self.numbers = numbers;
    super.init(frame: frame)
    setupUI()
    //    NotificationCenter.default.addObserver(self, selector: #selector(initClick), name: NSNotification.Name(rawValue:"changePage"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(changeNumber), name: NSNotification.Name(rawValue:"changeNumber"), object: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // 
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if let line = style.customLineView {
//      line.center.x = self.lineView.width/2
//      line.center.y = 0
    }
  }
  
}



extension ZNTitleView{
  
  fileprivate func setupUI() {
    self.lineView.backgroundColor = style.scrollLineColor;
    //添加uiscrollview
    addSubview(scrollView)
//    bottomLine.frame = CGRect(x: 0, y: self.height - 1 , width: scrollView.frame.size.width , height:1)
    
    //将titleLable添加到scrollview中
    setupTitleLables()
    
    //设置titlelalbe的frame
    setupTitleLablesFrame()
    scrollView.addSubview(bottomLine)
    
//    adjustTitleLabel(targetIndex: currentIndex)
//    self.delegate?.titleView(self, targetIndex: currentIndex)
  }
  
  
  private func setupTitleLables() {
    
    
    
    
    for (i,title) in titles.enumerated() {
      
      let titleLable = UILabel()
      titleLable.text = title
      titleLable.tag = i
      titleLable.textAlignment = .center
      titleLable.textColor = i == currentIndex ? style.selectColor : style.normalColor
      titleLable.font = i == currentIndex ? UIFont.boldSystemFont(ofSize: style.selectFontSize) : UIFont.systemFont(ofSize: style.normalFontSize)
      
      let numLable = UILabel()
      numLable.text = numbers[i];
      numLable.tag = i
      numLable.textAlignment = .center
      numLable.font = i == currentIndex ? UIFont.boldSystemFont(ofSize: style.selectFontSize) : UIFont.systemFont(ofSize: style.normalFontSize)
      numLable.textColor = i == currentIndex ? style.selectColor : style.normalColor
      
      scrollView.addSubview(titleLable)
      if style.hasAngle {
        scrollView.addSubview(numLable)
      }
      if i == currentIndex{
        //              lineView.backgroundColor = UIColor(hexString:"#18B87E")
        scrollView.addSubview(lineView)
        
        if let line = style.customLineView {
          lineView.addSubview(line)
        }
        
        
      }
      if i == style.showQuestionIndex {
//        scrollView.addSubview(failBtn);
      }
      
      titleLables.append(titleLable)
      numLables.append(numLable)
      
      
      let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLableClick(_:)))
      titleLable.addGestureRecognizer(tapGes)
      titleLable.isUserInteractionEnabled = true
      //            numLable.addGestureRecognizer(tapGes)
      //            numLable.isUserInteractionEnabled = true
      
    }
    
  }
  
  
  private func setupTitleLablesFrame() {
    
    let count = titles.count
    
    for (i,lable) in titleLables.enumerated() {
      
      var x : CGFloat = 0
      let y : CGFloat = -9
      var w : CGFloat = 0
      let h : CGFloat = bounds.height
      
      if style.isScrollEnable {
        w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : lable.font], context: nil).width
        if i==0 {
          x = style.itemMargin * 0.5
          
        }else{
          let preLalbe = titleLables[i - 1]
          x = preLalbe.frame.maxX + style.itemMargin
        }
        
      }else{  // 不能滚动
        w = bounds.width / CGFloat(count)
        x = w * CGFloat(i)
      }
      lable.frame = CGRect(x: x, y: y, width: w , height: h)
      if i == currentIndex {
        if style.hasAngle {
          lineView.frame = CGRect(x: x, y: y + 38 + 1 + 15 + 9 - 4, width: w , height: 8)
        }else {
          lineView.frame = CGRect(x: x, y: y + 38 + 10, width: w , height: 8)
        }
        
      }
      if i == style.showQuestionIndex {
//        failBtn.snp.makeConstraints { (make) in
//          make.right.equalTo(self).offset(-15)
//          make.centerY.equalTo(lable)
//          make.size.equalTo(CGSize(width: 15, height: 15))
//        }
      }
      numLables[i].frame = CGRect(x: x, y: y + 38 + 1 , width: w, height: 15)
      //            numLables[i].mas_makeConstraints { (make) in
      //            make?.top.mas_equalTo()(lable.mas_bottom)?.offset()(1)
      //            make?.centerX.equalTo()(lable)
      //            }
      
      
    }
    
    scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLables.last!.frame.maxX + 15 + style.itemMargin * 0.5, height: 0) : CGSize.zero
    self.initTitleLabel(targetIndex: currentIndex);
    //       delegate?.titleView(self, targetIndex: currentIndex)
  }
  
}


//MARK : 监听事件
extension ZNTitleView{
  //  ["number":datas.count,"index":0])
  @objc public func changeNumber(nofi : Notification){
    
    var targetIndex = 0
    targetIndex = nofi.userInfo!["index"] as! Int
    //     let number = nofi.userInfo!["number"] as! String
    let targetLable1 = numLables[targetIndex]
    if let number = nofi.userInfo!["number"] as? Int {
      targetLable1.text = number.description;
    }else {
      targetLable1.text = ""
    }
  }
  @objc fileprivate func initClick() {
    adjustTitleLabel(targetIndex:2)
    delegate?.titleView(self, targetIndex: currentIndex)
  }
  @objc fileprivate func titleLableClick(_ tapGes : UITapGestureRecognizer) {
    
    let targetLable = tapGes.view as! UILabel
    adjustTitleLabel(targetIndex: targetLable.tag)
    delegate?.titleView(self, targetIndex: currentIndex)
    NotificationCenter.default.post(name: NSNotification.Name(ZNPageView.switchNotificationName), object: nil, userInfo: ["index":currentIndex])
  }
  func initTitleLabel(targetIndex : Int) {
    
    
    //取出lable
    let targetLable = titleLables[targetIndex]
    
    //记录下下标值
    currentIndex = targetIndex
    
    if style.isScrollEnable {
      var offsetX = targetLable.center.x - scrollView.bounds.width * 0.5
      if offsetX < 0  {
        offsetX = 0
      }
      if offsetX > (scrollView.contentSize.width - scrollView.bounds.width) {
        offsetX = scrollView.contentSize.width - scrollView.bounds.width
      }
      
      scrollView.setContentOffset(CGPoint(x:offsetX,y:0), animated: true)
    }
  }
  fileprivate func adjustTitleLabel(targetIndex : Int) {
    
    if targetIndex == currentIndex {
      return
    }
    
    //取出lable
    let targetLable = titleLables[targetIndex]
    let sourceLable = titleLables[currentIndex]
    
    targetLable.textColor = style.selectColor
    targetLable.font = UIFont.boldSystemFont(ofSize: style.selectFontSize)
    sourceLable.textColor = style.normalColor
    sourceLable.font = UIFont.systemFont(ofSize: style.normalFontSize)
    
    let targetLable1 = numLables[targetIndex]
    let sourceLable1 = numLables[currentIndex]
    targetLable1.textColor = style.selectColor
    targetLable1.font = UIFont.boldSystemFont(ofSize: style.selectFontSize)
    sourceLable1.textColor = style.normalColor
    sourceLable1.font = UIFont.systemFont(ofSize: style.normalFontSize)
    
    UIView.animate( withDuration: 0.25){
      [weak self] in
//      self?.lineView.width = targetLable.width;
//      self?.lineView.centerX = targetLable.centerX;
    }
    //记录下下标值
    currentIndex = targetIndex
    
    if style.isScrollEnable {
      var offsetX = targetLable.center.x - scrollView.bounds.width * 0.5
      if offsetX < 0  {
        offsetX = 0
      }
      if offsetX > (scrollView.contentSize.width - scrollView.bounds.width) {
        offsetX = scrollView.contentSize.width - scrollView.bounds.width
      }
      
      scrollView.setContentOffset(CGPoint(x:offsetX,y:0), animated: true)
    }
  }
}


//MARK:  contentView代理方法 
extension ZNTitleView : ZNContentViewDelegate{
  
  func ZNContentView(_ contentView: ZNContentView, targetIndex: Int) {
    adjustTitleLabel(targetIndex: targetIndex)
    self.delegate?.titleView(self, targetIndex: currentIndex);//
  }
  
  
}





