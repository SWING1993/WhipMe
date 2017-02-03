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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kColorWhite;
        
        avatarV.layer.masksToBounds = true
        avatarV.layer.cornerRadius = 34.5
        avatarV.contentMode = .scaleAspectFill
        self.addSubview(avatarV)
        avatarV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 69, height: 69))
            make.left.equalTo(35)
            make.top.equalTo(30)
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
        recordNumLabel.text = "已鞭挞" + self.myGrowM.recordNum + "次"
        if self.myGrowM.threeDay.count > 0 {
            if let threeDayDic = self.myGrowM.threeDay.first {
                if let picture = threeDayDic["picture"] {
                    print(picture)
                    self.firstPic.setImageWith(urlString: picture, placeholderImage: "")
                }
            }
        }
        
        if self.myGrowM.threeDay.count > 1 {
            let threeDayDic = self.myGrowM.threeDay[1]
            if let picture = threeDayDic["picture"] {
                self.secondPic.setImageWith(urlString: picture, placeholderImage: "")
            }
        }
        
        if self.myGrowM.threeDay.count > 2 {
            let threeDayDic = self.myGrowM.threeDay[2]
            if let picture = threeDayDic["picture"] {
                self.thirdPic.setImageWith(urlString: picture, placeholderImage: "")
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
        
        let rightBtn: UIBarButtonItem = UIBarButtonItem.init(title: "关注", style: .plain, target: self, action: #selector(QueryUserBlogC.follow))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func goBack() {
        self.dismiss(animated: true) { }
    }
    
    // 添加关注
    func follow() {
        if self.userBlogM.myGrow.count > 0 {
            if let growM = self.userBlogM.myGrow.first {
                let params = [
                    "focus":growM.creator,
                    "me":UserManager.shared.userId,
                    ]
                HttpAPIClient.apiClientPOST("queryUserBlog", params: params, success: { (result) in
                    if let dataResult = result {
                        print(dataResult)
                        let json = JSON(dataResult)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            Tool.showHUDTip(tipStr: "关注成功")
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            }
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
        if self.userBlogM.myGrow.count > 0 {
            if let growM = self.userBlogM.myGrow.first {
                self.userHeaderV.avatarV.setImageWith(urlString: growM.icon, placeholderImage: Define.kDefaultHeadStr())
            }
        }
        self.userHeaderV.fansNumL.text = self.userBlogM.userInfo["fansNum"]
        self.userHeaderV.focusNumL.text = self.userBlogM.userInfo["focusNum"]
        self.userHeaderV.signL.text = self.userBlogM.userInfo["sign"]
        self.myTable.tableHeaderView = self.userHeaderV
        
        self.myTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension QueryUserBlogC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
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
        if indexPath.section == 0 {
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
        if indexPath.section == 0 {
            let growM = self.userBlogM.myGrow[indexPath.row]
            return UserBlogCell.cellHeight(model: growM)
        }
        let growM = self.userBlogM.mySupervise[indexPath.row]
        return UserBlogCell.cellHeight(model: growM)
    }

}
