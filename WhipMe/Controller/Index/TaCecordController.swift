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
        let params = ["taskId":self.myWhipM.taskId,"pageSize":"30","pageIndex":"1"]
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
            make.bottom.equalTo(-60)
        }
        
        let bottomView = UIView()
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
        
        
        if self.myWhipM.accept == 2 {
            self.bottomView.isHidden = false
        } else {
            self.bottomView.isHidden = true
        }
            
        okBtn.bk_(whenTapped: {
            let param = ["userId":UserManager.shared.userId,
                         "taskId":self.myWhipM.taskId,
                         "result":"2"]
            HttpAPIClient.apiClientPOST("assessTask", params: param, success: { (result) in
                if let dataResult = result {
                    print(dataResult)
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
                print(error!)
                Tool.showHUDTip(tipStr: "网络不给力")
            }

        })
        
        notOkBtn.bk_(whenTapped: {
            let param = ["userId":UserManager.shared.userId,
                         "taskId":self.myWhipM.taskId,
                         "result":"1"]
            HttpAPIClient.apiClientPOST("assessTask", params: param, success: { (result) in
                if let dataResult = result {
                    print(dataResult)
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
                print(error!)
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
        headView.addSubview(avatarV)
        avatarV.snp.makeConstraints({ (make) in
            make.left.top.equalTo(18)
            make.height.width.equalTo(36)
        })
        
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
            make.right.equalTo(-15)
            make.left.equalTo(15)
            make.height.equalTo(contentH)
        })
        
        
        let line = UIView.init()
        line.backgroundColor = Define.RGBColorAlphaFloat(153, g: 153, b: 153, a: 0.5)
        headView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.top.equalTo(contentL.snp.bottom).offset(15)
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
        
        let rightLabel = UILabel()
        rightLabel.textColor = kColorGary
        rightLabel.textAlignment = .right
        rightLabel.font = UIFont.systemFont(ofSize: 13)
        headView.addSubview(rightLabel)
        rightLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.right.equalTo(-22)
            make.left.equalTo(leftLabel.snp.right).offset(10)
            make.height.equalTo(20)
        })
        
        avatarV.setImageWith(urlString: model.icon, placeholderImage: Define.kDefaultHeadStr())
        contentL.text = model.plan
        nickNameL.text = model.nickname
        topicL.text = "#"+model.themeName+"#"
        leftLabel.text = "自由服务费："+String(describing: model.guarantee)+"元"
        rightLabel.text = model.endDate+"结束"
        headView.frame = CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: (130+contentH))
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
