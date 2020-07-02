//
//  UIColor+Extension.swift
//  XMGTV
//
//  Created by cocoboy on 2017/3/27.
//  Copyright © 2017年 coderwhy. All rights reserved.
//

import UIKit

extension UIColor{
    
    //在extension中给系统的类扩充构造函数,只能扩充`便利构造函数`
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    convenience init?(hexString: String,alpha: CGFloat = 1.0) {
        
//        guard hex.characters.count>=6 else {
//            return nil
//        }
        
        //字符串转大写
        var tempHex = hexString.uppercased()
        
        if tempHex.hasPrefix("##") || tempHex.hasPrefix("0x") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        // 4.分别取出RGB
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        // 5.将十六进制转成数字
        var r : UInt32 = 0 , b : UInt32 = 0 , g : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
         self.init(r : CGFloat(r), g : CGFloat(g), b : CGFloat(b))
    }
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
}
