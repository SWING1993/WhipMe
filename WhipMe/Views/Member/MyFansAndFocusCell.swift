//
//  MyFansAndFocusCell.swift
//  WhipMe
//
//  Created by anve on 16/11/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class MyFansAndFocusCell: UITableViewCell {
    
    open var imageIcon: UIImageView!
    open var lblTitle: UILabel!
    open var lblDescribe: UILabel!
    open var btnCheck: UIButton!
    open var lineView: UIView!
    open var viewCurrent: UIView!
    
    open var delegate: MyFansAndFocusCellDelegate!
    
    fileprivate let kHead_WH: CGFloat = 41.0
    fileprivate let size_chek: CGRect = CGRect.init(x: 0, y: 0, width: 75.0, height: 28.0)
    
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
        return 65.0
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
        
        imageIcon = UIImageView.init()
        imageIcon.backgroundColor = Define.kColorBackGround()
        imageIcon.layer.cornerRadius = kHead_WH/2.0
        imageIcon.layer.masksToBounds = true
        imageIcon.contentMode = UIViewContentMode.scaleAspectFill
        imageIcon.clipsToBounds = true
        viewCurrent.addSubview(imageIcon)
        imageIcon.snp.updateConstraints { (make) in
            make.left.equalTo(20.0)
            make.centerY.equalTo(self.viewCurrent)
            make.size.equalTo(CGSize.init(width: kHead_WH, height: kHead_WH))
        }
        
        lblTitle = UILabel.init()
        lblTitle.backgroundColor = UIColor.clear
        lblTitle.textColor = kColorBlack
        lblTitle.font = UIFont.systemFont(ofSize: 15.0)
        lblTitle.textAlignment = NSTextAlignment.left
        lblTitle.text = "小溪漓江"
        viewCurrent.addSubview(lblTitle)
        lblTitle.snp.updateConstraints { (make) in
            make.left.equalTo(self.imageIcon.snp.right).offset(30.0)
            make.top.equalTo(self.imageIcon.snp.top)
            make.right.equalTo(self.viewCurrent).offset(-90.0)
            make.height.equalTo(20)
        }
        
        lblDescribe = UILabel.init()
        lblDescribe.backgroundColor = UIColor.clear
        lblDescribe.textColor = kColorLight
        lblDescribe.font = UIFont.systemFont(ofSize: 11.0)
        lblDescribe.textAlignment = NSTextAlignment.left
        lblDescribe.text = "监督是一种责任"
        viewCurrent.addSubview(lblDescribe)
        lblDescribe.snp.updateConstraints { (make) in
            make.left.equalTo(self.lblTitle.snp.left)
            make.top.equalTo(self.lblTitle.snp.bottom)
            make.width.equalTo(self.lblTitle.snp.width)
            make.height.equalTo(20)
        }
        
        
        btnCheck = UIButton.init(type: UIButtonType.custom)
        btnCheck.setBackgroundImage(UIImage.imageWithDraw(kColorLight, sizeMake: size_chek), for: UIControlState.normal)
        btnCheck.layer.cornerRadius = size_chek.height/2.0
        btnCheck.layer.masksToBounds = true
        btnCheck.titleLabel?.font = kTimeFont
        btnCheck.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnCheck.addTarget(self, action: #selector(onClickWithCheck(sender:)), for: UIControlEvents.touchUpInside)
        viewCurrent.addSubview(btnCheck)
        btnCheck.snp.updateConstraints { (make) in
            make.size.equalTo(size_chek.size)
            make.right.equalTo(self.viewCurrent).offset(-15.0)
            make.centerY.equalTo(self.viewCurrent)
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
    }
    
    func onClickWithCheck(sender: UIButton) {
        self.delegate.fansAndFocusCheck()
    }
    
    func cellModel(model: Dictionary<String,String>, style: WMFansAndFocusStyle) {
    
        self.imageIcon.image = UIImage.init(named: "")
        
        self.lblTitle.text = model["title"]
        
        self.lblDescribe.text = model["describe"]
        
        var color_normal: UIColor = kColorLight
        if (style == .fans) {
            color_normal = Define.RGBColorFloat(71, g: 178, b: 248)
            self.btnCheck.setTitle("关注", for: UIControlState.normal)
        } else {
            color_normal = kColorLight
            self.btnCheck.setTitle("取消关注", for: UIControlState.normal)
        }
        let img_normal = UIImage.imageWithDraw(color_normal, sizeMake: size_chek)
        self.btnCheck.setBackgroundImage(img_normal, for: UIControlState.normal)
        
    }
}

public protocol MyFansAndFocusCellDelegate: NSObjectProtocol {
    
    func fansAndFocusCheck()
}
