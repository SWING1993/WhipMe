//
//  FinancialDetailsCell.swift
//  WhipMe
//
//  Created by anve on 16/11/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class FinancialDetailsCell: UITableViewCell {
    
    open var lblTitle: UILabel!
    open var lblTime: UILabel!
    open var lblMoney: UILabel!
    open var lineView: UIView!
    open var viewCurrent: UIView!
    
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
        return 60.0
    }
    
    func setup() {
        
        viewCurrent = UIView.init()
        viewCurrent.backgroundColor = UIColor.white
        self.contentView.addSubview(viewCurrent)
        viewCurrent.snp.updateConstraints { (make) in
            make.width.equalTo(self.contentView).offset(-16.0)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.height.equalTo(self.contentView)
        }
        
        lineView = UIView.init()
        lineView.backgroundColor = kColorLine
        viewCurrent.addSubview(lineView)
        lineView.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.viewCurrent)
            make.width.equalTo(self.viewCurrent)
            make.bottom.equalTo(self.viewCurrent)
            make.height.equalTo(0.5)
        }
        
        lblTitle = UILabel.init()
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.textColor = kColorBlack
        lblTitle.font = UIFont.systemFont(ofSize: 15.0)
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.text = "任务未完成"
        viewCurrent.addSubview(lblTitle)
        lblTitle.snp.updateConstraints { (make) in
            make.left.equalTo(self.viewCurrent).offset(24.0)
            make.top.equalTo(self.viewCurrent).offset(12.0)
            make.right.equalTo(self.viewCurrent).offset(-90.0)
            make.height.equalTo(20)
        }
        
        lblTime = UILabel.init()
        lblTime.backgroundColor = UIColor.clear
        lblTime.textColor = kColorLight
        lblTime.font = UIFont.systemFont(ofSize: 9.0)
        lblTime.textAlignment = NSTextAlignment.left
        lblTime.text = "2016-11-18 11:44:32"
        viewCurrent.addSubview(lblTime)
        lblTime.snp.updateConstraints { (make) in
            make.left.equalTo(self.lblTitle.snp.left)
            make.top.equalTo(self.lblTitle.snp.bottom).offset(7.0)
            make.width.equalTo(self.lblTitle.snp.width)
            make.height.equalTo(12)
        }
        
        lblMoney = UILabel.init()
        lblMoney.backgroundColor = UIColor.clear
        lblMoney.textColor = kColorBlack
        lblMoney.font = kContentFont
        lblMoney.textAlignment = NSTextAlignment.right
        lblMoney.text = "- 30"
        viewCurrent.addSubview(lblMoney)
        lblMoney.snp.updateConstraints { (make) in
            make.left.equalTo(self.lblTitle.snp.left)
            make.centerY.equalTo(self.viewCurrent)
            make.right.equalTo(self.viewCurrent).offset(-24.0)
            make.height.equalTo(20)
        }
    }
    
    func cellModel(model: Dictionary<String, String>) {
//        self.lblTitle.text = model["title"]
//        self.lblTime.text = model["time"]
//        self.lblMoney.text = model["money"]
        
//        let money: Bool = model["type"].boolValue
//        if money > 0.0 {
//            lblMoney.textColor = Define.RGBColorFloat(71, g: 178, b: 248)
//        } else {
//            lblMoney.textColor = kColorBlack
//        }
    }

}
