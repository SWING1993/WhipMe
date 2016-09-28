//
//  HotAddCell.swift
//  WhipMe
//
//  Created by Song on 16/9/19.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class HotAddCell: UITableViewCell {

    fileprivate var bgView : UIView!
    var cellImage : UIImageView!
    var titleL : UILabel!
    var subTitleL : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Define.kColorBackGround()
        self.selectionStyle = .none
        
        if bgView == nil {
            bgView = UIView.init()
            bgView.backgroundColor = UIColor.white
            bgView.layer.cornerRadius = 5.0
            bgView.layer.masksToBounds = true
            self.addSubview(bgView)
            bgView.snp.makeConstraints { (make) in
                make.top.equalTo(kTopMargin)
                make.bottom.equalTo(kBottomMargin)
                make.left.equalTo(kLeftMargin)
                make.right.equalTo(kRightMargin)
            }
        }
        
        if cellImage == nil {
            
            cellImage = UIImageView.init()
            cellImage.image = UIImage.init(named: "zaoqi")
            self.addSubview(cellImage)
            cellImage.snp.makeConstraints({ (make) in
                make.height.width.equalTo(20)
                make.centerY.equalTo(bgView)
                make.left.equalTo(20)
            })
        }
        
        if titleL == nil {
            titleL = UILabel.init()
            titleL.textColor = Define.kColorBlack()
            titleL.text = "早起"
            titleL.font = UIFont.systemFont(ofSize: 16)
            bgView.addSubview(titleL)
            titleL.snp.makeConstraints({ (make) in
                make.height.equalTo(50)
                make.left.equalTo(cellImage.snp.right).offset(20)
                make.width.equalTo(100)
                make.centerY.equalTo(bgView)
            })
        }
        
        if subTitleL == nil {
            subTitleL = UILabel.init()
            subTitleL.textColor = Define.kColorGray()
            subTitleL.text = "已有10086位参加"
            subTitleL.textAlignment = .right
            subTitleL.font = UIFont.systemFont(ofSize: 8)
            bgView.addSubview(subTitleL)
            subTitleL.snp.makeConstraints({ (make) in
                make.height.equalTo(50)
                make.right.equalTo(-15)
                make.width.equalTo(100)
                make.centerY.equalTo(bgView)
            })
        }

     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellHeight() -> CGFloat {
        return 58
    }
    
    class func cellReuseIdentifier() -> String {
        return "HotAddCell"
    }
}
