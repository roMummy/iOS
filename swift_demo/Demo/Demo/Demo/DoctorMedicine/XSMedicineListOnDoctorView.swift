//
//  XSMedicineListOnDoctorView.swift
//  Demo
//
//  Created by ZQ on 2020/5/28.
//  Copyright © 2020 xieshou. All rights reserved.
//

import UIKit

class XSMedicineListOnDoctorView: UIViewController {

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 200, height: 100)
    let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collection.isScrollEnabled = false
    collection.dataSource = self
    collection.delegate = self
    collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    return collection
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
}
extension XSMedicineListOnDoctorView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    cell.contentView.backgroundColor = .cyan
    return cell
  }
  
  
}

extension XSMedicineListOnDoctorView: UICollectionViewDelegate {
  
}
