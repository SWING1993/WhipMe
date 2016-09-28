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
            
            let origin: CGFloat = Define.screenWidth() == 320.0 ? 15.0 : 20.0;
            make.size.equalTo(CGSize.init(width: 42.0, height: 42.0))
            make.left.equalTo(self.contentView).offset(origin)
            make.centerY.equalTo(self.contentView)
        }
        
        lblNickname = UILabel.init()
        lblNickname.backgroundColor = UIColor.clear
        lblNickname.textColor = Define.kColorBlack()
        lblNickname.font = KContentFont
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
        lblBrief.textColor = Define.kColorLight()
        lblBrief.font = KTitleFont
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
        btnStatus.titleLabel?.font = KTitleFont
        btnStatus.isUserInteractionEnabled = false
        btnStatus.layer.masksToBounds = true
        btnStatus.layer.cornerRadius = 30/2.0
        btnStatus.layer.borderWidth = 0.5
        self.contentView.addSubview(btnStatus)
        btnStatus.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 78.0, height: 30.0));
            make.right.equalTo(self.contentView).offset(-15.0);
            make.bottom.equalTo(imageLogo.snp.bottom);
        }
    }
    
    public func setCellWithModel(model: JMSGUser) {
        
        let statue: UInt32 = arc4random()%3;
        let color: UIColor = statue != 1 ? Define.kColorBlue() : Define.kColorLight();
        btnStatus.setTitle(stringByStatu(statu: statue), for: UIControlState.normal)
        btnStatus.setTitleColor(color, for: UIControlState.normal)
        btnStatus.layer.borderColor = color.cgColor
        
        lblNickname.text = model.nickname ?? model.username
        lblBrief.text = model.signature ?? "生活就像强奸，反抗不了，就只能学会享受"
        
        var imageHead = UIImage.init(contentsOfFile: model.avatar ?? "")
        if imageHead == nil {
            imageHead = UIImage.init(named: "system_monitoring")
        }
        imageLogo.image = imageHead
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
