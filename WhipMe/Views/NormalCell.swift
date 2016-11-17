//
//  NormalCell.swift
//  WhipMe
//
//  Created by Song on 2016/9/26.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class NormalCell: UITableViewCell {

    var bgView: UIView = UIView.init()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kColorBackGround

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
