//
//  RecommendCell.swift
//  WhipMe
//
//  Created by Song on 16/9/13.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class RecommendCell: NormalCell {
    
    var avatarV : UIImageView!
    var nickNameL : UILabel!
    var topicL : UILabel!
    
    var timeL : UILabel!
    var pageView : UILabel!
    
    var contentL : UILabel!
    var pictrueView : UIImageView!
    var locationB : UIButton!
    var commentL : UILabel!
    
    
    var likeB : UIButton!
    var commentB : UIButton!
    var shareB : UIButton!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        if avatarV == nil {
            avatarV = UIImageView.init()
            avatarV.backgroundColor = UIColor.random()
            avatarV.layer.cornerRadius = 36.0/2
            avatarV.layer.masksToBounds = true
            self.bgView.addSubview(avatarV)
            avatarV.snp.makeConstraints({ (make) in
                make.left.top.equalTo(18)
                make.height.width.equalTo(36)
            })
        }

        if nickNameL == nil {
            nickNameL = UILabel.init()
            nickNameL.backgroundColor = UIColor.random()
            self.bgView.addSubview(nickNameL)
            nickNameL.snp.makeConstraints({ (make) in
                make.top.equalTo(avatarV.snp.top)
                make.left.equalTo(avatarV.snp.right).offset(9)
                make.width.equalTo(140)
                make.height.equalTo(18)
            })
        }
        
        if topicL == nil {
            topicL = UILabel.init()
            topicL.backgroundColor = UIColor.random()
            self.bgView.addSubview(topicL)
            topicL.snp.makeConstraints({ (make) in
                make.top.equalTo(nickNameL.snp.bottom)
                make.left.equalTo(avatarV.snp.right).offset(9)
                make.width.equalTo(140)
                make.height.equalTo(18)
            })
        }
        
        if timeL == nil {
            timeL = UILabel.init()
            timeL.backgroundColor = UIColor.random()
            self.bgView.addSubview(timeL)
            timeL.snp.makeConstraints({ (make) in
                make.top.equalTo(nickNameL.snp.top)
                make.right.equalTo(-9)
                make.width.equalTo(100)
                make.height.equalTo(18)
            })
        }
        
        if pageView == nil {
            pageView = UILabel.init()
            pageView.backgroundColor = UIColor.random()
            self.bgView.addSubview(pageView)
            pageView.snp.makeConstraints({ (make) in
                make.top.equalTo(nickNameL.snp.bottom)
                make.right.equalTo(-9)
                make.width.equalTo(100)
                make.height.equalTo(18)
            })
        }
        
        if contentL == nil {
            contentL = UILabel.init()
            contentL.backgroundColor = UIColor.random()
            self.bgView.addSubview(contentL)
            contentL.snp.makeConstraints({ (make) in
                make.top.equalTo(avatarV.snp.bottom).offset(14)
                make.right.equalTo(-15)
                make.left.equalTo(15)
                make.height.equalTo(40)
            })
        }
        
        if pictrueView == nil {
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
        }
        
        if locationB == nil {
            locationB = UIButton.init(type: UIButtonType.custom)
            locationB.backgroundColor = UIColor.random()
            self.bgView.addSubview(locationB)
            locationB.snp.makeConstraints({ (make) in
                make.left.equalTo(9)
                make.right.equalTo(-9)
                make.top.equalTo(pictrueView.snp.bottom).offset(9)
                make.height.equalTo(15)
            })
        }
        
        let line = UIView.init()
        line.backgroundColor = UIColor.random()
        self.bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(9)
            make.right.equalTo(-9)
            make.top.equalTo(locationB.snp.bottom).offset(20)
            make.height.equalTo(0.5)
        }
        
        if likeB == nil {
            likeB = UIButton.init(type: UIButtonType.custom)
            likeB.backgroundColor = UIColor.random()
            self.bgView.addSubview(likeB)
            likeB.snp.makeConstraints({ (make) in
                make.top.equalTo(line.snp.bottom).offset(15)
                make.left.equalTo(9)
                make.width.equalTo(100)
                make.height.equalTo(15)
            })
        }
        
        if commentB == nil {
            commentB = UIButton.init(type: UIButtonType.custom)
            commentB.backgroundColor = UIColor.random()
            self.bgView.addSubview(commentB)
            commentB.snp.makeConstraints({ (make) in
                make.top.equalTo(line.snp.bottom).offset(15)
                make.centerX.equalTo(self)
                make.width.equalTo(100)
                make.height.equalTo(15)
            })
        }

        
        if shareB == nil {
            shareB = UIButton.init(type: UIButtonType.custom)
            shareB.backgroundColor = UIColor.random()
            self.bgView.addSubview(shareB)
            shareB.snp.makeConstraints({ (make) in
                make.top.equalTo(line.snp.bottom).offset(15)
                make.right.equalTo(-9)
                make.width.equalTo(100)
                make.height.equalTo(15)
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
    
    class func cellReuseIdentifier() -> String {
        return "RecommendCell"
    }
}
