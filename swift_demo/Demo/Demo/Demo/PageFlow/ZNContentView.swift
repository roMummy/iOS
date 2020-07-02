//
//  ZNContentView.swift
//  pageFlowView
//
//  Created by cocoboy on 2017/3/29.
//  Copyright © 2017年 zn. All rights reserved.
//

import UIKit

protocol ZNContentViewDelegate :class{
    func ZNContentView(_ contentView : ZNContentView , targetIndex : Int)
}

private let kContetnCellID = "kContetnCellID"
class ZNContentView: UIView {
    weak var delegate : ZNContentViewDelegate?
    fileprivate var isForbidScroll : Bool = false
    public var currentIndex : Int = 0
    fileprivate var childVcs : [UIViewController]
    fileprivate weak var parentVc : UIViewController?
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContetnCellID)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    
    
    }()
  init(frame: CGRect,childVcs : [UIViewController],parentVc : UIViewController?,currentIndex:Int) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.currentIndex = currentIndex;
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension ZNContentView{

    fileprivate func setupUI(){
        guard let parentVc = parentVc else {
          return
        }
        for childVc in childVcs {
          parentVc.addChild(childVc)          
        }
        addSubview(collectionView)
      let indexPath = IndexPath(item: currentIndex, section: 0)
      collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }

}
extension ZNContentView : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContetnCellID, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

extension ZNContentView : ZNTitleViewDelegate{

    func titleView(_ titleView: ZNTitleView, targetIndex: Int) {
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
    }


}



//MARK: uicollectionview的代理方法
extension ZNContentView : UICollectionViewDelegate{

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = true
        
    }
    private func contentEndScroll() {
        guard isForbidScroll else {
            return
        }
        let currentIndex = Int(collectionView.contentOffset.x/collectionView.bounds.width)

        delegate?.ZNContentView(self, targetIndex: currentIndex)
        NotificationCenter.default.post(name: NSNotification.Name(ZNPageView.switchNotificationName), object: nil, userInfo: ["index":currentIndex])
    }
}



