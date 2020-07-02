//
//  XSDoctorMedicineViewController.swift
//  XSFamilySignUserClient
//
//  Created by ZQ on 2020/5/28.
//  Copyright © 2020 com.xieshou. All rights reserved.
//

import UIKit

let WIDTH: Int = Int(UIScreen.main.bounds.size.width)
let HEAD_HEIGHT = 215
let SWITCH_HEIGHT = 55
class XSMedicineListViewController: UIViewController {
  
  lazy var scrollView:UIScrollView = {
    let scroll = UIScrollView(frame: CGRect.zero)
    scroll.backgroundColor = .yellow
    scroll.automaticallyAdjustsScrollIndicatorInsets = false
    return scroll
  }()
  
  lazy var leftView: XSMedicineListOnDoctorView = {
    let vc = XSMedicineListOnDoctorView()
    vc.view.frame = CGRect(x: 0, y: HEAD_HEIGHT+SWITCH_HEIGHT+88, width: WIDTH, height: 500)
    vc.view.backgroundColor = .red
    return vc
  }()
  
  lazy var rightView: XSMedicineListOnMoreView = {
    let vc = XSMedicineListOnMoreView()
    vc.view.frame = CGRect(x: WIDTH, y: HEAD_HEIGHT+SWITCH_HEIGHT+88, width: WIDTH, height: 500)
    vc.view.backgroundColor = .blue
    return vc
  }()
  
  lazy var headerView: UIView = {
    let view = UIView(frame: CGRect(x:0, y: 88, width: WIDTH, height: HEAD_HEIGHT))
    view.backgroundColor = .green
    return view
  }()
  
  lazy var switchView: XSMedicineListSwitchView = {
    let view = XSMedicineListSwitchView(frame: CGRect(x: 0, y: HEAD_HEIGHT + 88, width: WIDTH, height: SWITCH_HEIGHT))
    view.delegate = self
    view.backgroundColor = .orange
    return view
  }()
  
  private var dataSource: [Int]? {
    willSet {
      let height = (newValue?.count ?? 0) * 100
      scrollView.contentSize = CGSize(width: WIDTH, height: height)
      scrollView.setContentOffset(CGPoint(x: WIDTH, y: 0), animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "医生药柜"
    
    setupUI()
    addNC()
    dataSource = [1]
  }
  
  func setupUI(){
    view.addSubview(scrollView)
    view.addSubview(headerView)
    view.addSubview(switchView)
    
    scrollView.addSubview(leftView.view)
    scrollView.addSubview(rightView.view)
    
    scrollView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(view)
      make.left.equalTo(view)
      make.width.equalTo(WIDTH * 2)
    }
  }
  
    
  func switchPage(by index: Int) {
    scrollView.setContentOffset(CGPoint(x: index * WIDTH, y: 0), animated: true)
  }
  
  @objc
  func morePageSwitch(not: Notification) {
    print(not)
    if let index = not.userInfo?["index"] as? Int {
      print("-----\(index)")
      setData(type: index)
    }
    //    tableView.reloadData()
  }
  
  func setData(type: Int) {
    switch type {
    case 0:
      dataSource = [1,2,3,4,5]
    case 1:
      dataSource = [1,2,3,4,5,6,7,8,9]
    case 2:
      dataSource = [1]
    default:
      dataSource = []
    }
  }
}

extension XSMedicineListViewController: XSMedicineListSwitchViewDelegate {
  func onClickLeft() {
    switchPage(by: 0)
  }
  func onClickRight() {
    switchPage(by: 1)
  }
}

extension XSMedicineListViewController {
  func addNC() {
    NotificationCenter.default.addObserver(self, selector: #selector(morePageSwitch(not:)), name: NSNotification.Name(ZNPageView.switchNotificationName), object: nil)
  }
}
