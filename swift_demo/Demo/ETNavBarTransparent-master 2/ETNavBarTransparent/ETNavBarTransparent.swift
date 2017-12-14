//
//  ETNavBarTransparent.swift
//  ETNavBarTransparentDemo
//
//  Created by Bing on 2017/3/1.
//  Copyright © 2017年 tanyunbing. All rights reserved.
//

import UIKit

extension UIColor {
    // System default bar tint color
    open class var defaultNavBarTintColor: UIColor {
        return UIColor(red: 244/255.0, green: 137/255.0, blue: 50/255.0, alpha: 1.0)
    }
}
//标题默认样式
let defaultAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]

extension DispatchQueue {
    
    private static var onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}

extension UINavigationController {
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return topViewController
    }
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    
    open override func viewDidLoad() {
        UINavigationController.swizzle()
        super.viewDidLoad()
    }
    
    private static let onceToken = UUID().uuidString
    
    class func swizzle() {
        guard self == UINavigationController.self else { return }
        
        DispatchQueue.once(token: onceToken) {
            let needSwizzleSelectorArr = [
                NSSelectorFromString("_updateInteractiveTransition:"),
                #selector(popToViewController),
                #selector(popToRootViewController)
            ]
            
            for selector in needSwizzleSelectorArr {
                
                let str = ("et_" + selector.description).replacingOccurrences(of: "__", with: "_")
                // popToRootViewControllerAnimated: et_popToRootViewControllerAnimated:
                
                let originalMethod = class_getInstanceMethod(self, selector)
                let swizzledMethod = class_getInstanceMethod(self, Selector(str))
                if originalMethod != nil && swizzledMethod != nil {
                    method_exchangeImplementations(originalMethod!, swizzledMethod!)
                }
            }
        }
    }
    
    @objc func et_updateInteractiveTransition(_ percentComplete: CGFloat) {
        guard let topViewController = topViewController, let coordinator = topViewController.transitionCoordinator else {
            et_updateInteractiveTransition(percentComplete)
            return
        }
        
        let fromViewController = coordinator.viewController(forKey: .from)
        let toViewController = coordinator.viewController(forKey: .to)
        
        // Bg Alpha
        let fromAlpha = fromViewController?.navBarBgAlpha ?? 0
        let toAlpha = toViewController?.navBarBgAlpha ?? 0
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete
        
        setNeedsNavigationBackground(alpha: newAlpha)
        
        // Tint Color
        let fromColor = fromViewController?.navBarTintColor ?? .black
        let toColor = toViewController?.navBarTintColor ?? .black
        let newColor = averageColor(fromColor: fromColor, toColor: toColor, percent: percentComplete)
        navigationBar.tintColor = newColor
//        debugPrint(percentComplete)
        navigationBar.titleTextAttributes = topViewController.titleTextAttributes
        et_updateInteractiveTransition(percentComplete)
    }
    
    // Calculate the middle Color with translation percent
    private func averageColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed - fromRed) * percent
        let nowGreen = fromGreen + (toGreen - fromGreen) * percent
        let nowBlue = fromBlue + (toBlue - fromBlue) * percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
    
    @objc func et_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        setNeedsNavigationBackground(alpha: viewController.navBarBgAlpha)
        navigationBar.tintColor = viewController.navBarTintColor
        navigationBar.titleTextAttributes = viewController.titleTextAttributes
        return et_popToViewController(viewController, animated: animated)
    }
    
    @objc func et_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        setNeedsNavigationBackground(alpha: viewControllers.first?.navBarBgAlpha ?? 0)
        navigationBar.tintColor = viewControllers.first?.navBarTintColor
        navigationBar.titleTextAttributes = viewControllers.first?.titleTextAttributes
        return et_popToRootViewControllerAnimated(animated)
    }
    
    fileprivate func setNeedsNavigationBackground(alpha: CGFloat) {
        let barBackgroundView = navigationBar.subviews[0]
        
        let valueForKey = barBackgroundView.value(forKey:)
        
        if let shadowView = valueForKey("_shadowView") as? UIView {
            shadowView.alpha = alpha
            shadowView.isHidden = alpha == 0
        }
        
        if navigationBar.isTranslucent {
            if #available(iOS 10.0, *) {
                if let backgroundEffectView = valueForKey("_backgroundEffectView") as? UIView, navigationBar.backgroundImage(for: .default) == nil {
                    backgroundEffectView.alpha = alpha
                    return
                }
                
            } else {
                if let adaptiveBackdrop = valueForKey("_adaptiveBackdrop") as? UIView , let backdropEffectView = adaptiveBackdrop.value(forKey: "_backdropEffectView") as? UIView {
                    backdropEffectView.alpha = alpha
                    return
                }
            }
        }
        
        barBackgroundView.alpha = alpha
    }
}

extension UINavigationController: UINavigationBarDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        navigationBar.titleTextAttributes = topViewController?.titleTextAttributes
        if let topVC = topViewController, let coor = topVC.transitionCoordinator, coor.initiallyInteractive {
            if #available(iOS 10.0, *) {
                coor.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                })
            } else {
                coor.notifyWhenInteractionEnds({ (context) in
                    self.dealInteractionChanges(context)
                })
            }
            return true
        }
        
        let itemCount = navigationBar.items?.count ?? 0
        let n = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - n]
        
        popToViewController(popToVC, animated: true)
        return true
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        setNeedsNavigationBackground(alpha: topViewController?.navBarBgAlpha ?? 0)
        navigationBar.tintColor = topViewController?.navBarTintColor
        navigationBar.titleTextAttributes = topViewController?.titleTextAttributes
        return true
    }
    
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        let animations: (UITransitionContextViewControllerKey) -> () = {
            let nowAlpha = context.viewController(forKey: $0)?.navBarBgAlpha ?? 0
            self.setNeedsNavigationBackground(alpha: nowAlpha)
            self.navigationBar.titleTextAttributes = context.viewController(forKey: $0)?.titleTextAttributes
            self.navigationBar.tintColor = context.viewController(forKey: $0)?.navBarTintColor
        }
        
        if context.isCancelled {//手势失败
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        } else {//手势成功
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
        
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
}

extension UIViewController {
    
    fileprivate struct AssociatedKeys {
        static var navBarBgAlpha: CGFloat = 1.0
        static var navBarTintColor: UIColor = UIColor.defaultNavBarTintColor
        static var titleTextAttributes: [NSAttributedStringKey : Any] = defaultAttributes
    }
    /**导航栏背景透明度**/
    open var navBarBgAlpha: CGFloat {
        get {
            guard let alpha = objc_getAssociatedObject(self, &AssociatedKeys.navBarBgAlpha) as? CGFloat else {
                return 1.0
            }
            return alpha
            
        }
        set {
            let alpha = max(min(newValue, 1), 0) // 必须在 0~1的范围
            
            objc_setAssociatedObject(self, &AssociatedKeys.navBarBgAlpha, alpha, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            // Update UI
            navigationController?.setNeedsNavigationBackground(alpha: alpha)
        }
    }
    /**barTintColor颜色**/
    open var navBarTintColor: UIColor {
        get {
            guard let tintColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarTintColor) as? UIColor else {
                return UIColor.defaultNavBarTintColor
            }
            return tintColor
            
        }
        set {
            navigationController?.navigationBar.tintColor = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.navBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /**title样式**/
    open var titleTextAttributes: [NSAttributedStringKey : Any] {
        get {
            guard let attribute = objc_getAssociatedObject(self, &AssociatedKeys.titleTextAttributes) as? [NSAttributedStringKey : Any] else {
                return defaultAttributes
            }
            return attribute
        }
        set {
            navigationController?.navigationBar.titleTextAttributes = newValue
            objc_setAssociatedObject(self, &AssociatedKeys.titleTextAttributes, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
