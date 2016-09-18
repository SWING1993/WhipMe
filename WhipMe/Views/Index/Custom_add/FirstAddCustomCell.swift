//
//  FirstAddCustomCell.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class FirstAddCustomCell: UITableViewCell {
    var bgView : UIView!
    var titleT : UITextField!
    var contentT : UIPlaceHolderTextView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        self.selectionStyle = .none
        
        if bgView == nil {
            bgView = UIView.init()
            bgView.backgroundColor = UIColor.white
            bgView.layer.cornerRadius = 5.0
            bgView.layer.masksToBounds = true
            self.addSubview(bgView)
            bgView.snp.makeConstraints { (make) in
                make.top.equalTo(9)
                make.bottom.equalTo(0)
                make.left.equalTo(9)
                make.right.equalTo(-9)
            }
        }
        if titleT == nil {
            titleT = UITextField.init()
            titleT.textColor = KColorBlack
            titleT.font = UIFont.systemFont(ofSize: 12)
            titleT.placeholder = "请输入鞭挞名称"
            bgView.addSubview(titleT)
            titleT.snp.makeConstraints({ (make) in
                make.height.equalTo(45)
                make.left.equalTo(21)
                make.right.equalTo(-21)
                make.top.equalTo(5)
            })
        }
        
        let line = UIView.init()
        line.backgroundColor = UIColor.random()
        bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(titleT.snp.bottom)
            make.height.equalTo(0.5)
        }

        
        if contentT == nil {
            contentT = UIPlaceHolderTextView.init()
            contentT.font = UIFont.systemFont(ofSize: 10)
            contentT.placeholder = "请详细描述您的鞭挞计划"
            bgView.addSubview(contentT)
            contentT.snp.makeConstraints({ (make) in
                make.height.equalTo(155)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(titleT.snp.bottom).offset(1)
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
        return 210
    }
    
    class func cellReuseIdentifier() -> String {
        return "FirstAddCustomCell"
    }
    

}
