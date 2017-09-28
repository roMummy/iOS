//
//  TWCashLoansSecondTableViewCell.swift
//  SellSignName
//
//  Created by Max on 17/8/11.
//  Copyright © 2017年 代俊. All rights reserved.
//

import UIKit

class TWCashLoansSecondTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        dataSource = "合同编号"
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialData()
        loadingView()
        configConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataSource: String {
        didSet {
            
            if dataSource.characters.count == 2 {
                for _ in 0..<8 {
                    dataSource.insert(" ", at: dataSource.index(before: dataSource.endIndex))
                }
            }
            nameTextLabel.text = dataSource + ":"
        }
    }
    
    func initialData() {
        //初始化数据
    }
    func loadingView() {
        //加载视图
        self.contentView.addSubview(nameTextLabel)
        self.contentView.addSubview(contentTextLabel)
    }
    func configConstraints() {
        //配置约束
        nameTextLabel.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(12)
            make?.centerY.equalTo()
        }
        contentTextLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.nameTextLabel.mas_right)?.offset()(16)
            make?.centerY.equalTo()
        }
    }
    
    
    //MARK: - lazy
    lazy var nameTextLabel: UILabel = {
        let label = UILabel()
        label.text = "合同编号:"
        label.textColor = UIColor.rgbColorFromHex(rgb: 0x808080)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    lazy var contentTextLabel: UILabel = {
        let label = UILabel()
        label.text = "12321312312321"
        label.textColor = UIColor.rgbColorFromHex(rgb: 0x808080)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
