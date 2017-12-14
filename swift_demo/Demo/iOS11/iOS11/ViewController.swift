//
//  ViewController.swift
//  iOS11
//
//  Created by TW on 2017/9/26.
//  Copyright © 2017年 TW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "31312"
        self.navigationItem.title = "123123"
        self.navigationItem.largeTitleDisplayMode = .always
        //开启大标题
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

