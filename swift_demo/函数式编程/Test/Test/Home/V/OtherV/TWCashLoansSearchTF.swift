//
//  TWCashLoansSearchTF.swift
//  Test
//
//  Created by TW on 2017/8/15.
//  Copyright © 2017年 lml. All rights reserved.
//

import UIKit

class TWCashLoansSearchTF: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.placeholder = "请输入客户姓名"
        self.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xf2f2f2)
        self.font = UIFont.boldSystemFont(ofSize: 14)
        self.clearButtonMode = .whileEditing
        //        textField.delegate = self
//        self.addTarget(self, action: #selector(textFieldEditChanged(_ :)), for: .editingChanged)
        self.autocorrectionType = .no
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        //图片
        let imageView = UIImageView.init(image: UIImage.init(named: "search_whiteSpace"))
        imageView.frame =  CGRect(x: 5, y: 0, width: 15, height: 15)
        
        //view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        view.addSubview(imageView)
        self.leftView = view
        self.leftViewMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
