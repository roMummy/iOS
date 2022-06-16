//
//  ViewController.swift
//  TestAction
//
//  Created by FSKJ on 2022/6/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("App启动")
        
        
        let button = UIButton()
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
    }


    @objc
    func buttonAction() {
        let vc = UIActivityViewController(activityItems: ["1111"], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
}

