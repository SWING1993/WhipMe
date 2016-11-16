//
//  RecommendCell.swift
//  WhipMe
//
//  Created by Song on 16/9/13.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class RecommendCell: NormalCell {
    
    var avatarV: UIImageView = UIImageView.init()
    var nickNameL: UILabel = UILabel.init()
    var topicL: UILabel = UILabel.init()
    
    var timeL: UILabel = UILabel.init()
    var pageView: UILabel = UILabel.init()
    
    var contentL: UILabel = UILabel.init()
    var pictrueView: UIImageView = UIImageView.init()
    var locationB: UILabel = UILabel.init()
    var commentL: UILabel = UILabel.init()
    
    var likeB: UIButton = UIButton.init()
    var commentB: UIButton = UIButton.init()
    var shareB: UIButton = UIButton.init()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        avatarV = UIImageView.init()
        avatarV.backgroundColor = UIColor.random()
        avatarV.layer.cornerRadius = 36.0/2
        avatarV.layer.masksToBounds = true
        self.bgView.addSubview(avatarV)
        avatarV.snp.makeConstraints({ (make) in
            make.left.top.equalTo(18)
            make.height.width.equalTo(36)
        })

        nickNameL = UILabel.init()
        nickNameL.font = UIFont.systemFont(ofSize: 16)
//        nickNameL.backgroundColor = UIColor.random()
        self.bgView.addSubview(nickNameL)
        nickNameL.snp.makeConstraints({ (make) in
            make.top.equalTo(avatarV.snp.top)
            make.left.equalTo(avatarV.snp.right).offset(9)
            make.width.equalTo(140)
            make.height.equalTo(18)
        })
        
        topicL = UILabel.init()
        topicL.font = UIFont.systemFont(ofSize: 11)
//        topicL.backgroundColor = UIColor.random()
        self.bgView.addSubview(topicL)
        topicL.snp.makeConstraints({ (make) in
            make.top.equalTo(nickNameL.snp.bottom)
            make.left.equalTo(avatarV.snp.right).offset(9)
            make.width.equalTo(140)
            make.height.equalTo(18)
        })
        
        timeL = UILabel.init()
        timeL.font = UIFont.systemFont(ofSize: 10)
//        timeL.backgroundColor = UIColor.random()
        self.bgView.addSubview(timeL)
        timeL.snp.makeConstraints({ (make) in
            make.top.equalTo(nickNameL.snp.top)
            make.right.equalTo(-9)
            make.width.equalTo(100)
            make.height.equalTo(18)
        })
        
        pageView = UILabel.init()
        pageView.font = UIFont.systemFont(ofSize: 14)
        pageView.textAlignment = .center
//        pageView.backgroundColor = UIColor.random()
        self.bgView.addSubview(pageView)
        pageView.snp.makeConstraints({ (make) in
            make.top.equalTo(nickNameL.snp.bottom)
            make.right.equalTo(-9)
            make.width.equalTo(100)
            make.height.equalTo(18)
        })
        
        contentL = UILabel.init()
        contentL.font = UIFont.systemFont(ofSize: 14)
//        contentL.backgroundColor = UIColor.random()
        self.bgView.addSubview(contentL)
        contentL.snp.makeConstraints({ (make) in
            make.top.equalTo(avatarV.snp.bottom).offset(14)
            make.right.equalTo(-15)
            make.left.equalTo(15)
            make.height.equalTo(40)
        })
        
        pictrueView = UIImageView.init()
        pictrueView.backgroundColor = UIColor.random()
        pictrueView.contentMode = UIViewContentMode.scaleAspectFill
        pictrueView.clipsToBounds = true
        self.bgView.addSubview(pictrueView)
        pictrueView.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(0.5)
            make.rightMargin.equalTo(-0.5)
            make.height.equalTo(Define.screenWidth()/2)
            make.top.equalTo(contentL.snp.bottom).offset(15)
        }
        
        locationB = UILabel.init()
        locationB.font = UIFont.systemFont(ofSize: 11)
//        locationB.backgroundColor = UIColor.random()
        self.bgView.addSubview(locationB)
        locationB.snp.makeConstraints({ (make) in
            make.left.equalTo(9)
            make.right.equalTo(-9)
            make.top.equalTo(pictrueView.snp.bottom).offset(9)
            make.height.equalTo(15)
        })
        
        let line = UIView.init()
        line.backgroundColor = UIColor.random()
        self.bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(9)
            make.right.equalTo(-9)
            make.top.equalTo(locationB.snp.bottom).offset(20)
            make.height.equalTo(0.5)
        }
        
        let btnImage = UIImage.init(named: "zan_icon_off")
        let edgeInsetsWidth = (btnImage?.size.width)!/3
        
        likeB = UIButton.init(type: UIButtonType.custom)
        likeB.backgroundColor = UIColor.random()
        likeB.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        likeB.setTitleColor(kColorGary, for: .normal)
        likeB.setImage(UIImage.init(named: "zan_icon_off"), for: .normal)
        likeB.setImage(UIImage.init(named: "zan_icon_on"), for: .selected)

        likeB.imageEdgeInsets = UIEdgeInsetsMake(0, -edgeInsetsWidth, 0, edgeInsetsWidth)
        likeB.titleEdgeInsets = UIEdgeInsetsMake(0, edgeInsetsWidth, 0, -edgeInsetsWidth)
        self.bgView.addSubview(likeB)
        likeB.snp.makeConstraints({ (make) in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.left.equalTo(9)
            make.width.equalTo(100)
            make.height.equalTo(15)
        })
        
        commentB = UIButton.init(type: UIButtonType.custom)
//        commentB.backgroundColor = UIColor.random()
        commentB.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        commentB.setTitleColor(kColorGary, for: .normal)
        commentB.setImage(UIImage.init(named: "comment_icon_off"), for: .normal)
        commentB.imageEdgeInsets = UIEdgeInsetsMake(0, -edgeInsetsWidth, 0, edgeInsetsWidth)
        commentB.titleEdgeInsets = UIEdgeInsetsMake(0, edgeInsetsWidth, 0, -edgeInsetsWidth)
        self.bgView.addSubview(commentB)
        commentB.snp.makeConstraints({ (make) in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.centerX.equalTo(self)
            make.width.equalTo(100)
            make.height.equalTo(15)
        })

        shareB = UIButton.init(type: UIButtonType.custom)
//        shareB.backgroundColor = UIColor.random()
        shareB.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        shareB.setTitleColor(kColorGary, for: .normal)
        shareB.setImage(UIImage.init(named: "share_icon"), for: .normal)
        shareB.imageEdgeInsets = UIEdgeInsetsMake(0, -edgeInsetsWidth, 0, edgeInsetsWidth)
        shareB.titleEdgeInsets = UIEdgeInsetsMake(0, edgeInsetsWidth, 0, -edgeInsetsWidth)
        self.bgView.addSubview(shareB)
        shareB.snp.makeConstraints({ (make) in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.right.equalTo(-9)
            make.width.equalTo(100)
            make.height.equalTo(15)
        })
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
    
    class func cellReuseIdentifier() -> String {
        return "RecommendCell"
    }
}
