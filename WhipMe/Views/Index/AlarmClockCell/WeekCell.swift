//
//  WeekCell.swift
//  WhipMe
//
//  Created by Song on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {

    var bgView : UIView!
    let kBtnWidth = (Define.screenWidth() - 2*kMargin)/7
    let tagItems = [7 ,1 ,2 ,3, 4, 5, 6]
    let btnTitles = ["七", "一", "二", "三", "四", "五", "六"]
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
                make.top.left.equalTo(kMargin)
                make.right.bottom.equalTo(-kMargin)
            }
        }
        
        for (index,btnTag) in tagItems.enumerated() {
            let weekBtn = UIButton.init(type: .custom)
            weekBtn.backgroundColor = UIColor.random()
            weekBtn.tag = btnTag
            weekBtn.setTitle(btnTitles[index], for: .normal)
            weekBtn.frame = CGRect.init(x: (CGFloat(index) * kBtnWidth), y: 0, width: kBtnWidth, height: 50)
            bgView.addSubview(weekBtn)
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
        return 58
    }
    
    class func cellReuseIdentifier() -> String {
        return "WeekCell"
    }


}
