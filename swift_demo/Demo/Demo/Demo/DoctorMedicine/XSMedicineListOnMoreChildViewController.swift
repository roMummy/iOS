//
//  XSMedicineListOnMoreChildViewController.swift
//  Demo
//
//  Created by ZQ on 2020/5/29.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit

class XSMedicineListOnMoreChildViewController: UIViewController {
  

  lazy var collectionView:UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 200, height: 100)
    let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    
    collection.delegate = self
    collection.dataSource = self
    collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    return collection
  }()
  private var type_: Int = 0
  private var dataSource: [Int]?
  
  init(type: Int) {
    super.init(nibName: nil, bundle: nil)
    type_ = type
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    setupUI()
    data()
  }
  
  func setupUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  func data() {
    switch type_ {
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
  
extension XSMedicineListOnMoreChildViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    cell.contentView.backgroundColor = .darkGray    
    return cell
  }
  
  
}

extension XSMedicineListOnMoreChildViewController: UICollectionViewDelegate {
  
}
