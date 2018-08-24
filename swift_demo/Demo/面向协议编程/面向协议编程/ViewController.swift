//
//  ViewController.swift
//  面向协议编程
//
//  Created by TW on 2017/12/11.
//  Copyright © 2017年 TW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLSessionClient().send(UserRequest(name: "one")) { (user) in
            if let user = user {
                print(user.name+user.message)
            }
        }
        URLSessionClient().send(UserRequest(name: "123")) { (user) in
            if let user = user {
                user.name
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

