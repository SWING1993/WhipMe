//
//  HotAddCell.swift
//  WhipMe
//
//  Created by Song on 16/9/19.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class HotAddCell: NormalCell {

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
    
        self.backgroundColor = kColorBackGround
        self.selectionStyle = .none
        
        if cellImage == nil {
            cellImage = UIImageView.init()
//            cellImage.image = UIImage.init(named: "zaoqi")
            self.bgView.addSubview(cellImage)
            cellImage.snp.makeConstraints({ (make) in
                make.height.width.equalTo(20)
                make.centerY.equalTo(self.bgView)
                make.left.equalTo(20)
            })
        }
        
        if titleL == nil {
            titleL = UILabel.init()
            titleL.textColor = kColorBlack
            titleL.font = UIFont.systemFont(ofSize: 16)
            self.bgView.addSubview(titleL)
            titleL.snp.makeConstraints({ (make) in
                make.height.equalTo(50)
                make.left.equalTo(cellImage.snp.right).offset(20)
                make.width.equalTo(100)
                make.centerY.equalTo(self.bgView)
            })
        }
        
        if subTitleL == nil {
            subTitleL = UILabel.init()
            subTitleL.textColor = kColorGray
//            subTitleL.text = "已有10086位参加"
            subTitleL.textAlignment = .right
            subTitleL.font = UIFont.systemFont(ofSize: 10)
            self.bgView.addSubview(subTitleL)
            subTitleL.snp.makeConstraints({ (make) in
                make.height.equalTo(50)
                make.right.equalTo(-15)
                make.width.equalTo(100)
                make.centerY.equalTo(self.bgView)
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
