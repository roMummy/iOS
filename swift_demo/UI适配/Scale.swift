//
//  FZScale.swift
//  PdfConver
//
//  Created by FSKJ on 2022/5/19.
//

import Foundation
import UIKit

fileprivate let standardWidth = 375.0
fileprivate let standardHeight = 667.0

extension BinaryInteger {
    /// 根据比例缩放
    public func scale(_ newValue: CGFloat) -> Double {
        let temp = Double(self)
        return temp * newValue
    }

    /// 横轴缩放
    public var hscale: Double {
        let scaleW = UIScreen.main.bounds.width / standardWidth
        return scale(scaleW)
    }

    /// 纵轴缩放
    public var vscale: Double {
        let scaleW = UIScreen.main.bounds.height / standardHeight
        return scale(scaleW)
    }
}
extension BinaryFloatingPoint {
    /// 根据比例缩放
    public func scale(_ newValue: CGFloat) -> Double {
        let temp = Double(self)
        return temp * newValue
    }

    /// 横轴缩放
    public var hscale: Double {
        let scaleW = UIScreen.main.bounds.width / standardWidth
        return scale(scaleW)
    }

    /// 纵轴缩放
    public var vscale: Double {
        let scaleW = UIScreen.main.bounds.height / standardHeight
        return scale(scaleW)
    }
}
extension CGFloat {
    /// 根据比例缩放
    public func scale(_ newValue: CGFloat) -> CGFloat {
        let temp = CGFloat(self)
        return temp * newValue
    }

    /// 横轴缩放
    public var hscale: CGFloat {
        let scaleW = UIScreen.main.bounds.width / standardWidth
        return scale(scaleW)
    }

    /// 纵轴缩放
    public var vscale: CGFloat {
        let scaleW = UIScreen.main.bounds.height / standardHeight
        return scale(scaleW)
    }
}
// MARK: - ==============xib适配==================
struct FZAdapterScreen {
    static func adapterFont(font: UIFont?) -> UIFont? {
        guard let font = font,
              let sizeNumber = font.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName(rawValue: "NSFontSizeAttribute")) as? NSNumber else {return nil}
        let newFont = UIFont(name: font.familyName, size: CGFloat(sizeNumber.floatValue).hscale)
        return newFont
    }
    static func adapterLayoutConstraint(constant: CGFloat) -> CGFloat {
        return constant.hscale
    }
}

extension UIView {
    private struct AssociatedKeys {
        static var adapterScreenInAllSubviewsKey = "adapterScreenInAllSubviewsKey"
    }
    /// 开启所有子view的适配
    @IBInspectable var adapterScreenInAllSubviews: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.adapterScreenInAllSubviewsKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.adapterScreenInAllSubviewsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                for subview in subviews {
                    if let subview = subview as? UIButton {
                        subview.adapterFont = newValue
                    }
                    if let subview = subview as? UILabel {
                        subview.adapterFont = newValue
                    }
                    if let subview = subview as? UITextField {
                        subview.adapterFont = newValue
                    }
                    if let subview = subview as? UITextView {
                        subview.adapterFont = newValue
                    }
                    subview.constraints.forEach {$0.adapterScreen = newValue}
                }
            }
        }
    }
}

// MARK: - Xib 适配
extension NSLayoutConstraint {
    private struct AssociatedKeys {
        static var adapterScreenKey = "adapterScreenKey"
    }

    /// 开启适配
    @IBInspectable var adapterScreen: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.adapterScreenKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.adapterScreenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                self.constant = FZAdapterScreen.adapterLayoutConstraint(constant: self.constant)
            }
        }
    }
}

// MARK: - UIButton
extension UIButton {
    private struct AssociatedKeys {
        static var adapterFontKey = "adapterFontKey"
    }

    /// 开启适配
    @IBInspectable var adapterFont: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.adapterFontKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.adapterFontKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                self.titleLabel?.font = FZAdapterScreen.adapterFont(font: titleLabel?.font)
            }
        }
    }
}
// MARK: - UILabel
extension UILabel {
    private struct AssociatedKeys {
        static var adapterFontKey = "adapterFontKey"
    }
    /// 开启适配
    @IBInspectable var adapterFont: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.adapterFontKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.adapterFontKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                self.font = FZAdapterScreen.adapterFont(font: font)
            }
        }
    }
}

// MARK: - UITextField
extension UITextField {
    private struct AssociatedKeys {
        static var adapterFontKey = "adapterFontKey"
    }
    /// 开启适配
    @IBInspectable var adapterFont: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.adapterFontKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.adapterFontKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                self.font = FZAdapterScreen.adapterFont(font: font)
            }
        }
    }
}

// MARK: - UITextView
extension UITextView {
    private struct AssociatedKeys {
        static var adapterFontKey = "adapterFontKey"
    }
    /// 开启适配
    @IBInspectable var adapterFont: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.adapterFontKey) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.adapterFontKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                self.font = FZAdapterScreen.adapterFont(font: font)
            }
        }
    }
}
