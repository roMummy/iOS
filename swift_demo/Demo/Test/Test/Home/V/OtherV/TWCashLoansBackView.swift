//
//  TWCashLoansBackView.swift
//  Test
//
//  Created by TW on 2017/8/15.
//  Copyright © 2017年 lml. All rights reserved.
//

import UIKit

class TWCashLoansBackView: UIView {

    let baseMessageTitles = ["姓名", "合同编号", "标记"]
    let baseMassageTexts = ["姓名": "张三", "合同编号": "234243242", "标记": "不需要了"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        //self.backgroundColor = .clear
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.addSubview(self.maskOfView)
        
        
        self.addSubview(self.alertView)
        alertView.mas_makeConstraints { (make) in
            make?.center.equalTo()(self)
            make?.size.mas_equalTo()(CGSize.init(width: 250, height: 310))
        }
        
    }
    
    //remove
    func removeView() {
        self.removeFromSuperview()
    }
    //add
    func addView() {
        
    }
    
    //MARK: - lazy
    
    lazy var maskOfView: UIView = {
        
        let view = UIView()
        view.frame = self.frame
        view.backgroundColor = UIColor.rgbaColorFromHex(rgb: 0x000, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var alertView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        
        //基本信息
        view.addSubview(self.baseMassageView)
        self.baseMassageView.mas_makeConstraints({ (make) in
            make?.top.left().right().equalTo()(view)
            make?.height.mas_equalTo()(self.baseMassageTexts.count * 20 + 45)
        })
        
        //返回地方
        view.addSubview(self.backAddressView)
        self.backAddressView.mas_makeConstraints({ (make) in
            make?.left.right().equalTo()(view)
            make?.top.equalTo()(self.baseMassageView.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(60)
        })
        
        //退回原因
        view.addSubview(self.returnReasonView)
        self.returnReasonView.mas_makeConstraints({ (make) in
            make?.left.right().equalTo()(view)
            make?.top.equalTo()(self.backAddressView.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(90)
        })
        
        //选择按钮
        view.addSubview(self.selectButtonView)
        self.selectButtonView.mas_makeConstraints({ (make) in
            make?.left.right().equalTo()(view)
            make?.top.equalTo()(self.returnReasonView.mas_bottom)?.offset()(5)
            make?.height.mas_equalTo()(40)
        })
        
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        
        return view
    }()

    lazy var baseMassageView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        
        //head
        let head = self.headView("基本信息")
        view.addSubview(head)
        head.mas_makeConstraints({ (make) in
            make?.top.mas_equalTo()(20)
            make?.left.mas_equalTo()(15)
        })
        
        //name
        
        for (index, value) in self.baseMessageTitles.enumerated() {
    
            var keyM = value
            if keyM.characters.count == 2 {
                for _ in 0..<8 {
                    keyM.insert(" ", at: keyM.index(before: keyM.endIndex))
                }
            }
            keyM += ":"
            
            let left = UILabel()
            left.text = keyM
            left.textColor = UIColor.rgbColorFromHex(rgb: 0x808080)
            left.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(left)
            left.mas_makeConstraints({ (make) in
                make?.top.equalTo()(head.mas_bottom)?.offset()(CGFloat(20*index + 10))
                make?.left.equalTo()(head.mas_left)?.offset()(25)
            })
            
            let right = UILabel()
            right.text = self.baseMassageTexts[value]
            right.textColor = UIColor.rgbColorFromHex(rgb: 0x808080)
            right.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(right)
            right.mas_makeConstraints({ (make) in
                make?.left.equalTo()(left.mas_right)?.offset()(15)
                make?.centerY.equalTo()(left)
            })
            
        }
        
        return view
    }()
    
    lazy var backAddressView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        //head
        let head = self.headView("返回地方")
        view.addSubview(head)
        head.mas_makeConstraints({ (make) in
            make?.top.equalTo()(view)
            make?.left.mas_equalTo()(15)
        })
        
        return view
    }()
    
    lazy var returnReasonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        //head
        let head = self.headView("退回原因")
        view.addSubview(head)
        head.mas_makeConstraints({ (make) in
            make?.top.equalTo()(view)
            make?.left.mas_equalTo()(15)
        })
        
        //UITextView
        let textView = UITextView()
        textView.layer.borderColor = UIColor.rgbColorFromHex(rgb: 0xe5e5e5).cgColor
        textView.layer.borderWidth = 1.0
        textView.delegate = self as? UITextViewDelegate
        view.addSubview(textView)
        textView.mas_makeConstraints({ (make) in
            make?.top.equalTo()(head.mas_bottom)?.offset()(10)
            make?.left.mas_equalTo()(15)
            make?.right.mas_equalTo()(-15)
            make?.height.mas_equalTo()(45)
        })
        
        return view
    }()
    
    lazy var selectButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        //top line
        let topLine = UIView()
        topLine.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1)
        topLine.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xe5e5e5)
        view.addSubview(topLine)
        
        //center line
        let centerLine = UIView()
        centerLine.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xe5e5e5)
        view.addSubview(centerLine)
        centerLine.mas_makeConstraints({ (make) in
            make?.center.equalTo()(view)
            make?.width.mas_equalTo()(1)
            make?.top.bottom().equalTo()(view)
        })
        
        //true button
        let trueButton = UIButton(type: .custom)
        trueButton.setTitle("确定", for: .normal)
        trueButton.setTitleColor(UIColor.rgbColorFromHex(rgb: 0x808080), for: .normal)
        trueButton.addTarget(self, action: #selector(trueButtonClick), for: .touchUpInside)
        trueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(trueButton)
        trueButton.mas_makeConstraints({ (make) in
            make?.left.top().bottom().equalTo()(view)
            make?.right.equalTo()(centerLine.mas_left)
        })
        
        //cancel button
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.rgbColorFromHex(rgb: 0x808080), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(cancelButton)
        cancelButton.mas_makeConstraints({ (make) in
            make?.right.top().bottom().equalTo()(view)
            make?.left.equalTo()(centerLine.mas_right)
        })
        
        return view

    }()

}
extension TWCashLoansBackView {
    
    ///action
    
    //headview
    func headView(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.rgbColorFromHex(rgb: 0xf16d1b)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }
}
extension TWCashLoansBackView {
    
    //确定
    @objc func trueButtonClick() {
        print("确定")
    }
    
    //取消
    @objc func cancelButtonClick() {
        print("取消")
        removeView()
    }
    
    //点击页面
    @objc func tapView() {
        removeView()
    }
}
