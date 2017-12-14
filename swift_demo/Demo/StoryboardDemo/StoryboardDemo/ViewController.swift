//
//  ViewController.swift
//  StoryboardDemo
//
//  Created by TW on 2017/12/8.
//  Copyright © 2017年 TW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageview: UIView! {
        didSet{
            imageview.layer.borderColor = UIColor.red.cgColor
            imageview.layer.borderWidth = 1.0
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

