//
//  AspectManager.swift
//  Test
//
//  Created by TW on 2018/1/18.
//  Copyright © 2018年 lml. All rights reserved.
//

import Foundation

struct AspectManager {
    static func swizzle(inClass `class`: AnyClass, swizzle : Selector, original: Selector){
        
        //动态获取方法实例
        let originalMethod = class_getInstanceMethod(`class`, original)
        let swizzleMethod = class_getInstanceMethod(`class`, swizzle)
        
        //判断是否实现了这个方法
//        guard let originalMethods = originalMethod, let swizzleMethods = swizzleMethod  else {
//            return
//        }
        let didAddMethod = class_addMethod(`class`, original, method_getImplementation(swizzleMethod!), method_getTypeEncoding(swizzleMethod!))
        
        if didAddMethod {//不存在 添加
            class_replaceMethod(`class`, swizzle, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {//存在 直接交换方法
            method_exchangeImplementations(originalMethod!, swizzleMethod!)
        }
    }
}



public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

