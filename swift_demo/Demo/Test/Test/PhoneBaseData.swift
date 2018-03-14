//
//  PhoneBaseData.swift
//  Test
//
//  Created by TW on 2018/1/17.
//  Copyright © 2018年 lml. All rights reserved.
//

import Foundation
import CoreTelephony

class PhoneBaseData {
    var userPhone: String = ""  //用户手机号
    var os: String = "iOS"      //操作系统
    var osVersion: String = ""  //操作系统版本
    var screenHeight: CGFloat = 0.0 //屏幕高度
    var screenWidth: CGFloat = 0.0  //屏幕宽度
    var wifi: Bool = false        //是否使用wifi
    var browser: String = ""      //浏览器名
    var browserVersion: String = "" //浏览器版本
    var carrier: String = ""      //运营商名称
    var networkType: String = ""  //网络类型
    var appVersion: String = ""   //应用版本
    var manufacturer: String = "Apple"  //设备制造商
    var model: String = ""        //手机型号
    
    func getPhoneBaseData() -> [String: Any] {
        //应用程序信息
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"]//主程序版本号
        let appVersion = majorVersion as! String
        //设备信息
        let iosVersion = UIDevice.current.systemVersion //iOS版本
        let systemName = UIDevice.current.systemName //设备名称
        let modelName = UIDevice.current.modelName //设备具体型号
        //手机尺寸
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        //是否使用wifi
        let isWifi = self.isUseWifi()
        //获取运营商名称
        let operatorName = self.getOperatorName()
        //获取网络状态
        let networkingState = self.getNetworingState()
        //用户手机号 ??
        
        
        //打印信息
        print("主程序版本号：\(appVersion)")
        print("iOS版本：\(iosVersion)")
        print("设备名称：\(systemName)")
        print("设备具体型号：\(modelName)")
        print("手机高度：\(height)")
        print("手机宽度：\(width)")
        print("是否使用wifi：\(isWifi)")
        print("运营商：\(operatorName)")
        print("网络状态：\(networkingState)")
        self.osVersion = iosVersion
        self.screenWidth = width
        self.screenHeight = height
        self.wifi = isWifi
        self.carrier = operatorName
        self.networkType = networkingState
        self.appVersion = appVersion
        self.model = modelName
        
        let parem: [String: Any] = ["userPhone": userPhone,
                     "os": os,
                     "osVersion": osVersion,
                     "screenHeight": screenHeight,
                     "screenWidth": screenWidth,
                     "wifi": wifi,
                     "browser": browser,
                     "browserVersion": browserVersion,
                     "carrier": carrier,
                     "networkType": networkType,
                     "appVersion": appVersion,
                     "manufacturer": manufacturer,
                     "model": model]
        
        return parem
    }
    //获取网络状态
    private func getNetworingState() -> String {
        let info = CTTelephonyNetworkInfo()
        if self.isUseWifi() {
            return "wifi"
        }
        guard let current = info.currentRadioAccessTechnology else {
            return ""
        }
        switch current {
        case CTRadioAccessTechnologyLTE:
            return "4G"
        case CTRadioAccessTechnologyEdge,CTRadioAccessTechnologyGPRS:
            return "2G"
        default:
            return "3G"
        }
    }
    //获取运营商名称
    private func getOperatorName() -> String {
        let info = CTTelephonyNetworkInfo()
        guard let carrier = info.subscriberCellularProvider else {
            return ""
        }
        if (carrier.isoCountryCode != nil) {
            return carrier.carrierName ?? ""
        }else {
            return "无运营商"
        }
    }
    //是否使用wifi
    private func isUseWifi() -> Bool {
        
        let reachability = Reachability()!
        var isWifi: Bool = false
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                isWifi = true
            } else {
                isWifi = false
            }
        }
        reachability.whenUnreachable = { _ in
            isWifi = false
        }
        return isWifi
    }
}

//扩展UIDevice
extension UIDevice {
    //获取设备具体详细的型号
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7 (CDMA)"
        case "iPhone9,3":                               return "iPhone 7 (GSM)"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
        case "iPhone10,1":                              return "iPhone 8 (CDMA)"
        case "iPhone10,4":                              return "iPhone 8 (GSM)"
        case "iPhone10,2":                              return "iPhone 8 Plus (CDMA)"
        case "iPhone10,5":                              return "iPhone 8 Plus (GSM)"
        case "iPhone10,3":                              return "iPhone X (CDMA)"
        case "iPhone10,6":                              return "iPhone X (GSM)"
            
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

