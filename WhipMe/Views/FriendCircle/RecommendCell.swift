//
//  RecommendCell.swift
//  WhipMe
//
//  Created by Song on 16/9/13.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class CommentM: NSObject {
    var content:String = ""
    var nickName:String = ""
    var userId:String = ""
}

class RecommendCell: NormalCell {
    
    var avatarV: UIImageView = UIImageView.init()
    var nickNameL: UILabel = UILabel.init()
    var topicL: UILabel = UILabel.init()
    
    var timeL: UILabel = UILabel.init()
    var pageView: UILabel = UILabel.init()
    
    var contentL: UILabel = UILabel.init()
    var pictrueView: UIImageView = UIImageView.init()
    var locationB: UILabel = UILabel.init()
    let locatiomV = UIImageView.init()

    var commentList: UITableView = UITableView.init()
    var commentMArr: NSMutableArray = NSMutableArray.init()
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
        topicL.textColor = kColorGreen
//        topicL.backgroundColor = UIColor.random()
        self.bgView.addSubview(topicL)
        topicL.snp.makeConstraints({ (make) in
            make.top.equalTo(nickNameL.snp.bottom)
            make.left.equalTo(avatarV.snp.right).offset(9)
            make.width.equalTo(140)
            make.height.equalTo(18)
        })
        
        timeL = UILabel.init()
        timeL.textColor = kColorGary
        timeL.textAlignment = .right
        timeL.font = UIFont.systemFont(ofSize: 10)
//        timeL.backgroundColor = UIColor.random()
        self.bgView.addSubview(timeL)
        timeL.snp.makeConstraints({ (make) in
            make.top.equalTo(nickNameL.snp.top)
            make.right.equalTo(-9)
            make.width.equalTo(150)
            make.height.equalTo(18)
        })
        
        pageView = UILabel.init()
        pageView.textColor = kColorGreen
        pageView.textAlignment = .right
        pageView.font = UIFont.systemFont(ofSize: 14)
        self.bgView.addSubview(pageView)
        pageView.snp.makeConstraints({ (make) in
            make.top.equalTo(nickNameL.snp.bottom)
            make.right.equalTo(-9)
            make.width.equalTo(100)
            make.height.equalTo(18)
        })
        
        contentL = UILabel.init()
        contentL.font = UIFont.systemFont(ofSize: 14)
        contentL.numberOfLines = 0
        self.bgView.addSubview(contentL)
        contentL.snp.makeConstraints({ (make) in
            make.top.equalTo(avatarV.snp.bottom).offset(14)
            make.right.equalTo(-15)
            make.left.equalTo(15)
            make.height.equalTo(0)
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
        
        locatiomV.image = UIImage.init(named: "location")
        self.bgView.addSubview(locatiomV)
        locatiomV.snp.makeConstraints({ (make) in
            make.left.equalTo(9)
            make.top.equalTo(pictrueView.snp.bottom).offset(10.5)
            make.height.width.equalTo(12)
        })
        
        locationB = UILabel.init()
        locationB.font = UIFont.systemFont(ofSize: 11)
        self.bgView.addSubview(locationB)
        locationB.snp.makeConstraints({ (make) in
            make.left.equalTo(locatiomV.snp.right).offset(3)
            make.right.equalTo(-9)
            make.top.equalTo(pictrueView.snp.bottom).offset(9)
            make.height.equalTo(15)
        })
        
        
        commentList = UITableView.init()
        commentList.dataSource = self
        commentList.delegate = self
        commentList.separatorStyle = .none
        commentList.isScrollEnabled = false
        self.bgView.addSubview(commentList)
        commentList.snp.makeConstraints { (make) in
            make.left.equalTo(9)
            make.right.equalTo(-9)
            make.top.equalTo(locationB.snp.bottom).offset(9)
            make.height.equalTo(35)
        }
        
        let activeV = UIView.init()
        activeV.frame = CGRect.init(x: 0, y: 0, width: self.bgView.width, height: 35)
        commentList.tableFooterView = activeV
        
        let line = UIView.init()
        line.backgroundColor = Define.RGBColorAlphaFloat(153, g: 153, b: 153, a: 0.5)
        activeV.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(9)
            make.right.equalTo(-9)
            make.top.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        let btnImage = UIImage.init(named: "zan_icon_off")
        let edgeInsetsWidth = (btnImage?.size.width)!/3
        
        likeB = UIButton.init(type: UIButtonType.custom)
        likeB.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        likeB.setTitleColor(kColorGary, for: .normal)
        likeB.setImage(UIImage.init(named: "zan_icon_off"), for: .normal)
        likeB.setImage(UIImage.init(named: "zan_icon_on"), for: .selected)

        likeB.imageEdgeInsets = UIEdgeInsetsMake(0, -edgeInsetsWidth, 0, edgeInsetsWidth)
        likeB.titleEdgeInsets = UIEdgeInsetsMake(0, edgeInsetsWidth, 0, -edgeInsetsWidth)
        activeV.addSubview(likeB)
        likeB.snp.makeConstraints({ (make) in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.left.equalTo(9)
            make.width.equalTo(100)
            make.height.equalTo(15)
        })
        
        commentB = UIButton.init(type: UIButtonType.custom)
        commentB.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        commentB.setTitleColor(kColorGary, for: .normal)
        commentB.setImage(UIImage.init(named: "comment_icon_off"), for: .normal)
        commentB.imageEdgeInsets = UIEdgeInsetsMake(0, -edgeInsetsWidth, 0, edgeInsetsWidth)
        commentB.titleEdgeInsets = UIEdgeInsetsMake(0, edgeInsetsWidth, 0, -edgeInsetsWidth)
        activeV.addSubview(commentB)
        commentB.snp.makeConstraints({ (make) in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.centerX.equalTo(self)
            make.width.equalTo(100)
            make.height.equalTo(15)
        })

        shareB = UIButton.init(type: UIButtonType.custom)
        shareB.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        shareB.setTitleColor(kColorGary, for: .normal)
        shareB.setImage(UIImage.init(named: "share_icon"), for: .normal)
        shareB.imageEdgeInsets = UIEdgeInsetsMake(0, -edgeInsetsWidth, 0, edgeInsetsWidth)
        shareB.titleEdgeInsets = UIEdgeInsetsMake(0, edgeInsetsWidth, 0, -edgeInsetsWidth)
        activeV.addSubview(shareB)
        shareB.snp.makeConstraints({ (make) in
            make.top.equalTo(line.snp.bottom).offset(15)
            make.right.equalTo(-9)
            make.width.equalTo(100)
            make.height.equalTo(15)
        })
    }
    
    func setRecommendData(model:FriendCircleM) {
        
        if model.picture.isEmpty {
            self.pictrueView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
        }else {
            self.pictrueView.setImageWith(urlString: model.picture, placeholderImage: "")
        }
        self.avatarV.setImageWith(urlString: model.icon, placeholderImage: "")
        self.contentL.text = model.content
        self.nickNameL.text = model.nickname
        self.topicL.text = "#"+model.themeName+"#"
        self.timeL.text = model.createDate
        self.pageView.text = String(model.recordIdNum) + "次"
        
        if model.position.isEmpty {
            self.locationB.text = ""
            self.locatiomV.isHidden = true
        }else {
            self.locationB.text = model.position
            self.locatiomV.isHidden = false
        }
        
        self.likeB.setTitle(String(model.likeNum), for: .normal)
        self.commentB.setTitle(String(model.commentNum), for: .normal)
        self.shareB.setTitle(String(model.shareNum), for: .normal)
        
        let content: NSString = NSString.init(string: model.content)
        let contentH :CGFloat = content.getHeightWith(UIFont.systemFont(ofSize: 14), constrainedTo: CGSize.init(width: Define.screenWidth() - 48, height: CGFloat.greatestFiniteMagnitude))
        self.contentL.snp.updateConstraints { (make) in
            make.height.equalTo(contentH)
        }

        self.commentMArr = CommentM.mj_objectArray(withKeyValuesArray: model.comment)
        let height = CGFloat(model.comment.count * 35 + 35)
        self.commentList.snp.updateConstraints { (make) in
            make.height.equalTo(height);
        }
        self.commentList.reloadData()
    }
    
    class func cellHeight(model:FriendCircleM) -> CGFloat {
        var height:CGFloat = 170.0
        if model.picture.isEmpty == false {
            height += Define.screenWidth()/2
        }
        height += CGFloat(model.comment.count) * 35.0
        let content: NSString = NSString.init(string: model.content)
        height += content.getHeightWith(UIFont.systemFont(ofSize: 14), constrainedTo: CGSize.init(width: Define.screenWidth() - 48, height: CGFloat.greatestFiniteMagnitude))
        return height
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
    
    class func focusCellReuseIdentifier() -> String {
        return "FocusRecommendCell"
    }
}

/// TableViewDataSource methods.
extension RecommendCell:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentMArr.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "comment")
        let model:CommentM = self.commentMArr.object(at: indexPath.row) as! CommentM
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.text = model.nickName+":"+model.content
        return cell
    }
}


/// UITableViewDelegate methods.
extension RecommendCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
