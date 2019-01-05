//
//  ClassifyController.swift
//  WhipMe
//
//  Created by Song on 2017/2/6.
//  Copyright © 2017年 -. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SwiftyJSON
import HandyJSON

class ClassifyController: UIViewController {

    var myWhipM: WhipM = WhipM()
    var isJoin: Bool = false
    fileprivate var recommendTable = UITableView.init()
    fileprivate var cellHeights: [CGFloat] = []
    fileprivate var friendCircleModels: [FriendCircleM] = [];
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.myWhipM.themeName
        self.view.backgroundColor = kColorBackGround
        prepareTableView()
    }
    
    fileprivate func setupRequest() {
        weak var weakSelf = self
        let params = ["themeId":self.myWhipM.themeId,"pageSize":"100","pageIndex":"1"]
        HttpAPIClient.apiClientPOST("queryListByThemeId", params: params, success: { (result) in
            if let dataResult = result {
                
                let json = JSON(dataResult)
                let ret  = json["data"][0]["ret"].intValue
                let totalSize = json["data"][0]["totalSize"].intValue
                if ret != 0 {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    return
                }
                if totalSize > 0 {
                    let recordList = json["data"][0]["list"].arrayValue
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
        recommendTable.backgroundColor = kColorBackGround
        recommendTable.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.cellReuseIdentifier())
        recommendTable.register(SuperviseCell.self, forCellReuseIdentifier: SuperviseCell.cellReuseIdentifier())
        recommendTable.dataSource = self
        recommendTable.delegate = self
        recommendTable.separatorStyle = .none
        view.addSubview(recommendTable)
        
        if isJoin {
            let headV = UIView()
            headV.backgroundColor = kColorWhite
            self.view.addSubview(headV)
            headV.snp.makeConstraints({ (make) in
                make.left.top.right.equalTo(0)
                make.height.equalTo(64)
            })
            let titleL = UILabel()
            titleL.font = UIFont.systemFont(ofSize: 16)
            titleL.textColor = kColorBlack
            titleL.text = self.myWhipM.themeName
            headV.addSubview(titleL)
            titleL.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 200, height: 30))
                make.left.equalTo(20)
                make.centerY.equalTo(headV.snp.centerY)
            })
            
            let joinBtn = UIButton()
            joinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            joinBtn.setTitle("加入", for: .normal)
            joinBtn.setTitleColor(kColorWhite, for: .normal)
            joinBtn.backgroundColor = kColorBlue
            joinBtn.layer.cornerRadius = 12.5
            joinBtn.layer.masksToBounds = true
            headV.addSubview(joinBtn)
            joinBtn.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 57, height: 25))
                make.right.equalTo(-20)
                make.centerY.equalTo(headV.snp.centerY)
            })
            joinBtn.bk_addEventHandler({ (sender) in
                let vc = AddWhipController.init()
                vc.queryHorThemeName = self.myWhipM.themeName
                vc.hideHot = true
                self.navigationController?.pushViewController(vc, animated: true)
            }, for: .touchUpInside)
            
            recommendTable.snp.makeConstraints { (make) in
                make.bottom.left.right.equalTo(0)
                make.top.equalTo(headV.snp.bottom)
            }
        } else {
            recommendTable.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
    }
    
    public func disMiss() {
        self.dismiss(animated: true) {        }
    }
    
    public func navBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/// TableViewDataSource methods.
extension ClassifyController: UITableViewDataSource {
    // Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.friendCircleModels.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SuperviseCell = SuperviseCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: SuperviseCell.cellReuseIdentifier())
            cell.avatarV.image = UIImage.init(named: "community_icon")
            cell.avatarV.snp.updateConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 25, height: 25))
            })
            cell.titleL.text =  "社区动态"
            return cell
        } else {
            let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
            let model:FriendCircleM = self.friendCircleModels[indexPath.row]
            cell.setRecommendData(model: model)
            cell.commentSuccess = { () -> Void in
                self.setupRequest()
            }
            return cell
        }
    }
}

/// UITableViewDelegate methods.
extension ClassifyController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return SuperviseCell.cellHeight()
        }
        return self.cellHeights[indexPath.row]
    }
}

