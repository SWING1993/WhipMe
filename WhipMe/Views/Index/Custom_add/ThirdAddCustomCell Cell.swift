//
//  ThirdAddCustomCell Cell.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class ThirdAddCustomCell: NormalCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        let titleLabel = UILabel.init()
        titleLabel.text = "找监护人"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.height.equalTo(30)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(5)
        })
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
            
            let titleLabel = UILabel.init()
            titleLabel.text = "找监护人"
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            bgView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ (make) in
                make.height.equalTo(30)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(5)
            })
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellHeight() -> CGFloat {
        return 176
    }
    
    class func cellReuseIdentifier() -> String {
        return "ThirdAddCustomCell"
    }

}
