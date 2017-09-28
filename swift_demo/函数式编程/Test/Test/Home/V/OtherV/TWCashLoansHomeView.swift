//
//  TWCashLoansHomeView.swift
//  SellSignName
//
//  Created by Max on 17/8/11.
//  Copyright © 2017年 代俊. All rights reserved.
//

import UIKit

protocol TWCashLoansHomeViewDelegate : class {
    
    func changeControllerState(_ state: Int)
    func screenClick()
    func locationButtonClick(_ sender: UIButton)
    func textFieldEditChanged(_ sender: UITextField)
}

class TWCashLoansHomeView: NSObject {

    weak var delegate: TWCashLoansHomeViewController?
    var dataSource: [String] = []
    var titles: [String] = []
    
    var type: CashLoansType = .customer
    
    var state: State
    
    init(owner: TWCashLoansHomeViewController?, state: State) {
        self.delegate = owner
        self.state = state
        super.init()
//        self.delegate?.tableView.dataSource = self
    }
    
    //组装视图
    public func packageAllView() {
        loadingView()
        configConstraints()
    }
    
    func loadingView() {
        //加载视图
        self.delegate?.navigationItem.rightBarButtonItem = rightBarButton
        self.delegate?.navigationItem.titleView = segmented
        self.delegate?.view.addSubview(tableView)
    }
    func configConstraints() {
        //配置约束
     tableView.mas_makeConstraints { (make:MASConstraintMaker?) in
        
        make?.left.top().right().bottom().equalTo()(self.delegate?.view)
        
        }
        
    }
    
    //MARK: - click
    
    //点击筛选
    func screenClick() {
        
        guard (self.delegate != nil) else {
            return
        }
        self.delegate?.screenClick()
    }
    
    //切换控制器
    func segmentedControlClick(_ sender: UISegmentedControl) {
//        print(sender.selectedSegmentIndex)
        guard (self.delegate != nil) else {
            return
        }
        self.delegate?.changeControllerState(sender.selectedSegmentIndex)
    }
    
    //定位点击
    func locationButtonClick(_ sender: UIButton) {
//        print("定位")
        guard (self.delegate != nil) else {
            return
        }
        self.delegate?.locationButtonClick(sender)
    }
    
    //搜索值改变
    func textFieldEditChanged(_ sender: UITextField) {
        
//        print(sender.text ?? "12")
        guard (self.delegate != nil) else {
            return
        }
        self.delegate?.textFieldEditChanged(sender)
        
    }
    //MARK: - lazy
    
    //导航栏右边按钮
    lazy var rightBarButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        //        button.backgroundColor = .blue
        button.setTitle("未标记", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage(named: "jiantou")?.redrawColor(.white), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        button.addTarget(self, action: #selector(screenClick), for: .touchUpInside)
        button.tag = screenTag
        
        let rightBarButton = UIBarButtonItem(customView: button)
        return rightBarButton
    }()
    
    //UISegmentedControl
    lazy var segmented: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["可获取","待分配"])
        segmented.frame = CGRect(x: 0, y: 0, width: 150, height: 25)
        segmented.selectedSegmentIndex = 0
        segmented.layer.cornerRadius = segmented.bounds.size.height / 2.0
        segmented.layer.masksToBounds = true
        segmented.layer.borderColor = UIColor.white.cgColor
        segmented.layer.borderWidth = 1.0
        segmented.addTarget(self, action: #selector(segmentedControlClick(_:)), for: .valueChanged)
        return segmented
    }()
    
    //tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: 375, height: 667), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TWCashLoansHomeTableViewCell.self, forCellReuseIdentifier: tableViewCell)
        tableView.separatorStyle = .none
//        tableView.backgroundColor = .yellow
        return tableView
    }()
    
    //定位
    lazy var locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //定位城市
        let button = UIButton(type: .custom)
//        button.backgroundColor = .blue
        button.setTitle("成都市", for: .normal)
        button.setTitleColor(UIColor.rgbColorFromHex(rgb: 0x808080), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage(named: "jiantou"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        button.addTarget(self, action: #selector(locationButtonClick(_ :)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        view.addSubview(button)
        
        button.mas_makeConstraints({ (make: MASConstraintMaker?) in
            make?.centerY.equalTo()
            make?.left.mas_equalTo()(10)
            make?.size.mas_equalTo()(CGSize(width: 60, height: 30))
        })
        
        //搜索
        let searchTF = self.addSearchTF()
        view.addSubview(searchTF)
        searchTF.mas_makeConstraints({ (make: MASConstraintMaker?) in
//            make?.centerY.equalTo()
//            make?.edges.mas_equalTo()(UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 5))
            make?.left.equalTo()(button.mas_right)?.offset()(5)
            
            make?.right.mas_equalTo()(-5)
            make?.top.mas_equalTo()(5)
            make?.bottom.mas_equalTo()(-5)
        })
        
        return view
    }()
    
    //搜索
    lazy var searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
        
        let searchTF = self.addSearchTF()
        
        searchView.addSubview(searchTF)
        searchTF.mas_makeConstraints({ (make: MASConstraintMaker?) in
            //            make?.centerY.equalTo()(searchView)
            make?.edges.mas_equalTo()(UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 25))
        })
        
        return searchView
    }()
    
    //textField
    func addSearchTF() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "请输入客户姓名"
        textField.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xf2f2f2)
        textField.font = UIFont.boldSystemFont(ofSize: 14)
        textField.clearButtonMode = .whileEditing
        //        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditChanged(_ :)), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        
        //图片
        let imageView = UIImageView.init(image: UIImage.init(named: "search_whiteSpace"))
        imageView.frame =  CGRect(x: 5, y: 0, width: 15, height: 15)
        
        //view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        view.addSubview(imageView)
        textField.leftView = view
        textField.leftViewMode = .always
        return textField
    }
}

extension TWCashLoansHomeView: UITableViewDataSource, UITableViewDelegate {
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0 + CGFloat(state.dataSource.count * 35)
    }
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch state.type {
        case .customer, .waitDistribution:
            locationView.isHidden = true
            searchView.isHidden = false
            return searchView
        case .retrievable:
            locationView.isHidden = false
            searchView.isHidden = true
            return locationView
        default:
            locationView.isHidden = true
            searchView.isHidden = false
            return searchView
        }
    }
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001 //避免视图尾部出现空白
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCell, for: indexPath) as! TWCashLoansHomeTableViewCell
        cell.backgroundColor = UIColor.orange
        cell.selectionStyle = .none
        cell.secondDataSource = state.dataSource
        cell.titles = state.footerData
        cell.initialData()
        return cell
    }

}
