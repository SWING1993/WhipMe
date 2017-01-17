//
//  FriendsListViewCell.swift
//  WhipMe
//
//  Created by anve on 16/9/19.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class FriendsListViewCell: UITableViewCell {

    var imageLogo: UIImageView!
    var lblNickname: UILabel!
    var lblBrief: UILabel!
    var btnStatus: UIButton!
    var path: IndexPath!
    var indexCellViewPath: ((IndexPath) -> Void)?
    
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

    private func setup() {
        imageLogo = UIImageView.init()
        imageLogo.backgroundColor = kColorLight
        imageLogo.contentMode = UIViewContentMode.scaleToFill
        imageLogo.isUserInteractionEnabled = false
        imageLogo.layer.cornerRadius = 21.0
        imageLogo.layer.masksToBounds = true
        self.contentView.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { (make) in
            
            let origin: CGFloat = Define.screenWidth() == 320.0 ? 15.0 : 20.0;
            make.size.equalTo(CGSize.init(width: 42.0, height: 42.0))
            make.left.equalTo(self.contentView).offset(origin)
            make.centerY.equalTo(self.contentView)
        }
        
        lblNickname = UILabel.init()
        lblNickname.backgroundColor = UIColor.clear
        lblNickname.textColor = kColorBlack
        lblNickname.font = kContentFont
        lblNickname.textAlignment = NSTextAlignment.left
        lblNickname.isUserInteractionEnabled = false
        self.contentView.addSubview(lblNickname)
        lblNickname.snp.makeConstraints { (make) in
            make.height.equalTo(20.0)
            let origin: CGFloat = Define.screenWidth() == 320.0 ? 15.0 : 30.0;
            make.left.equalTo(imageLogo.snp.right).offset(origin);
            make.right.equalTo(self.contentView).offset(-90.0);
            make.top.equalTo(imageLogo.snp.top);
        }
        
        lblBrief = UILabel.init()
        lblBrief.backgroundColor = UIColor.clear
        lblBrief.textColor = kColorLight
        lblBrief.font = kTitleFont
        lblBrief.textAlignment = NSTextAlignment.left
        lblBrief.isUserInteractionEnabled = false
        self.contentView.addSubview(lblBrief)
        lblBrief.snp.makeConstraints { (make) in
            make.height.equalTo(20.0);
            make.left.equalTo(lblNickname.snp.left);
            make.right.equalTo(lblNickname.snp.right);
            make.top.equalTo(lblNickname.snp.bottom).offset(2.0);
        }
        
        btnStatus = UIButton.init(type: UIButtonType.custom)
        btnStatus.backgroundColor = UIColor.white
        btnStatus.setTitleColor(UIColor.white, for: UIControlState.normal)
        btnStatus.titleLabel?.font = kTitleFont
        btnStatus.isUserInteractionEnabled = false
        btnStatus.layer.masksToBounds = true
        btnStatus.layer.cornerRadius = 30/2.0
        btnStatus.layer.borderWidth = 0.5
        btnStatus.addTarget(self, action: #selector(clickWithStatus), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(btnStatus)
        btnStatus.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 78.0, height: 30.0));
            make.right.equalTo(self.contentView).offset(-15.0);
            make.bottom.equalTo(imageLogo.snp.bottom);
        }
    }
    
    func clickWithStatus() {
        if (self.indexCellViewPath != nil) {
            self.indexCellViewPath!(self.path);
        }
    }
    
    public func setCellFriend(model: FansAndFocusModel) {
        
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
        if (NSString.isBlankString(model.icon)) {
            imageLogo.setImageWith(NSURL.init(string: model.icon) as! URL, placeholderImage: Define.kDefaultPlaceImage())
        } else {
            imageLogo.image = Define.kDefaultPlaceImage()
        }
        
        if (model.focus == false) {
            btnStatus.setTitle("关注", for: UIControlState.normal)
            btnStatus.setTitleColor(Define.kColorBlue(), for: UIControlState.normal)
            btnStatus.layer.borderColor = Define.kColorBlue().cgColor
        } else {
            btnStatus.setTitle("取消关注", for: UIControlState.normal)
            btnStatus.setTitleColor(Define.kColorLight(), for: UIControlState.normal)
            btnStatus.layer.borderColor = Define.kColorLight().cgColor
        }
    }
    
    public func setCellWith(model: FansAndFocusModel) {
        
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
        if (NSString.isBlankString(model.icon)) {
            imageLogo.setImageWith(NSURL.init(string: model.icon) as! URL, placeholderImage: UIImage.init(named: "system_monitoring"))
        } else {
            imageLogo.image = UIImage.init(named: "system_monitoring")
        }
        
        if (model.focus == false) {
            btnStatus.isUserInteractionEnabled = true;
            btnStatus.setTitle("关注", for: UIControlState.normal)
            btnStatus.setTitleColor(Define.kColorBlue(), for: UIControlState.normal)
            btnStatus.layer.borderColor = Define.kColorBlue().cgColor
        } else {
            btnStatus.isUserInteractionEnabled = false;
            btnStatus.setTitle("已关注", for: UIControlState.normal)
            btnStatus.setTitleColor(Define.kColorLight(), for: UIControlState.normal)
            btnStatus.layer.borderColor = Define.kColorLight().cgColor
        }
    }
    
    func stringByStatu(statu: UInt32) -> String {
        var title: String = ""
        switch statu {
        case 1:
            title = "取消关注"
            break
        case 2:
            title = "相互关注"
            break
        default:
            title = "关注"
        }
        return title
    }
}
