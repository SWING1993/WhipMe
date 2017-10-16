//
//  RecommendCell.swift
//  WhipMe
//
//  Created by Song on 16/9/13.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class CommentM: NSObject {
    var content:String = ""
    var nickname:String = ""
    var userId:String = ""
}

class RecommendCell: NormalCell {
    
    var commentSuccess: (() -> Void)?

    var myRecommendM = FriendCircleM.init()
    
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

    let commentHeight = 30
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        avatarV = UIImageView.init()
        avatarV.contentMode = .scaleAspectFill
        avatarV.layer.cornerRadius = 36.0/2
        avatarV.layer.masksToBounds = true
        avatarV.isUserInteractionEnabled = true
        self.bgView.addSubview(avatarV)
        avatarV.snp.makeConstraints({ (make) in
            make.left.top.equalTo(18)
            make.height.width.equalTo(36)
        })
        
//        avatarV.bk_(whenTapped: { () -> Void in
//            let hud = MBProgressHUD.showAdded(to: kKeyWindows!, animated: true)
//            hud.label.text = "加载中..."
//            let params = [
//                "userId":self.myRecommendM.creator,
//                "loginId":UserManager.shared.userId,
//            ]
//            HttpAPIClient.apiClientPOST("queryUserBlog", params: params, success: { (result) in
//                hud.hide(animated: true)
//                if let dataResult = result {
//                    print(dataResult)
//                    let json = JSON(dataResult)
//                    let ret  = json["data"][0]["ret"].intValue
//                    if ret == 0 {
//                        let dataJson = json["data"][0]
//                        let string = String(describing: dataJson)
//
//                        if let userBlogM = JSONDeserializer<UserBlogM>.deserializeFrom(json: string) {
//                            let queryUserBlogC = QueryUserBlogC.init()
//                            queryUserBlogC.navigationItem.title = self.myRecommendM.nickname
//                            queryUserBlogC.userBlogM = userBlogM
//                            let blogNav = UINavigationController.init(rootViewController: queryUserBlogC)
//                            kKeyWindows?.rootViewController?.present(blogNav, animated: true, completion: {
//
//                            })
//                        }
//                    } else {
//                        Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
//                    }
//                }
//            }) { (error) in
//                hud.hide(animated: true)
//                Tool.showHUDTip(tipStr: "网络不给力")
//            }
//        })

        nickNameL = UILabel.init()
        nickNameL.font = UIFont.systemFont(ofSize: 16)
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
        topicL.isUserInteractionEnabled = true
        self.bgView.addSubview(topicL)
        topicL.snp.makeConstraints({ (make) in
            make.top.equalTo(nickNameL.snp.bottom)
            make.left.equalTo(avatarV.snp.right).offset(9)
            make.width.equalTo(140)
            make.height.equalTo(18)
        })
        topicL.bk_(whenTapped: { () -> Void in
            let whipM = WhipM()
            whipM.themeId = self.myRecommendM.themeId
            whipM.themeName = self.myRecommendM.themeName
            let classVC = ClassifyController()
            classVC.myWhipM = whipM
            let classNav = UINavigationController.init(rootViewController: classVC)
            if classVC.navigationItem.leftBarButtonItem == nil {
                classVC.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: classVC, action: #selector(ClassifyController.disMiss))
            }
            kKeyWindows?.rootViewController?.present(classNav, animated: true, completion: { })
        })

        
        timeL = UILabel.init()
        timeL.textColor = kColorGary
        timeL.textAlignment = .right
        timeL.font = UIFont.systemFont(ofSize: 10)
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
        pictrueView.contentMode = UIViewContentMode.scaleAspectFill
        pictrueView.clipsToBounds = true
        pictrueView.isUserInteractionEnabled = true
        self.bgView.addSubview(pictrueView)
        pictrueView.snp.makeConstraints { (make) in
            make.leftMargin.equalTo(0.5)
            make.rightMargin.equalTo(-0.5)
            make.height.equalTo(Define.screenWidth()/2)
            make.top.equalTo(contentL.snp.bottom).offset(15)
        }
        pictrueView.bk_(whenTapped: {
            let brower = MJPhotoBrowser()
            let photo = MJPhoto()
            photo.srcImageView = self.pictrueView
            brower.photos = NSMutableArray.init(object: photo)
            brower.currentPhotoIndex = 0
            brower.show()
        })
        
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
        commentList.allowsSelection = false
        self.bgView.addSubview(commentList)
        commentList.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(locationB.snp.bottom).offset(9)
            make.height.equalTo(commentHeight)
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
        likeB.bk_addEventHandler({ (sender) in
            if self.likeB.isSelected == false {
                let params = [
                    "userId":UserManager.shared.userId,
                    "nickname":UserManager.shared.nickname,
                    "icon":UserManager.shared.icon,
                    "recordId":self.myRecommendM.recordId,
                    "creator":self.myRecommendM.creator,
                    ]
                
                HttpAPIClient.apiClientPOST("addLike", params: params, success: { (result) in
                    if (result != nil) {
                        
                        let json = JSON(result!)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            self.myRecommendM.liked = true
                            self.likeB.isSelected = self.myRecommendM.liked
                            self.myRecommendM.likeNum = self.myRecommendM.likeNum + 1
                            self.likeB.setTitle(String(self.myRecommendM.likeNum), for: .normal)
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            }
        }, for: .touchUpInside)
        
        
        
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
        
        commentB.bk_addEventHandler({ (sender) in
            CommentView.sharedInstance.show()
            CommentView.sharedInstance.okBlock = {  (comment) -> Void in
                
                let params = [
                    "userId":UserManager.shared.userId,
                    "nickname":UserManager.shared.nickname,
                    "content":comment,
                    "recordId":self.myRecommendM.recordId,
                    "creator":self.myRecommendM.creator,
                    //                    "creatorId":self.myRecommendM.creatorId,
                ]
                HttpAPIClient.apiClientPOST("addComment", params: params, success: { (result) in
                    if (result != nil) {
                        
                        let json = JSON(result!)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            if self.commentSuccess != nil {
                                self.commentSuccess!()
                            }
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            }
            
        }, for: .touchUpInside)
        
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
        shareB.bk_addEventHandler({ (sender) in
            let shareC = ShareController.init()
            shareC.navigationItem.title = "分享"
            shareC.myFriendCircleM = self.myRecommendM
            let shareNav = UINavigationController.init(rootViewController: shareC)
            kKeyWindows?.rootViewController?.present(shareNav, animated: true, completion: { })
        }, for: .touchUpInside)
    }
    
    func setRecommendData(model:FriendCircleM) {
        
        self.myRecommendM = model
        
        if model.picture.isEmpty {
            self.pictrueView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
                make.top.equalTo(contentL.snp.bottom)
            })
        }else {
            self.pictrueView.setImageWith(urlString: model.picture, placeholderImage: "nilTouSu")
        }
        self.avatarV.setImageWith(urlString: model.icon, placeholderImage: Define.kDefaultHeadStr())
        self.contentL.text = model.content
        self.nickNameL.text = model.nickname
        self.topicL.text = "#"+model.themeName+"#"
        self.timeL.text = model.createDate
        self.pageView.text = String(model.recordNum) + "次"
        
        if model.position.isEmpty {
            self.locationB.text = ""
            self.locatiomV.isHidden = true
            self.locationB.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
        }else {
            self.locationB.text = model.position
            self.locatiomV.isHidden = false
        }
        
        self.likeB.isSelected = model.liked
        self.likeB.setTitle(String(model.likeNum), for: .normal)
        self.commentB.setTitle(String(model.commentNum), for: .normal)
        self.shareB.setTitle(String(model.shareNum), for: .normal)
        
        let content: NSString = NSString.init(string: model.content)
        let contentH :CGFloat = content.getHeightWith(UIFont.systemFont(ofSize: 14), constrainedTo: CGSize.init(width: Define.screenWidth() - 48, height: CGFloat.greatestFiniteMagnitude))
        self.contentL.snp.updateConstraints { (make) in
            make.height.equalTo(contentH)
        }

        self.commentMArr = CommentM.mj_objectArray(withKeyValuesArray: model.comment)
        let height = CGFloat((model.comment.count + 1) * commentHeight)
        self.commentList.snp.updateConstraints { (make) in
            make.height.equalTo(height);
        }
        self.commentList.reloadData()
    }
    
    class func cellHeight(model:FriendCircleM) -> CGFloat {
        var height:CGFloat = 155.0
        if model.picture.isEmpty == false {
            height += Define.screenWidth()/2
            height += 15
        }
        if model.position.isEmpty {
            height -= 9
        }
        height += CGFloat(model.comment.count) * 30
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
        cell.textLabel?.snp.updateConstraints({ (make) in
            make.left.right.equalTo(0)
            make.centerY.equalTo(cell.contentView.snp.centerY)
        })
        let model:CommentM = self.commentMArr.object(at: indexPath.row) as! CommentM
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.text = model.nickname+": "+model.content
        let contentStr = model.nickname+": "+model.content
        let nickNameStr = model.nickname+": "
        let contentAttStr = NSMutableAttributedString.init(string: contentStr)
        contentAttStr.setAttributes([NSForegroundColorAttributeName:kColorGary,NSFontAttributeName:UIFont.systemFont(ofSize: 13)], range: NSMakeRange(0, nickNameStr.length))
        cell.textLabel?.attributedText = contentAttStr
        return cell
    }
}


/// UITableViewDelegate methods.
extension RecommendCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(commentHeight)
    }
}
