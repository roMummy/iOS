//
//  TestViewController.swift
//  Test
//
//  Created by TW on 2018/1/18.
//  Copyright © 2018年 lml. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        let button = UIButton()
        button.addTarget(self, action: #selector(loan(_ :)), for: .touchUpInside)
        self.view.addSubview(button)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc
    func loan(_ sender: Any) {
        
    }
    
}
extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell click")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.cyan
        return cell
    }
}
