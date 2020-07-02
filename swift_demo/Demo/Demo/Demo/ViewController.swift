//
//  ViewController.swift
//  Demo
//
//  Created by ZQ on 2020/5/18.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .cyan
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var textView: UITextView = {
    let text = UITextView(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
    return text
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = .systemPink
//    view.addSubview(contentView)
//    systemConstraint()
    
    view.addSubview(textView)
    atribute()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let vc = BestMedicineListViewController()
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func atribute() {
    let text = NSMutableAttributedString.init(string: "hello")

    let range = NSMakeRange(0, text.length)
    // add large fonts
    text.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.red, range: range)
    text.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
    text.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 72), range: range)


    // add underline
    text.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value:  NSUnderlineStyle.double.rawValue), range: range)
    text.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.green, range: range)

    textView.attributedText = text
  }
  
  // 使用系统自带的约束
  func systemConstraint() {
    let constraint = [
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
    ]
    NSLayoutConstraint.activate(constraint)
    
  }
  
}

