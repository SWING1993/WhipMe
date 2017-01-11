//
//  MeCecordController.swift
//  WhipMe
//
//  Created by Song on 2017/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SwiftyJSON

class MeLogCell: NormalCell {
    var logV: UIImageView = UIImageView.init()
    var label1: UILabel = UILabel.init()
    var label2: UILabel = UILabel.init()
    var doingL: UILabel = UILabel.init()
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        logV.image = UIImage.init(named: "camera_icon")
        self.bgView.addSubview(logV)
        logV.snp.makeConstraints({ (make) in
            make.height.width.equalTo(60)
            make.centerX.equalTo(self.bgView.snp.centerX)
            make.top.equalTo(25)
        })

        label1.text = "记录一下..."
        label1.textAlignment = .center
        label2.textColor = Define.kColorBlack()
        label1.font = UIFont.systemFont(ofSize: 16)
        self.bgView.addSubview(label1)
        label1.snp.makeConstraints({ (make) in
            make.top.equalTo(logV.snp.bottom).offset(15)
            make.left.right.equalTo(0)
            make.height.equalTo(25)
        })
        
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 10)
        label2.textColor = Define.kColorGary()
        self.bgView.addSubview(label2)
        label2.snp.makeConstraints({ (make) in
            make.top.equalTo(label1.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(25)
        })
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellReuseIdentifier() -> String {
        return "MeLogCell"
    }
    
    class func cellHeight() -> CGFloat {
        return 169;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class SuperviseCell: NormalCell {
    var avatarV: UIImageView = UIImageView.init()
    var titleL: UILabel = UILabel.init()
    var subTitleL: UILabel = UILabel.init()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.bgView.addSubview(avatarV)
        avatarV.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize.init(width: 40, height: 40))
            make.left.equalTo(self.bgView.snp.left).offset(10)
            make.centerY.equalTo(self.bgView.snp.centerY)
        })
        
        
        titleL.textAlignment = .left
        titleL.font = UIFont.systemFont(ofSize: 16)
        self.bgView.addSubview(titleL)
        titleL.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize.init(width: 150, height: 40))
            make.left.equalTo(avatarV.snp.right).offset(10)
            make.centerY.equalTo(self.bgView.snp.centerY)

        })
        
        subTitleL.textAlignment = .right
        subTitleL.font = UIFont.systemFont(ofSize: 13)
        self.bgView.addSubview(subTitleL)
        subTitleL.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize.init(width: 150, height: 40))
            make.right.equalTo(self.bgView.snp.right).offset(-10)
            make.centerY.equalTo(self.bgView.snp.centerY)
        })

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellReuseIdentifier() -> String {
        return "SuperviseCell"
    }
    
    class func cellHeight() -> CGFloat {
        return 59;
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class MeCecordController: UIViewController {
    var myWhipM: WhipM = WhipM()
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
        let params = ["taskId":self.myWhipM.taskId,"pageSize":"30","pageIndex":"1"]
        HttpAPIClient.apiClientPOST("queryRecordByTaskId", params: params, success: { (result) in
            if (result != nil) {
                print(result!)
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                let totalSize = json["data"][0]["totalSize"].intValue
                if ret != 0 {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    return
                }
                if totalSize > 0 {
                    let recordList = json["data"][0]["recordlist"].arrayObject
                    self.friendCircleModels = {
                        var temps: [FriendCircleM] = []
                        let tempArr = FriendCircleM.mj_objectArray(withKeyValuesArray: recordList)
                        for model in tempArr! {
                            temps.append(model as! FriendCircleM)
                        }
                        return temps
                    }()
                    for model in self.friendCircleModels {
                        let cellHeight = RecommendCell.cellHeight(model: model )
                        self.cellHeights.append(cellHeight)
                    }
                    self.recommendTable.reloadData()
                }
            }
        }) { (error) in
            print(error as Any);
        }
    }
    
    fileprivate func prepareTableView() {
        recommendTable.backgroundColor = kColorBackGround
        recommendTable.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.cellReuseIdentifier())
        recommendTable.register(MeLogCell.self, forCellReuseIdentifier: MeLogCell.cellReuseIdentifier())
        recommendTable.dataSource = self
        recommendTable.delegate = self
        recommendTable.separatorStyle = .none
        view.addSubview(recommendTable)
        recommendTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/// TableViewDataSource methods.
extension MeCecordController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return self.friendCircleModels.count
        }
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: MeLogCell = MeLogCell.init(style: UITableViewCellStyle.default, reuseIdentifier: MeLogCell.cellReuseIdentifier())
            if self.friendCircleModels.count > 0 {
                let model:FriendCircleM = self.friendCircleModels.first!
                cell.label2.text = "上次记录："+model.createDate
            } else {
                cell.label2.text = "暂无记录"
            }
            return cell
        } else if indexPath.section == 1 {
            let cell: SuperviseCell = SuperviseCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: SuperviseCell.cellReuseIdentifier())
            cell.avatarV.setImageWith(urlString: myWhipM.supervisorIcon, placeholderImage: "system_monitoring")
            cell.titleL.text =  myWhipM.supervisorName + "监督中"
            cell.subTitleL.text = "保证金："+String(describing: myWhipM.guarantee)+"元"
            return cell
        } else {
            let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
            let model:FriendCircleM = self.friendCircleModels[indexPath.row]
            cell.setRecommendData(model: model)
            return cell
        }
    }
}

/// UITableViewDelegate methods.
extension MeCecordController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return MeLogCell.cellHeight()
        } else if indexPath.section == 1 {
            return SuperviseCell.cellHeight()
        } else {
            return self.cellHeights[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let logC = LogController.init()
            logC.myWhipM = self.myWhipM;
            self.navigationController?.pushViewController(logC, animated: true)
        }
        
    }

}
