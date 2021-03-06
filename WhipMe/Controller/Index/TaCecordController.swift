//
//  TaCecordController.swift
//  WhipMe
//
//  Created by Song on 2016/11/24.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SwiftyJSON
import HandyJSON

class TaCecordController: UIViewController {

    var myWhipM: WhipM = WhipM()
    fileprivate var bottomView = UIView()
    fileprivate var recommendTable = UITableView.init()
    fileprivate var cellHeights: [CGFloat] = []
    fileprivate var friendCircleModels: [FriendCircleM] = [];
    fileprivate let pageView: UILabel = UILabel.init()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    func setup() {
        self.navigationItem.title = self.myWhipM.themeName
        self.view.backgroundColor = kColorBackGround
        prepareTableView()
    }
    
    fileprivate func setupRequest() {
        weak var weakSelf = self
        let params = ["taskId":self.myWhipM.taskId,"pageSize":"100","pageIndex":"1"]
        HttpAPIClient.apiClientPOST("queryRecordByTaskId", params: params, success: { (result) in
            if let dataResult = result {
                let json = JSON(dataResult)
                let ret  = json["data"][0]["ret"].intValue
                let totalSize = json["data"][0]["totalSize"].intValue
                weakSelf?.pageView.text = String(totalSize) + "次"
                if ret != 0 {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    return
                }
                if totalSize > 0 {
                    let recordList = json["data"][0]["recordlist"].arrayValue
                    weakSelf?.friendCircleModels = {
                        var temps: [FriendCircleM] = []
                        for json in recordList {
                            let jsonString = String(describing: json)
                            if let model = JSONDeserializer<FriendCircleM>.deserializeFrom(json: jsonString) {
                                temps.append(model)
                            }
                        }
                        return temps
                    }()
                    weakSelf?.cellHeights = {
                        var tempHeights:[CGFloat] = []
                        for model in self.friendCircleModels {
                            let cellHeight = RecommendCell.cellHeight(model: model )
                            tempHeights.append(cellHeight)
                        }
                        return tempHeights
                    }()
                    weakSelf?.recommendTable.reloadData()
                }
            }
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
        }
    }
    
    fileprivate func prepareTableView() {
        recommendTable.tableHeaderView = self.setupHeadView(model: self.myWhipM)
        recommendTable.backgroundColor = kColorBackGround
        recommendTable.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.cellReuseIdentifier())
        recommendTable.dataSource = self
        recommendTable.delegate = self
        recommendTable.separatorStyle = .none
        view.addSubview(recommendTable)
        recommendTable.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            if self.myWhipM.accept == 0 {
                make.bottom.equalTo(0)
            } else {
                make.bottom.equalTo(-60)
            }
        }
        
        bottomView.backgroundColor = kColorWhite
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.recommendTable.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        let okBtn = UIButton.init(type: .custom)
        okBtn.layer.masksToBounds = true
        okBtn.layer.cornerRadius = 17.5
        okBtn.setTitle("已完成", for: .normal)
        okBtn.backgroundColor = kColorBlue
        okBtn.setTitleColor(kColorWhite, for: .normal)
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bottomView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 35))
            make.centerY.equalTo(bottomView)
            make.right.equalTo(-15)
        }
        
        let notOkBtn = UIButton.init(type: .custom)
        notOkBtn.layer.masksToBounds = true
        notOkBtn.layer.cornerRadius = 17.5
        notOkBtn.setTitle("未完成", for: .normal)
        notOkBtn.backgroundColor = kColorLight
        notOkBtn.setTitleColor(kColorWhite, for: .normal)
        notOkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bottomView.addSubview(notOkBtn)
        notOkBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 35))
            make.centerY.equalTo(bottomView)
            make.right.equalTo(okBtn.snp.left).offset(-15)
        }
        
        
        if self.myWhipM.accept == 0 {
            bottomView.isHidden = true
        } else {
            bottomView.isHidden = false
        }
            
        okBtn.bk_(whenTapped: {
            let param = ["userId":UserManager.shared.userId,
                         "taskId":self.myWhipM.taskId,
                         "result":"2"]
            HttpAPIClient.apiClientPOST("assessTask", params: param, success: { (result) in
                if let dataResult = result {
                    
                    let json = JSON(dataResult)
                    let ret  = json["data"][0]["ret"].intValue
                    if ret == 0 {
                        Tool.showHUDTip(tipStr: "处理成功")
                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    }
                }
            }) { (error) in
                Tool.showHUDTip(tipStr: "网络不给力")
            }

        })
        
        notOkBtn.bk_(whenTapped: {
            let param = ["userId":UserManager.shared.userId,
                         "taskId":self.myWhipM.taskId,
                         "result":"1"]
            HttpAPIClient.apiClientPOST("assessTask", params: param, success: { (result) in
                if let dataResult = result {
                    
                    let json = JSON(dataResult)
                    let ret  = json["data"][0]["ret"].intValue
                    if ret == 0 {
                        Tool.showHUDTip(tipStr: "处理成功")
                        _ = self.navigationController?.popViewController(animated: true)
                    } else {
                        Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    }
                }
            }) { (error) in
                
                Tool.showHUDTip(tipStr: "网络不给力")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func setupHeadView(model: WhipM) -> UIView {
        let headView = NormalView()
        let avatarV: UIImageView = UIImageView.init()
        let nickNameL: UILabel = UILabel.init()
        let topicL: UILabel = UILabel.init()
        let contentL: UILabel = UILabel.init()
        
        avatarV.layer.cornerRadius = 36.0/2
        avatarV.layer.masksToBounds = true
        avatarV.isUserInteractionEnabled = true
        headView.addSubview(avatarV)
        avatarV.snp.makeConstraints({ (make) in
            make.left.top.equalTo(18)
            make.height.width.equalTo(36)
        })
        if model.creator.length > 2 {
            avatarV.bk_(whenTapped: { () -> Void in
                let hud = MBProgressHUD.showAdded(to: kKeyWindows!, animated: true)
                hud.label.text = "加载中..."
                let params = [
                    "userId":model.creator,
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
                                let queryUserBlogC = QueryUserBlogC.init()
                                queryUserBlogC.navigationItem.title = model.nickname
                                queryUserBlogC.userBlogM = userBlogM
                                let blogNav = UINavigationController.init(rootViewController: queryUserBlogC)
                                kKeyWindows?.rootViewController?.present(blogNav, animated: true, completion: {
                                    
                                })
                            }
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    hud.hide(animated: true)
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            })
        }

        
        nickNameL.font = UIFont.systemFont(ofSize: 16)
        headView.addSubview(nickNameL)
        nickNameL.snp.makeConstraints({ (make) in
            make.top.equalTo(avatarV.snp.top)
            make.left.equalTo(avatarV.snp.right).offset(9)
            make.width.equalTo(140)
            make.height.equalTo(18)
        })
        
        topicL.font = UIFont.systemFont(ofSize: 11)
        topicL.textColor = kColorGreen
        headView.addSubview(topicL)
        topicL.snp.makeConstraints({ (make) in
            make.top.equalTo(nickNameL.snp.bottom)
            make.left.equalTo(avatarV.snp.right).offset(9)
            make.width.equalTo(140)
            make.height.equalTo(18)
        })
        
        self.pageView.textColor = kColorGreen
        self.pageView.textAlignment = .right
        self.pageView.font = UIFont.systemFont(ofSize: 14)
        headView.addSubview(self.pageView)
        self.pageView.snp.makeConstraints({ (make) in
            make.centerY.equalTo(avatarV)
            make.right.equalTo(-18)
            make.width.equalTo(100)
            make.height.equalTo(18)
        })
        
        contentL.font = UIFont.systemFont(ofSize: 14)
        contentL.textColor = kColorGary
        contentL.numberOfLines = 0
        headView.addSubview(contentL)
        
        let content: NSString = NSString.init(string: model.plan)
        let contentH :CGFloat = content.getHeightWith(UIFont.systemFont(ofSize: 14), constrainedTo: CGSize.init(width: Define.screenWidth() - 48, height: CGFloat.greatestFiniteMagnitude))
        contentL.snp.makeConstraints({ (make) in
            make.top.equalTo(avatarV.snp.bottom).offset(15)
            make.right.equalTo(-22)
            make.left.equalTo(22)
            make.height.equalTo(contentH)
        })
        
        
        let timeLabel = UILabel()
        timeLabel.textColor = kColorGary
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        headView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(contentL.snp.bottom).offset(10)
            make.right.equalTo(-22)
            make.left.equalTo(22)
            make.height.equalTo(20)
        })
        
        let line = UIView.init()
        line.backgroundColor = Define.RGBColorAlphaFloat(153, g: 153, b: 153, a: 0.5)
        headView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }

        
        let leftLabel = UILabel()
        leftLabel.textColor = kColorRed
        leftLabel.textAlignment = .left
        leftLabel.font = UIFont.systemFont(ofSize: 13)
        headView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.left.equalTo(22)
            make.width.equalTo(140)
            make.height.equalTo(20)
        })
        
        let refuseBtn: UIButton = UIButton()
        let acceptBtn: UIButton = UIButton()
        
        acceptBtn.backgroundColor = kColorBlue
        acceptBtn.layer.cornerRadius = 11
        acceptBtn.layer.masksToBounds = true
        acceptBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        acceptBtn.setTitleColor(kColorWhite, for: .normal)
        acceptBtn.setTitle("接受", for: .normal)
        headView.addSubview(acceptBtn)
        acceptBtn.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(50)
            make.right.equalTo(-22)
            make.centerY.equalTo(leftLabel)
        }
        
        
        refuseBtn.backgroundColor = kColorGolden
        refuseBtn.layer.cornerRadius = 11
        refuseBtn.layer.masksToBounds = true
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        refuseBtn.setTitleColor(kColorWhite, for: .normal)
        refuseBtn.setTitle("拒绝", for: .normal)
        headView.addSubview(refuseBtn)
        refuseBtn.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(50)
            make.right.equalTo(acceptBtn.snp.left).offset(-12)
            make.centerY.equalTo(leftLabel)
        }
        
        // 拒绝
        refuseBtn.bk_(whenTapped: {
            if UserManager.shared.isManager == true {
                let param = ["supervisor":UserManager.shared.userId,
                             "supervisorName":UserManager.shared.nickname,
                             "supervisorIcon":UserManager.shared.icon,
                             "taskId":model.taskId,
                             "creator":model.nickname,
                             "creatorId":model.creator,
                             "accept":"1",
                             ]
                HttpAPIClient.apiClientPOST("adminHandleTask", params: param, success: { (result) in
                    if let dataResult = result {
                        let json = JSON(dataResult)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            _ = self.navigationController?.popViewController(animated: true)
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            } else {
                let param = ["userId":UserManager.shared.userId,
                             "taskId":model.taskId,
                             "accept":"1"]
                HttpAPIClient.apiClientPOST("handleTask", params: param, success: { (result) in
                    if let dataResult = result {
                        let json = JSON(dataResult)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            _ = self.navigationController?.popViewController(animated: true)
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            }
        })
//        "method":"adminHandleTask",
//        "param":{
//            "supervisor":"登录人ID",
//            "supervisorName":"登录人昵称",
//            "supervisorIcon":"登录人头像",
//            "taskId”:”任务ID",
//            "accept”:”接受还是拒绝（1：拒绝   2：接受）"
//            "creator”:”这个任务的创建人昵称"
//            "creatorId”:”这个任务的创建人ID"
//            
//        }

        // 同意
        acceptBtn.bk_(whenTapped: {
            if UserManager.shared.isManager == true {
                let param = ["supervisor":UserManager.shared.userId,
                             "supervisorName":UserManager.shared.nickname,
                             "supervisorIcon":UserManager.shared.icon,
                             "taskId":model.taskId,
                             "creator":model.nickname,
                             "creatorId":model.creator,
                             "accept":"2",
                             ]
                
                HttpAPIClient.apiClientPOST("adminHandleTask", params: param, success: { (result) in
                    if let dataResult = result {
                        let json = JSON(dataResult)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            _ = self.navigationController?.popViewController(animated: true)
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            } else {
                let param = ["userId":UserManager.shared.userId,
                             "taskId":model.taskId,
                             "accept":"2"]
                HttpAPIClient.apiClientPOST("handleTask", params: param, success: { (result) in
                    if let dataResult = result {
                        let json = JSON(dataResult)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            _ = self.navigationController?.popViewController(animated: true)
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            }
        })

        
        avatarV.setImageWith(urlString: model.icon, placeholderImage: Define.kDefaultHeadStr())
        contentL.text = model.plan
        nickNameL.text = model.nickname
        topicL.text = "#"+model.themeName+"#"
        leftLabel.text = "保证金："+String(describing: model.guarantee)+"元"
        timeLabel.text = "开始:"+model.startDate+"/"+"结束:"+model.endDate
        headView.frame = CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: (155+contentH))
        if model.accept == 0 {
            acceptBtn.isHidden = false
            refuseBtn.isHidden = false
        } else {
            acceptBtn.isHidden = true
            refuseBtn.isHidden = true
        }
        return headView
    }
}

/// TableViewDataSource methods.
extension TaCecordController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendCircleModels.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
        let model:FriendCircleM = self.friendCircleModels[indexPath.row]
        cell.setRecommendData(model: model)
        cell.commentSuccess = { () -> Void in
            self.setupRequest()
        }
        return cell
    }
}

/// UITableViewDelegate methods.
extension TaCecordController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeights[indexPath.row]
    }
}
