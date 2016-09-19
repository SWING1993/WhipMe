//
//  ChatConversationListCell.swift
//  WhipMe
//
//  Created by anve on 16/9/19.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
//import JMessage

class ChatConversationListCell: UITableViewCell {

    var conversationId: String!
//    var cellWithConversation: JMSGConversation!
    
    var imageLogo: UIImageView!
    var lblNickname: UILabel!
    var lblBrief: UILabel!
    var lblTime: UILabel!
    var btnUnRead: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

    private func setup() {
        
        imageLogo = UIImageView.init()
        imageLogo.backgroundColor = KColorLight
        imageLogo.contentMode = UIViewContentMode.scaleToFill
        imageLogo.isUserInteractionEnabled = false
        imageLogo.layer.cornerRadius = 21.0
        imageLogo.layer.masksToBounds = true
        self.contentView.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 42.0, height: 42.0))
            make.left.equalTo(self.contentView).offset(20.0)
            make.centerY.equalTo(self.contentView)
        }
        
        lblNickname = UILabel.init()
        lblNickname.backgroundColor = UIColor.clear
        lblNickname.textColor = KColorBlack
        lblNickname.font = KContentFont
        lblNickname.textAlignment = NSTextAlignment.left
        lblNickname.isUserInteractionEnabled = false
        self.contentView.addSubview(lblNickname)
        lblNickname.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.left.equalTo(self.imageLogo.snp.right).offset(15.0)
            make.right.equalTo(self.contentView).offset(-80.0);
            make.top.equalTo(self.imageLogo.snp.top);
        }

        lblBrief = UILabel.init()
        lblBrief.backgroundColor = UIColor.clear
        lblBrief.textColor = KColorLight
        lblBrief.font = KTitleFont
        lblBrief.textAlignment = NSTextAlignment.left
        lblBrief.isUserInteractionEnabled = false
        self.contentView.addSubview(lblBrief)
        lblBrief.snp.makeConstraints { (make) in
            make.height.equalTo(20.0);
            make.left.equalTo(self.lblNickname.snp.left);
            make.right.equalTo(self.contentView).offset(-20.0);
            make.top.equalTo(self.lblNickname.snp.bottom).offset(2.0);
        }

        lblTime = UILabel.init()
        lblTime.backgroundColor = UIColor.clear
        lblTime.textColor = KColorLight
        lblTime.font = KTimeFont
        lblTime.textAlignment = NSTextAlignment.right
        lblTime.isUserInteractionEnabled = false
        self.contentView.addSubview(lblTime)
        lblTime.snp.makeConstraints { (make) in
            make.height.equalTo(12.0);
            make.left.equalTo(self.lblNickname.snp.right).offset(10.0);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.lblNickname.snp.top);
        }

        btnUnRead = UIButton.init(type: UIButtonType.custom)
        btnUnRead.backgroundColor = KColorRed
        btnUnRead.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnUnRead.titleLabel?.font = KTitleFont
        btnUnRead.isUserInteractionEnabled = true
        btnUnRead.layer.masksToBounds = true
        btnUnRead.layer.cornerRadius = 10.0
        self.contentView.addSubview(btnUnRead)
        btnUnRead.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 20.0, height: 20.0));
            make.right.equalTo(self.contentView).offset(-20.0);
            make.bottom.equalTo(self.imageLogo.snp.bottom);
        }
    }
    
    public func setCellWithModel(model: NSDictionary) {
       
        lblNickname.text = "环球黑卡官方"
    
        lblBrief.text = "你的终身管家"
    
        lblTime.text = "10分钟前"
        
        let count : UInt32 = arc4random()%3
        btnUnRead.isHidden = count > 0 ? false : true
        btnUnRead.setTitle(recountUnReadCount(unReadCount: count), for: UIControlState.normal)
        
        imageLogo.image = UIImage.init(named: "system_monitoring")
    }
    
    private func recountUnReadCount(unReadCount: UInt32) -> String {
        var str: String = ""
        if (unReadCount <= 0) {
            str = "";
        } else if (unReadCount > 99) {
            str = "99+";
        } else {
            str = String(unReadCount)
        }
        return str;
    }
}
