//
//  QueryUserBlogC.swift
//  WhipMe
//
//  Created by Song on 2017/1/19.
//  Copyright © 2017年 -. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

let kUserHeight: CGFloat = 180

class GrowM: HandyJSON {
    var creator: String = ""
    var endDate: String = ""
    var icon: String = ""
    var nickname: String = ""
    var recordNum: String = ""
    var startDate: String = ""
    var taskId: String = ""
    var themeId: String = ""
    var themeName: String = ""
    var threeDay: [Dictionary<String,String>] = []
    
    required init() {}
}

class UserBlogM: HandyJSON {
    var myGrow: [GrowM] = []
    var mySupervise: [GrowM] = []
    var userInfo: [String: String] = [:]
    
    required init() {}

}

class UserBlogHeaderV: UIView {
    
    var avatarV = UIImageView()
    var signL = UILabel()
    var focusNumL = UILabel()
    var fansNumL = UILabel()
    var sexImageV = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kColorWhite;
        
        avatarV.layer.masksToBounds = true
        avatarV.layer.cornerRadius = 34.5
        avatarV.contentMode = .scaleAspectFill
        avatarV.isUserInteractionEnabled = true
        self.addSubview(avatarV)
        avatarV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 69, height: 69))
            make.left.equalTo(35)
            make.top.equalTo(30)
        }
        avatarV.bk_(whenTapped: {
            let brower = MJPhotoBrowser()
            let photo = MJPhoto()
            photo.srcImageView = self.avatarV
            brower.photos = NSMutableArray.init(object: photo)
            brower.currentPhotoIndex = 0
            brower.show()
        })
        
        self.addSubview(sexImageV)
        sexImageV.snp.makeConstraints { (make) in
            make.width.height.equalTo(17)
            make.trailing.equalTo(avatarV)
            make.bottom.equalTo(avatarV)
        }
        
        signL.textColor = kColorTextLight
        signL.font = UIFont.systemFont(ofSize: 13)
        signL.numberOfLines = 0
        signL.adjustsFontSizeToFitWidth = true
        self.addSubview(signL)
        signL.snp.makeConstraints { (make) in
            make.left.equalTo(avatarV)
            make.right.equalTo(-35)
            make.top.equalTo(avatarV.snp.bottom).offset(20)
            make.bottom.equalTo(self).offset(-20)
        }
        
        let lineCenterX = Define.screenWidth() * 3/4
        let lineView = UIView()
        lineView.backgroundColor = kColorLine
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.height.equalTo(50)
            make.centerX.equalTo(lineCenterX)
            make.centerY.equalTo(avatarV.snp.centerY)
        }
        
        focusNumL.textColor = kColorRed
        focusNumL.font = UIFont.systemFont(ofSize: 15)
        focusNumL.textAlignment = .center
        self.addSubview(focusNumL)
        focusNumL.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 20))
            make.top.equalTo(lineView.snp.top)
            make.right.equalTo(lineView.snp.left)
        }
        
        fansNumL.textColor = kColorRed
        fansNumL.font = UIFont.systemFont(ofSize: 15)
        fansNumL.textAlignment = .center
        self.addSubview(fansNumL)
        fansNumL.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 20))
            make.top.equalTo(lineView.snp.top)
            make.left.equalTo(lineView.snp.right)
        }
        
        let focusTL = UILabel()
        focusTL.textColor = kColorGary
        focusTL.font = UIFont.systemFont(ofSize: 15)
        focusTL.textAlignment = .center
        focusTL.text = "关注"
        self.addSubview(focusTL)
        focusTL.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 20))
            make.bottom.equalTo(lineView.snp.bottom)
            make.right.equalTo(lineView.snp.left)
        }
        
        let fansTL = UILabel()
        fansTL.textColor = kColorGary
        fansTL.font = UIFont.systemFont(ofSize: 15)
        fansTL.textAlignment = .center
        fansTL.text = "粉丝"
        self.addSubview(fansTL)
        fansTL.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 20))
            make.bottom.equalTo(lineView.snp.bottom)
            make.left.equalTo(lineView.snp.right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class UserBlogCell: NormalCell {
    
    var myGrowM = GrowM()
    var themeLabel = UILabel()
    var dateLabel = UILabel()
    var recordNumLabel = UILabel()
    var firstPic = UIImageView()
    var secondPic = UIImageView()
    var thirdPic = UIImageView()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        themeLabel.textColor = kColorBlack
        themeLabel.font = UIFont.systemFont(ofSize: 16)
        self.bgView.addSubview(themeLabel)
        themeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(20)
            make.top.equalTo(10)
        }
        
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = UIFont.systemFont(ofSize: 11)
        dateLabel.textColor = kColorTextLight
        self.bgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(themeLabel.snp.left)
            make.height.equalTo(themeLabel.snp.height)
            make.top.equalTo(themeLabel.snp.bottom).offset(10)
            make.width.equalTo(150)
        }
        
        recordNumLabel.textAlignment = .right
        recordNumLabel.textColor = kColorTextLight
        recordNumLabel.font = UIFont.systemFont(ofSize: 12)
        self.bgView.addSubview(recordNumLabel)
        recordNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(themeLabel.snp.right)
            make.height.equalTo(themeLabel.snp.height)
            make.top.equalTo(themeLabel.snp.bottom).offset(10)
            make.width.equalTo(150)
        }
//        let space = 9
        let pic_W_H = (Define.screenWidth() - 66)/3
      
        secondPic.contentMode = .scaleToFill
        self.bgView.addSubview(secondPic)
        secondPic.snp.makeConstraints { (make) in
            make.top.equalTo(recordNumLabel.snp.bottom).offset(10)
            make.centerX.equalTo(self.bgView.snp.centerX)
            make.size.equalTo(CGSize.init(width: pic_W_H, height: pic_W_H))
        }
        
        firstPic.contentMode = .scaleToFill
        self.bgView.addSubview(firstPic)
        firstPic.snp.makeConstraints { (make) in
            make.top.equalTo(secondPic)
            make.left.equalTo(15)
            make.size.equalTo(CGSize.init(width: pic_W_H, height: pic_W_H))
        }
        
        thirdPic.contentMode = .scaleToFill
        self.bgView.addSubview(thirdPic)
        thirdPic.snp.makeConstraints { (make) in
            make.top.equalTo(secondPic)
            make.right.equalTo(-15)
            make.size.equalTo(CGSize.init(width: pic_W_H, height: pic_W_H))
        }
    }
    
    func setMyGrowMWith(model: GrowM) {
        self.myGrowM = model
        themeLabel.text = self.myGrowM.themeName
        dateLabel.text = self.myGrowM.startDate + " - " + self.myGrowM.endDate
        recordNumLabel.text = "已监督" + self.myGrowM.recordNum + "次"
        if self.myGrowM.threeDay.count > 0 {
            if let threeDayDic = self.myGrowM.threeDay.first {
                if let picture = threeDayDic["picture"] {
                    self.firstPic.setImageWith(urlString: picture, placeholderImage: "nilTouSu")
                }
            }
        }
        
        if self.myGrowM.threeDay.count > 1 {
            let threeDayDic = self.myGrowM.threeDay[1]
            if let picture = threeDayDic["picture"] {
                self.secondPic.setImageWith(urlString: picture, placeholderImage: "nilTouSu")
            }
        }
        
        if self.myGrowM.threeDay.count > 2 {
            let threeDayDic = self.myGrowM.threeDay[2]
            if let picture = threeDayDic["picture"] {
                self.thirdPic.setImageWith(urlString: picture, placeholderImage: "nilTouSu")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func cellHeight(model:GrowM) -> CGFloat {
        let pic_W_H = (Define.screenWidth() - 66)/3
        var height:CGFloat = 70
        if model.threeDay.count > 0 {
            height = height + pic_W_H + 20
            return height
        }
        return height
    }

    class func cellReuseIdentifier() -> String {
        return "QueryUserBlogCell"
    }
}

class QueryUserBlogC: UIViewController {

    var userBlogM = UserBlogM.init()
    var myTable = UITableView()
    var userHeaderV = UserBlogHeaderV()
    var isFocus : Bool = false
    var fansNum : Int = 0
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.setup()
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = kColorBackGround
        self.prepareViews()
        
        let backBtn: UIBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(QueryUserBlogC.goBack))
        self.navigationItem.leftBarButtonItem = backBtn
    }
    
    func resetFollowBtn() {
        let rightBtn: UIBarButtonItem
        if self.isFocus {
            rightBtn = self.cancelFocusBtn()
        } else {
            rightBtn = self.focusBtn()
        }
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func focusBtn() -> UIBarButtonItem {
        return UIBarButtonItem.init(title: "加关注", style: .plain, target: self, action: #selector(QueryUserBlogC.follow))
    }
    
    func cancelFocusBtn() -> UIBarButtonItem {
        return UIBarButtonItem.init(title: "取消关注", style: .plain, target: self, action: #selector(QueryUserBlogC.cancelFollow))
    }
    
    func goBack() {
        if ((self.navigationController?.viewControllers.count)! > 1) {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true) { }
        }
    }
    
    func clickWithChatMsg() {
//        #bugbug
        if let userId = self.userBlogM.userInfo["userId"] {
            let controller: JCHATConversationViewController = JCHATConversationViewController()
            controller.superViewController = self
            controller.hidesBottomBarWhenPushed = true
            JMSGConversation.createSingleConversation(withUsername: userId, completionHandler: { (resultObject, error) in
                if (error == nil) {
                    controller.conversation = resultObject as! JMSGConversation!
                    let chatNav = UINavigationController.init(rootViewController: controller)
                    self.present(chatNav, animated: true, completion: {
                        
                    })
                }
            })
        }
    }
    
    // 添加关注
    func follow() {
        if let userId = self.userBlogM.userInfo["userId"] {
            let params = [
                "focus":userId,
                "me":UserManager.shared.userId,
                "nickname":UserManager.shared.nickname
            ]
            HttpAPIClient.apiClientPOST("focusUser", params: params, success: { (result) in
                if let dataResult = result {
                    let json = JSON(dataResult)
                    let ret  = json["data"][0]["ret"].intValue
                    if ret == 0 {
                        Tool.showHUDTip(tipStr: "关注成功")
                        self.isFocus = true
                        self.resetFollowBtn()
                        self.fansNum = self.fansNum + 1
                        self.userHeaderV.fansNumL.text = String(self.fansNum)
                    } else {
                        Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    }
                }
            }) { (error) in
                Tool.showHUDTip(tipStr: "网络不给力")
            }
        }
    }
    
    func cancelFollow() {
        if let userId = self.userBlogM.userInfo["userId"] {
            let params = [
                "userId":userId,
                "me":UserManager.shared.userId
            ]
            HttpAPIClient.apiClientPOST("cancelUser", params: params, success: { (result) in
                if let dataResult = result {
                    
                    let json = JSON(dataResult)
                    let ret  = json["data"][0]["ret"].intValue
                    if ret == 0 {
                        Tool.showHUDTip(tipStr: "取消关注成功")
                        self.isFocus = false
                        self.resetFollowBtn()
                        self.fansNum = self.fansNum - 1
                        self.userHeaderV.fansNumL.text = String(self.fansNum)
                        
                    } else {
                        Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    }
                }
            }) { (error) in
                Tool.showHUDTip(tipStr: "网络不给力")
            }
        }
    }
    
    open func queryByUserBlog(userNo: String) {
        if (NSString.isBlankString(userNo)) {
            return;
        }
        let hud = MBProgressHUD.showAdded(to: kKeyWindows!, animated: true)
        hud.label.text = "加载中..."
        let params = [
            "userId":userNo,
            "loginId":UserManager.shared.userId,
            ]
        HttpAPIClient.apiClientPOST("queryUserBlog", params: params, success: { (result) in
            hud.hide(animated: true)
            if let dataResult = result {
                let json = JSON(dataResult)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let dataJson = json["data"][0]
                    let string = String(describing: dataJson)
                    
                    if let userBlogM = JSONDeserializer<UserBlogM>.deserializeFrom(json: string) {
                        self.userBlogM = userBlogM
                        
                        if let icon = self.userBlogM.userInfo["icon"] {
                            self.userHeaderV.avatarV.setImageWith(urlString: icon, placeholderImage: Define.kDefaultHeadStr())
                        }
                        
                        if self.userBlogM.userInfo["focus"] == "0" {
                            self.isFocus = false
                            self.resetFollowBtn()
                        } else {
                            self.isFocus = true
                            self.resetFollowBtn()
                        }
                        
                        if self.userBlogM.userInfo["sex"] == "1" {
                            self.userHeaderV.sexImageV.image = UIImage.init(named: "gender-m")
                        } else {
                            self.userHeaderV.sexImageV.image = UIImage.init(named: "gender-w")
                        }
                        self.userHeaderV.fansNumL.text = self.userBlogM.userInfo["fansNum"]
                        self.userHeaderV.focusNumL.text = self.userBlogM.userInfo["focusNum"]
                        self.userHeaderV.signL.text = self.userBlogM.userInfo["sign"]
                        self.fansNum = Int(self.userBlogM.userInfo["fansNum"]!)!
                        self.myTable.reloadData()
                    }
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            hud.hide(animated: true)
            Tool.showHUDTip(tipStr: "网络不给力")
        }
        
    }
    

    fileprivate func prepareViews() {
        
        self.myTable.backgroundColor = kColorBackGround
        self.myTable.separatorStyle = .none
        self.myTable.register(UserBlogCell.self, forCellReuseIdentifier: UserBlogCell.cellReuseIdentifier())
        self.myTable.dataSource = self
        self.myTable.delegate = self
        self.view.addSubview(self.myTable)
        
        self.userHeaderV.frame = CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: kUserHeight)
        if let icon = self.userBlogM.userInfo["icon"] {
            self.userHeaderV.avatarV.setImageWith(urlString: icon, placeholderImage: Define.kDefaultHeadStr())
        }
        
        if self.userBlogM.userInfo["focus"] == "0" {
            self.isFocus = false
            self.resetFollowBtn()
        } else {
            self.isFocus = true
            self.resetFollowBtn()
        }
        if self.userBlogM.userInfo["sex"] == "1" {
            self.userHeaderV.sexImageV.image = UIImage.init(named: "gender-m")
        } else {
            self.userHeaderV.sexImageV.image = UIImage.init(named: "gender-w")
        }
        self.userHeaderV.fansNumL.text = self.userBlogM.userInfo["fansNum"]
        self.userHeaderV.focusNumL.text = self.userBlogM.userInfo["focusNum"]
        self.userHeaderV.signL.text = self.userBlogM.userInfo["sign"]

        if let num = self.userBlogM.userInfo["fansNum"] {
            if let numInt = Int(num) {
                self.fansNum = Int(numInt)
            }
        }

        self.myTable.tableHeaderView = self.userHeaderV
        
        self.myTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let btnChatMsg = UIButton.init(type: UIButtonType.custom)
        btnChatMsg.backgroundColor = UIColor.clear
        btnChatMsg.addTarget(self, action: #selector(clickWithChatMsg), for: UIControlEvents.touchUpInside)
        btnChatMsg.setImage(UIImage.init(named: "user_chat_msg"), for: UIControlState.normal)
        btnChatMsg.adjustsImageWhenHighlighted = false
        self.view.addSubview(btnChatMsg)
        btnChatMsg.snp.updateConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 54.0, height: 54.0))
            make.bottom.equalTo(self.view).offset(-20.0)
            make.right.equalTo(self.view).offset(-10.0)
        }
        // 自己锝隐藏
        if let userId = self.userBlogM.userInfo["userId"] {
            if (UserManager.shared.userId == userId) {
                btnChatMsg.isHidden = true
            } else {
                btnChatMsg.isHidden = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension QueryUserBlogC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return self.userBlogM.myGrow.count
        } else {
            return self.userBlogM.mySupervise.count
        }
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserBlogCell = UserBlogCell.init(style: UITableViewCellStyle.default, reuseIdentifier: UserBlogCell.cellReuseIdentifier())
        if indexPath.section == 1 {
            let growM = self.userBlogM.myGrow[indexPath.row]
            cell.setMyGrowMWith(model: growM)
        } else {
            let growM = self.userBlogM.mySupervise[indexPath.row]
            cell.setMyGrowMWith(model: growM)
        }
        return cell
    }
}

extension QueryUserBlogC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            let growM = self.userBlogM.myGrow[indexPath.row]
            return UserBlogCell.cellHeight(model: growM)
        }
        let growM = self.userBlogM.mySupervise[indexPath.row]
        return UserBlogCell.cellHeight(model: growM)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var growM : GrowM = GrowM()
        var control_title : String = ""
        if indexPath.section == 1 {
            growM = self.userBlogM.myGrow[indexPath.row]
            control_title = "历史养成"
        } else {
            growM = self.userBlogM.mySupervise[indexPath.row]
            control_title = "历史监督"
        }
        
        let taskDetailVC = TaskDetailController()
        let whipM: WhipM = WhipM()
        whipM.taskId = growM.taskId
        whipM.themeName = growM.themeName
        taskDetailVC.myWhipM = whipM
        taskDetailVC.navigationItem.title = control_title
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
