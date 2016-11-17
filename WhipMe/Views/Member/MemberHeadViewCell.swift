//
//  MemberHeadViewCell.swift
//  WhipMe
//
//  Created by anve on 16/11/17.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation
import UIKit

class MemberHeadViewCell: UITableViewCell {
    
    open var btnTitle: UIButton!
    
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
    
    class func cellHeight() -> CGFloat {
        return 45.0 + 14.0
    }
    
    func setup() {
        
        btnTitle = UIButton.init(type: UIButtonType.custom)
        btnTitle.backgroundColor = UIColor.white
        btnTitle.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btnTitle.setTitleColor(kColorBlack, for: UIControlState.normal)
        btnTitle.isUserInteractionEnabled = false
        self.contentView.addSubview(btnTitle)
        btnTitle.snp.updateConstraints { (make) in
            make.width.equalTo(self.contentView).offset(-16.0)
            make.height.equalTo(45.0)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(14.0)
        }
        
        let line_grow = UIView.init()
        line_grow.backgroundColor = kColorLine
        btnTitle.addSubview(line_grow)
        line_grow.snp.updateConstraints { (make) in
            make.left.equalTo(self.btnTitle)
            make.width.equalTo(self.btnTitle)
            make.bottom.equalTo(self.btnTitle)
            make.height.equalTo(0.5)
        }
    }
    
    func setTitle(title: String) {
        btnTitle.setTitle(title, for: UIControlState.normal)
    }
}
