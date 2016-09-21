//
//  HotAddCell.swift
//  WhipMe
//
//  Created by Song on 16/9/19.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class HotAddCell: UITableViewCell {

    var bgView : UIView!
    var cellImage : UIImageView!
    var titleT : UILabel!
    
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
        self.backgroundColor = KColorBackGround
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
                make.right.equalTo(-kRightMargin)
            }
        }
        
        if cellImage == nil {
            cellImage = UIImageView.init()
            self.addSubview(cellImage)
            cellImage.snp.makeConstraints({ (make) in
                make.height.width.equalTo(25)
                make.centerY.equalTo(bgView)
                make.left.equalTo(15)
            })
        }
        
        if titleT == nil {
            titleT = UILabel.init()
            titleT.textColor = KColorBlack
            titleT.font = UIFont.systemFont(ofSize: 12)
            bgView.addSubview(titleT)
            titleT.snp.makeConstraints({ (make) in
                make.height.equalTo(50)
                make.left.equalTo(cellImage.snp.right).offset(10)
                make.width.equalTo(60)
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
