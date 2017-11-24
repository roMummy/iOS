//
//  ViewController.swift
//  share
//
//  Created by TW on 2017/11/20.
//  Copyright © 2017年 TW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func share(_ sender: Any) {
        UMSocialUIManager.addCustomPlatformWithoutFilted(UMSocialPlatformType(rawValue: UMSocialPlatformType.userDefine_Begin.rawValue+1)!, withPlatformIcon: #imageLiteral(resourceName: "share_icon"), withPlatformName: "复制")
       
        UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.wechatSession.rawValue, UMSocialPlatformType.wechatTimeLine.rawValue,UMSocialPlatformType.QQ.rawValue,UMSocialPlatformType.qzone.rawValue,UMSocialPlatformType.sina.rawValue,UMSocialPlatformType.userDefine_Begin.rawValue + 1])
        
        UMSocialUIManager.showShareMenuViewInWindow { (type, dic) in
            switch type {
            case UMSocialPlatformType.QQ,UMSocialPlatformType.sina:
                break
            case UMSocialPlatformType(rawValue: 1000+1)!:
                let activityVC = UIActivityViewController.init(activityItems: [NSURL.init(string:"www.baidu.com")!,#imageLiteral(resourceName: "share_icon"),"标题"], applicationActivities: nil)
                //设置不出现的项目
                activityVC.excludedActivityTypes = [.airDrop]
                self.present(activityVC, animated: true, completion: {
                    //分享回调
                    
                })
                
                break
            default:
                break
            }
            let messageObject = UMSocialMessageObject()
            let shareObject = UMShareWebpageObject.shareObject(withTitle: "分享", descr: "13123", thumImage: nil)
            shareObject?.webpageUrl = "www.baidu.com"
            messageObject.shareObject = shareObject
            
            //调用分享接口
            UMSocialManager.default().share(to: type, messageObject: messageObject, currentViewController: self, completion: { (data, error) in
                if (error != nil) {
                    print(error)
                }else {
                    print(data)
                }
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

