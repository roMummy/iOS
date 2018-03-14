//
//  TWCashLoansHomeTableViewCell.swift
//  SellSignName
//
//  Created by Max on 17/8/10.
//  Copyright © 2017年 代俊. All rights reserved.
//

import UIKit

let secondTableViewCell = "secondTableViewCell"

class TWCashLoansHomeTableViewCell: UITableViewCell {

    var titles: [String] = []
    
    var secondDataSource: [String]
    
    let footerButtonTag = 800
    let footerViewTag = 900
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        secondDataSource = []
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadingView()
        configConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initialData() {
        //初始化数据
        
        let footerView = self.tableView.viewWithTag(footerViewTag)
        footerView?.removeFromSuperview()
        
        
        self.tableView.reloadData()
        
    }
    func loadingView() {
        //加载视图
        self.contentView.addSubview(spacingView)
        self.contentView.addSubview(tableView)
    }
    func configConstraints() {
        //配置约束
        spacingView.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.top.left().right().equalTo()(self.contentView)
            make?.height.mas_equalTo()(10)
        }
        tableView.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.top.equalTo()(self.spacingView.mas_bottom)
            make?.left.right().bottom().equalTo()(self.contentView)
        }
        
    }

    //MARK: - 点击
    
    //标签按钮点击
    @objc func labelButtonClick(_ sender:UIButton) {
        print(sender.titleLabel?.text ?? "11")
    }
    
    //MARK: - lazy
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TWCashLoansSecondTableViewCell.self, forCellReuseIdentifier: secondTableViewCell)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    lazy var spacingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xf2f2f2)
        return view
    }()
    
    //header
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        //图片
        let imageView = UIImageView(image: UIImage.init(named: "xianjindai_kehu_ren"))
        view.addSubview(imageView)
        imageView.mas_makeConstraints({ (make: MASConstraintMaker?) in
            make?.centerY.equalTo()(view)
            make?.left.equalTo()(view)?.offset()(10)
            make?.size.mas_equalTo()(CGSize(width: 20, height: 20))
        })
        
        //name
        let nameLabel = UILabel()
        nameLabel.text = "张**"
        nameLabel.textColor = UIColor.rgbColorFromHex(rgb: 0x1a1a1a)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        view.addSubview(nameLabel)
        nameLabel.mas_makeConstraints({ (make: MASConstraintMaker?) in
            make?.centerY.equalTo()(view)
            make?.left.equalTo()(imageView.mas_right)?.offset()(5)
        })
        
        //type
        let typeLabel = UILabel()
        typeLabel.text = "我要处理"
        typeLabel.textColor = UIColor.rgbColorFromHex(rgb: 0x808080)
        typeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        view.addSubview(typeLabel)
        typeLabel.mas_makeConstraints({ (make: MASConstraintMaker?) in
            make?.centerY.equalTo()(view)
            make?.left.equalTo()(nameLabel.mas_right)?.offset()(15)
        })
        
        //screen type
        let screenTypeLabel = UILabel()
        screenTypeLabel.text = "待签署"
        screenTypeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        screenTypeLabel.textColor = UIColor.rgbColorFromHex(rgb: 0x808080)
        view.addSubview(screenTypeLabel)
        screenTypeLabel.mas_makeConstraints({ (make: MASConstraintMaker?) in
            make?.centerY.equalTo()(view)
            make?.right.mas_equalTo()(-8)
        })
        
        //line
        let lineView = UIView()
        lineView.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xf2f2f2)
        view.addSubview(lineView)
        lineView.mas_makeConstraints({ (make: MASConstraintMaker?) in
            make?.height.mas_equalTo()(1)
            make?.right.left().bottom().equalTo()
        })
        
        return view
    }()
    
    //footer
    
    func addFooterView() -> UIView {
        
        let view = UIView()
        view.tag = footerViewTag
        view.backgroundColor = .white
        
        //line
        let lineView = UIView()
        lineView.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xf2f2f2)
        view.addSubview(lineView)
        lineView.mas_makeConstraints({ (make: MASConstraintMaker?) in
            make?.height.mas_equalTo()(1)
            make?.right.left().top().equalTo()
        })
        
        //按钮
        for (index, text) in self.titles.reversed().enumerated() {
            let button = UIButton(type: .custom)
            button.layer.cornerRadius = 3
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.rgbColorFromHex(rgb: 0xf2f2f2).cgColor
            button.setTitle(text, for: .normal)
            button.setTitleColor(UIColor.rgbColorFromHex(rgb: 0x808080), for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            button.addTarget(self, action: #selector(labelButtonClick(_ :)), for: .touchUpInside)
            button.tag = index + self.footerButtonTag
            view.addSubview(button)
            
            button.mas_makeConstraints({ (make: MASConstraintMaker?) in
                make?.centerY.equalTo()(view)
                make?.right.mas_equalTo()(-index*70 - 10)
                make?.size.mas_equalTo()(CGSize(width: 60, height: 30))
            })
            
        }
        
        return view
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension TWCashLoansHomeTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return addFooterView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: secondTableViewCell, for: indexPath) as! TWCashLoansSecondTableViewCell
        //        cell.backgroundColor = UIColor.red
        cell.dataSource = secondDataSource[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

}
