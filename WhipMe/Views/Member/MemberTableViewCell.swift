//
//  MemberTableViewCell.swift
//  WhipMe
//
//  Created by anve on 16/11/17.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation
import UIKit

class MemberTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    open var viewCurrent: UIView!
    open var lblTitle: UILabel!
    open var imageHead: UIImageView!
    open var lblTopic: UILabel!
    open var lblNumber: UILabel!
    open var lineView: UIView!
    fileprivate let kHead_WH: CGFloat = 36.0
    fileprivate let identifier_collect = "memberCollectionCell"
    open var collectionViewWM: UICollectionView!
    open var model: mySuperviseModel = mySuperviseModel();
    var indexViewCellModel: ((threeDayModel) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.backgroundColor = UIColor.clear
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        
        viewCurrent = UIView.init()
        viewCurrent.backgroundColor = UIColor.white
        self.contentView.addSubview(viewCurrent)
        viewCurrent.snp.updateConstraints { (make) in
            make.width.equalTo(self.contentView).offset(-16.0)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.height.equalTo(self.contentView)
        }
        
        imageHead = UIImageView.init()
        imageHead.backgroundColor = Define.kColorBackGround()
        imageHead.layer.cornerRadius = kHead_WH/2.0
        imageHead.layer.masksToBounds = true
        imageHead.contentMode = UIViewContentMode.scaleAspectFill
        imageHead.clipsToBounds = true
        viewCurrent.addSubview(imageHead)
        imageHead.snp.updateConstraints { (make) in
            make.left.equalTo(12.5)
            make.top.equalTo(16.0)
            make.size.equalTo(CGSize.init(width: kHead_WH, height: kHead_WH))
        }
        
        lblTitle = UILabel.init()
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.textColor = kColorBlack
        lblTitle.font = UIFont.systemFont(ofSize: 15.0)
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.text = "樱花派"
        viewCurrent.addSubview(lblTitle)
        lblTitle.snp.updateConstraints { (make) in
            make.left.equalTo(self.imageHead.snp.right).offset(14.0)
            make.top.equalTo(self.imageHead.snp.top)
            make.right.equalTo(self.viewCurrent).offset(-12.5)
            make.height.equalTo(18)
        }
        
        lblTopic = UILabel.init()
        lblTopic.backgroundColor = UIColor.clear
        lblTopic.textColor = Define.RGBColorFloat(42, g: 195, b: 130)
        lblTopic.font = UIFont.systemFont(ofSize: 11.0)
        lblTopic.textAlignment = NSTextAlignment.left
        lblTopic.text = "#早起#"
        viewCurrent.addSubview(lblTopic)
        lblTopic.snp.updateConstraints { (make) in
            make.left.equalTo(self.lblTitle.snp.left)
            make.top.equalTo(self.lblTitle.snp.bottom).offset(5.0)
            make.width.equalTo(self.lblTitle.snp.width).offset(-70.0)
            make.height.equalTo(13)
        }
        
        lblNumber = UILabel.init()
        lblNumber.backgroundColor = UIColor.clear
        lblNumber.textColor = Define.RGBColorFloat(42, g: 195, b: 130)
        lblNumber.font = UIFont.systemFont(ofSize: 11.0)
        lblNumber.textAlignment = NSTextAlignment.right
        lblNumber.text = "已鞭挞118次"
        viewCurrent.addSubview(lblNumber)
        lblNumber.snp.updateConstraints { (make) in
            make.left.equalTo(self.lblTitle.snp.left)
            make.top.equalTo(self.lblTopic.snp.top)
            make.width.equalTo(self.lblTitle.snp.width)
            make.height.equalTo(13)
        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 10.0
        
        collectionViewWM = UICollectionView.init(frame: CGRect.zero, collectionViewLayout:layout)
        collectionViewWM.backgroundColor = UIColor.clear
        collectionViewWM.dataSource = self
        collectionViewWM.delegate = self
        collectionViewWM.showsHorizontalScrollIndicator = false
        collectionViewWM.showsVerticalScrollIndicator = false
        viewCurrent.addSubview(collectionViewWM)
        collectionViewWM.snp.updateConstraints { (make) in
            make.left.equalTo(self.imageHead.snp.left)
            make.top.equalTo(self.imageHead.snp.bottom).offset(10.0)
            make.height.equalTo(108.0)
            make.width.equalTo(self.viewCurrent).offset(-25.0)
        }
        collectionViewWM.register(MemberCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: identifier_collect)
        
        lineView = UIView.init()
        lineView.backgroundColor = kColorLine
        viewCurrent.addSubview(lineView)
        lineView.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.contentView).offset(-25.0)
            make.bottom.equalTo(self.viewCurrent)
            make.height.equalTo(0.5)
        }
    }
    
    open func setData() {
        lblTitle.text = self.model.nickname
        lblNumber.text = "已鞭挞\(self.model.recordNum)次"
        lblTopic.text = "#\(self.model.themeName)#"
        
        self.collectionViewWM.reloadData();
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.model.threeDay.count == 0) {
            return 5;
        }
        return self.model.threeDay.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MemberCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier_collect, for: indexPath) as! MemberCollectionViewCell
        //        "picture":"打卡图片",
        //        "content":"打卡内容",
        //        "whichDay":"打卡日期"
        if (self.model.threeDay.count > indexPath.row) {
            let obj: threeDayModel = threeDayModel.mj_object(withKeyValues: self.model.threeDay[indexPath.row])
            cell.imageIcon.setImageWith(NSURL.init(string: obj.picture) as! URL, placeholderImage: Define.kDefaultPlaceImage())
        } else {
            cell.imageIcon.image = Define.kDefaultPlaceImage()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
        if (self.model.threeDay.count > indexPath.row) {
            let obj: threeDayModel = threeDayModel.mj_object(withKeyValues: self.model.threeDay[indexPath.row])
            if (self.indexViewCellModel != nil) {
                self.indexViewCellModel!(obj);
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 108.0, height: 108.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
