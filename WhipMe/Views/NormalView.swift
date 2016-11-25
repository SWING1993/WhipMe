//
//  NormalView.swift
//  WhipMe
//
//  Created by Song on 2016/11/24.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class NormalView: UIView {

    let bgView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kColorBackGround
        bgView.backgroundColor = kColorWhite
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 5.0
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
