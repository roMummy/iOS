//
//  AllExtensionSwift.swift
//  SellSignName
//
//  Created by Max on 17/8/10.
//  Copyright © 2017年 代俊. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     *  重绘图片颜色
     */
    func redrawColor(_ color: UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}

extension UIColor {
    
    /**
     *  16进制 转 RGBA
     */
    class func rgbaColorFromHex(rgb:Int, alpha:CGFloat) ->UIColor {
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
    /**
     *  16进制 转 RGB
     */
    class func rgbColorFromHex(rgb:Int) ->UIColor {
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
}

