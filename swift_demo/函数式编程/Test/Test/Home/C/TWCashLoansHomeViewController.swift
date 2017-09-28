//
//  TWCashLoansHomeViewController.swift
//  SellSignName
//
//  Created by Max on 17/8/10.
//  Copyright © 2017年 代俊. All rights reserved.
//

import UIKit


let screenTag = 700
let tableViewCell = "tableViewCell"

enum CashLoansType: Int {
    case customer = 0, retrievable, waitDistribution
}

struct State {
    var screen: [String]
    var dataSource: [String]
    var footerData: [String]
    var type: CashLoansType
    
}

class TWCashLoansHomeViewController: UIViewController {
    
    
    
    let cellDataSource = ["合同编号", "贷款金额", "期数", "剩余天数", "地址"]
    let titles: [String] = ["退回", "标记", "联系ta"]
    
    var homeViews: TWCashLoansHomeView?
    
    var state = State(screen: [], dataSource: [], footerData: [], type: .customer)
    
    var type: CashLoansType = .customer{
        willSet {
            let cellDataSource = ["合同编号", "贷款金额", "期数", "剩余天数", "地址"]
            let titles: [String]
            switch newValue {
            case .customer:
                titles = ["退回", "标记", "联系ta"]
            case .retrievable:
                titles = ["退回", "获取"]
                
            case .waitDistribution:
                titles = ["退回", "分派"]
            default:
                titles = ["退回", "标记", "联系ta"]
            }
            state = State(screen: [], dataSource: cellDataSource, footerData: titles, type: newValue)
            homeViews?.state = state
            homeViews?.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let lview:TWCashLoansHomeView? = NSClassFromString("TWCashLoansHomeView") as? TWCashLoansHomeView
//        print("self---\(self)\nlview-------\(lview ?? self)")
        self.type = .customer
        let views = TWCashLoansHomeView(owner: self, state: self.state)
        homeViews = views
        views.packageAllView()
        
    }
    
    public func initialData(_ type: Int) {
        //初始化数据
        
        guard let value = CashLoansType(rawValue: type) else {
            return
        }
        self.type = value
        self.view.backgroundColor = .red
        
        //        self.title = "现金贷"
    }
    func loadingView() {
        //加载视图
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TWCashLoansHomeViewController: TWCashLoansHomeViewDelegate {

    func changeControllerState(_ state: Int) {
        switch state {
        case 0:
            //可获取
            self.type = .retrievable
            break
        case 1:
            //待分配
            self.type = .waitDistribution
            break
        default:
            break
        }
    }
    func screenClick() {
        print("筛选")
        let backView = TWCashLoansBackView()
        UIApplication.shared.keyWindow?.addSubview(backView)
    }
    func locationButtonClick(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "成都")
    }
    func textFieldEditChanged(_ sender: UITextField) {
        print(sender.text ?? "textField is nil")
    }
}
