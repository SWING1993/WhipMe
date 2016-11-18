//
//  HistoricalReviewCollectionCell.swift
//  WhipMe
//
//  Created by anve on 16/11/17.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class HistoricalReviewCollectionCell: UICollectionViewCell {
    
    open var imageIcon: UIImageView!
    open var lblCount: UILabel!
    open var btnLike: UIButton!
    open var btnMessage: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellHeight() -> CGFloat {
        return 110.0 + 34.0
    }
    
    func setup() {
        
        imageIcon = UIImageView.init()
        imageIcon.backgroundColor = UIColor.gray
        imageIcon.contentMode = UIViewContentMode.scaleAspectFill
        imageIcon.clipsToBounds = true
        self.contentView.addSubview(imageIcon)
        imageIcon.snp.updateConstraints { (make) in
            make.left.top.width.equalTo(self.contentView)
            make.height.equalTo(110.0)
        }
        
        let viewBottom = UIView.init()
        viewBottom.backgroundColor = UIColor.white
        self.contentView.addSubview(viewBottom)
        viewBottom.snp.updateConstraints { (make) in
            make.left.width.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
            make.height.equalTo(34.0)
        }
        
        lblCount = UILabel.init()
        lblCount.backgroundColor = UIColor.clear
        lblCount.textColor = kColorBlack
        lblCount.font = UIFont.systemFont(ofSize: 11.0)
        lblCount.textAlignment = NSTextAlignment.left
        lblCount.text = "4次"
        viewBottom.addSubview(lblCount)
        lblCount.snp.updateConstraints { (make) in
            make.left.equalTo(self.imageIcon.snp.left).offset(12.0)
            make.top.equalTo(0)
            make.right.equalTo(self.imageIcon.snp.right).offset(-12.0)
            make.height.equalTo(34.0)
        }
        
        btnMessage = UIButton.init(type: UIButtonType.custom)
        btnMessage.backgroundColor = UIColor.clear
        btnMessage.titleLabel?.font = lblCount.font
        btnMessage.setImage(UIImage.init(named: "comment_icon_off"), for: UIControlState.normal)
        btnMessage.setTitleColor(lblCount.textColor, for: UIControlState.normal)
        btnMessage.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 0)
        btnMessage.isUserInteractionEnabled = false
        btnMessage.setTitle("0", for: UIControlState.normal)
        viewBottom.addSubview(btnMessage)
        btnMessage.snp.updateConstraints { (make) in
            make.right.equalTo(self.imageIcon.snp.right).offset(-12.0)
            make.top.equalTo(self.lblCount.snp.top)
            make.height.equalTo(self.lblCount.snp.height)
            make.width.equalTo(30.0)
        }
        
        btnLike = UIButton.init(type: UIButtonType.custom)
        btnLike.backgroundColor = UIColor.clear
        btnLike.titleLabel?.font = lblCount.font
        btnLike.setImage(UIImage.init(named: "zan_icon_off"), for: UIControlState.normal)
        btnLike.setTitleColor(lblCount.textColor, for: UIControlState.normal)
        btnLike.titleEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, 0)
        btnLike.isUserInteractionEnabled = false
        btnLike.setTitle("0", for: UIControlState.normal)
        viewBottom.addSubview(btnLike)
        btnLike.snp.updateConstraints { (make) in
            make.right.equalTo(self.btnMessage.snp.left).offset(-18.0)
            make.top.equalTo(self.btnMessage.snp.top)
            make.height.equalTo(self.btnMessage.snp.height)
            make.width.equalTo(30.0)
        }
    }
    
    func setCount(title: String) {
        lblCount.text = title
    }
    
    func setLike(title: String) {
        btnLike.setTitle(title, for: UIControlState.normal)
        
        let str_title = title as NSString
        let size_w = str_title.size(attributes: [NSFontAttributeName:self.lblCount.font])
        btnLike.snp.updateConstraints { (make) in
            make.width.equalTo(max(30.0, floor(size_w.width)+20.0))
        }
    }
    
    func setMessage(title: String) {
        btnMessage.setTitle(title, for: UIControlState.normal)
        
        let str_title = title as NSString
        let size_w = str_title.size(attributes: [NSFontAttributeName:self.lblCount.font])
        btnMessage.snp.updateConstraints { (make) in
            make.width.equalTo(max(30.0, floor(size_w.width)+20.0))
        }
    }
}
