//
//  WeekCell.swift
//  WhipMe
//
//  Created by Song on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {

    var selectedBtnTags :NSMutableArray?
    
    fileprivate var bgView : UIView!
    fileprivate let kBtnWidth = (Define.screenWidth() - 2*kLeftMargin)/7
    fileprivate let tagItems = [1 ,2 ,3, 4, 5, 6,7]
    fileprivate let btnTitles = ["七", "一", "二", "三", "四", "五", "六"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = KColorBackGround
        self.selectionStyle = .none
        
        self.selectedBtnTags = NSMutableArray.init()
        
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
        
        var lastBtn:UIButton?
        for (index,btnTag) in tagItems.enumerated() {
            let weekBtn = UIButton.init(type: .custom)
//            weekBtn.backgroundColor = UIColor.random()
            weekBtn.tag = btnTag
            weekBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            weekBtn.setTitle(btnTitles[index], for: .normal)
            weekBtn.setTitleColor(KColorBlack, for: .normal)
            weekBtn.setTitleColor(KColorBlue, for: .selected)
            bgView.addSubview(weekBtn)
            weekBtn.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(0)
                make.width.equalTo(kBtnWidth)
                if lastBtn != nil {
                    make.left.equalTo((lastBtn?.snp.right)!)
                } else {
                    make.left.equalTo(0)
                }
            })
            lastBtn = weekBtn
            
            weak var weakSelf = self
            weekBtn.bk_addEventHandler({ (sender) in
                let clickBtn:UIButton = sender as! UIButton
                clickBtn.isSelected = !clickBtn.isSelected
                if clickBtn.isSelected == true {
                    weakSelf?.selectedBtnTags?.add(clickBtn.tag)
                }else {
                    weakSelf?.selectedBtnTags?.remove(clickBtn.tag)
                }
                print(weakSelf?.selectedBtnTags)
                }, for: .touchUpInside)
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
