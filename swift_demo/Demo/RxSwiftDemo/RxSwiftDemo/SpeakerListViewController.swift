//
//  SpeakerListViewController.swift
//  RxSwiftDemo
//
//  Created by TW on 2018/5/14.
//  Copyright © 2018年 TW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SpeakerListViewController: UIViewController {

    lazy var speakerListTableView: UITableView = {
        let tableview = UITableView(frame: self.view.frame, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    let speakerListViewModel = SpeakerListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //数据绑定
//        speakerListViewModel.data
//            .bind(to: speakerListTableView.rx.items(cellIdentifier: "cell", cellType: SpeakerTableViewCell.self)){ (_, _, _) in
////                cell.textLabel?.text = speaker.name
//            }.disposed(disposeBag)
        //订阅tableview点击事件
        speakerListTableView.rx.modelSelected(Speaker.self).subscribe(onNext: { (speaker) in
            print("selected \(speaker)")
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension SpeakerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
extension SpeakerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

