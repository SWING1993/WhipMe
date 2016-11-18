//
//  HistoricalReviewController.swift
//  WhipMe
//
//  Created by anve on 16/11/17.
//  Copyright © 2016年 -. All rights reserved.
//  历史回顾

import UIKit

class HistoricalReviewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    fileprivate var collectionViewWM: UICollectionView!
    fileprivate var identifier_collect: String = "historicalReviewCell"
    fileprivate var kSize_w: CGFloat = (Define.screenWidth() - 32.0)/2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "历史回顾"
        self.view.backgroundColor = kColorBackGround

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 5
        
        collectionViewWM = UICollectionView.init(frame: CGRect.zero, collectionViewLayout:layout)
        collectionViewWM.backgroundColor = UIColor.clear
        collectionViewWM.dataSource = self
        collectionViewWM.delegate = self
        collectionViewWM.showsHorizontalScrollIndicator = false
        collectionViewWM.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionViewWM)
        collectionViewWM.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        collectionViewWM.register(HistoricalReviewCollectionCell.classForCoder(), forCellWithReuseIdentifier: identifier_collect)
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HistoricalReviewCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier_collect, for: indexPath) as! HistoricalReviewCollectionCell
        
        cell.setCount(title: "4")
        cell.setLike(title: "64")
        cell.setMessage(title: "54")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
        //        if (self.delegate && [self.delegate respondsToSelector:@selector(indexViewCell:detailModel:)]) {
        //            [self.delegate indexViewCell:self detailModel:self.arrayContent[indexPath.row]];
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: kSize_w, height: HistoricalReviewCollectionCell.cellHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 13, 10, 13);
    }
    
}
