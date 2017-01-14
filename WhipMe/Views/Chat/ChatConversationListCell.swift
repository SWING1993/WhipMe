//
//  ChatConversationListCell.swift
//  WhipMe
//
//  Created by anve on 16/9/19.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class ChatConversationListCell: UITableViewCell {

    var conversationId: String!
    
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
        imageLogo.backgroundColor = Define.kColorLight()
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
        lblNickname.textColor = Define.kColorBlack()
        lblNickname.font = kContentFont
        lblNickname.textAlignment = NSTextAlignment.left
        lblNickname.isUserInteractionEnabled = false
        self.contentView.addSubview(lblNickname)
        lblNickname.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            make.left.equalTo(imageLogo.snp.right).offset(15.0)
            make.right.equalTo(self.contentView).offset(-80.0);
            make.top.equalTo(imageLogo.snp.top);
        }

        lblBrief = UILabel.init()
        lblBrief.backgroundColor = UIColor.clear
        lblBrief.textColor = Define.kColorLight()
        lblBrief.font = kTitleFont
        lblBrief.textAlignment = NSTextAlignment.left
        lblBrief.isUserInteractionEnabled = false
        self.contentView.addSubview(lblBrief)
        lblBrief.snp.makeConstraints { (make) in
            make.height.equalTo(20.0);
            make.left.equalTo(lblNickname.snp.left);
            make.right.equalTo(self.contentView).offset(-20.0);
            make.top.equalTo(lblNickname.snp.bottom).offset(2.0);
        }

        lblTime = UILabel.init()
        lblTime.backgroundColor = UIColor.clear
        lblTime.textColor = Define.kColorLight()
        lblTime.font = kTimeFont
        lblTime.textAlignment = NSTextAlignment.right
        lblTime.isUserInteractionEnabled = false
        self.contentView.addSubview(lblTime)
        lblTime.snp.makeConstraints { (make) in
            make.height.equalTo(12.0);
            make.left.equalTo(lblNickname.snp.right).offset(10.0);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(lblNickname.snp.top);
        }

        btnUnRead = UIButton.init(type: UIButtonType.custom)
        btnUnRead.backgroundColor = Define.kColorRed()
        btnUnRead.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnUnRead.titleLabel?.font = kTitleFont
        btnUnRead.isUserInteractionEnabled = true
        btnUnRead.layer.masksToBounds = true
        btnUnRead.layer.cornerRadius = 10.0
        self.contentView.addSubview(btnUnRead)
        btnUnRead.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 20.0, height: 20.0));
            make.right.equalTo(self.contentView).offset(-20.0);
            make.bottom.equalTo(imageLogo.snp.bottom);
        }
    }
    
    public func setCell(model: FansAndFocusModel) {
       
        if (NSString.isBlankString(model.nickname)) {
            lblNickname.text = "标题"
        } else {
            lblNickname.text = model.nickname
        }
    
        if (NSString.isBlankString(model.sign)) {
            lblBrief.text = "个性签名"
        } else {
            lblBrief.text = model.sign
        }
        
    
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
