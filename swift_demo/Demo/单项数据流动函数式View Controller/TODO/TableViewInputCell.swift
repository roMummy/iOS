//
//  TableViewInputCell.swift
//  TODO
//
//  Created by Max on 17/8/4.
//  Copyright © 2017年 lml. All rights reserved.
//

import UIKit

protocol TableViewInputCellDelegate: class{
    func inputChanged(cell: TableViewInputCell, text: String)
}

class TableViewInputCell: UITableViewCell {

    weak var delegate:TableViewInputCellDelegate?
    
    lazy var textField:UITextField = {
        let textField = UITextField(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 50))
        textField.placeholder = "Adding a new item"
        textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        return textField
    }()
    
  @objc func textFieldValueChanged(_ sender:UITextField) {
        delegate?.inputChanged(cell: self, text: sender.text ?? "")
    }
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
