//
//  NothingToSeeHere.swift
//  Test
//
//  Created by TW on 2018/1/18.
//  Copyright © 2018年 lml. All rights reserved.
//

import Foundation
/*
 增对 initialize方法在swift中即将被抛弃 替换方法
 */
public protocol SelfAware: class {
    static func awake()
}

class NothingToSeeHere {
    static func harmlessFunction(){
        let typeCount = Int(objc_getClassList(nil, 0))
        let  types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleaseintTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleaseintTypes, Int32(typeCount)) //获取所有的类
        for index in 0 ..< typeCount{
            (types[index] as? SelfAware.Type)?.awake() //如果该类实现了SelfAware协议，那么调用awake方法
        }
        types.deallocate(capacity: typeCount)
    }
}
extension UIApplication {
    private static let runOnce:Void = {
        //使用静态属性以保证只调用一次(该属性是个方法)
        NothingToSeeHere.harmlessFunction()
    }()
    
    open override var next: UIResponder?{
        UIApplication.runOnce
        return super.next
    }
}

/// 将类设置为代理并在代理中实现运行时代吗
extension UIControl:SelfAware{
    public static func awake() {
        //make sure this isn't a subclass
//        if self !== UIControl.self {
//            return
//        }

        DispatchQueue.once(token: UUID().uuidString) {
            swizzle()
        }
    }
    fileprivate class func swizzle(){
        let originalSelector = #selector(UIControl.sendAction(_:to:for:))
        let swizzleSelector = #selector(UIControl.nsh_sendAction(_:to:for:))
        AspectManager.swizzle(inClass: self, swizzle: swizzleSelector, original: originalSelector)
    }


    @objc func nsh_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?){
        //因为交换了两个方法的实现所以不用担心会死循环
        nsh_sendAction(action, to: target, for: event)

        //在这里做你想要处理的埋点事件，identifier可以自己配置一个文件，然后按照生成的id去取定义好的一些需要埋点的事件名
        guard let target = target as? AnyClass else {
            return
        }
        let targetStr = NSStringFromClass(target.class())
        print(targetStr)
    }
}

extension UITableView: SelfAware {
    public static func awake() {
        swizzle()
    }
    fileprivate class func swizzle(){
        let originalSelector = #selector(setter: UITableView.delegate)
        let swizzleSelector = #selector(UITableView.nsh_set(delegate:))
        AspectManager.swizzle(inClass: self, swizzle: swizzleSelector, original: originalSelector)
    }
    
    @objc func nsh_tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        nsh_tableView(tableView, didSelectRowAt: indexPath)
        //这里添加你需要的埋点代码
    }
    @objc func nsh_set(delegate: UITableViewDelegate?){
        nsh_set(delegate: delegate)
        
        guard let delegate =  delegate else {return}
        //交换cell点击事件
        print(delegate)
        let originalSelector = #selector(delegate.tableView(_:didSelectRowAt:))
        let swizzleSelector = #selector(UITableView.nsh_tableView(_:didSelectRowAt:))
        let swizzleMethod = class_getInstanceMethod(UITableView.self, swizzleSelector)
        
        let didAddMethod = class_addMethod(type(of: delegate), swizzleSelector, method_getImplementation(swizzleMethod!), method_getTypeEncoding(swizzleMethod!))
        if didAddMethod{
            let didSelectOriginalMethod = class_getInstanceMethod(type(of: delegate), NSSelectorFromString("nsh_tableView:didSelectRowAt:"))
            let didSelectSwizzledMethod = class_getInstanceMethod(type(of: delegate), originalSelector)
            method_exchangeImplementations(didSelectOriginalMethod!, didSelectSwizzledMethod!)
        }
    }
      
}
