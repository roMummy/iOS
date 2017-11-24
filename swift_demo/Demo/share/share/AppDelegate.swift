//
//  AppDelegate.swift
//  share
//
//  Created by TW on 2017/11/20.
//  Copyright © 2017年 TW. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let UmengAppkey = "586c7a9bcae7e76598001390"
    let weixinAppID = "wx91985e9b01b452fb"
    let weixinAppSecret = "ba8fabee5e2c516ed4a428c02017299b"
    let qqAppID = "101359193"
    let qqAppSecret = "d4ddae0d581b82df187c589184dd84f0"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //设置友盟appKey
        UMSocialManager.default().umSocialAppkey = UmengAppkey
        
        //设置平台Key
        self.configUSharePlatforms()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    // MARK: - 设置分享key
    func configUSharePlatforms() {
        //微信        
        UMSocialManager.default().setPlaform(.wechatSession, appKey: weixinAppID, appSecret: weixinAppSecret, redirectURL: nil)
        
        //QQ
        UMSocialManager.default().setPlaform(.QQ, appKey: qqAppID, appSecret: qqAppSecret, redirectURL: nil)
        
        //微博
        UMSocialManager.default().setPlaform(.sina, appKey: "3921700954", appSecret: "04b48b094faeb16683c32669824ebdad", redirectURL: "https://sns.whalecloud.com/sina2/callback")
    }
    
    // MARK: - 分享回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }

}
