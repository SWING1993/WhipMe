//
//  IndexViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SwiftyJSON
import MJRefresh
import HandyJSON

class WhipM: NSObject {
    
    var accept: Int = 0
    var type: Int = 0
    var guarantee: CGFloat = 0.00
    var recordNum:Int = 0
    var record: Bool = false
    var result: Int = 0
    
    var createDate: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var clockTime: String = ""
    
    var creator: String = ""
    var icon: String = ""
    var plan: String = ""
    
    var nickname: String = ""
    var taskId: String = ""
    var themeIcon: String = ""
    var themeId: String = ""
    var themeName: String = ""
    
    var supervisor: String = ""
    var supervisorName: String = ""
    var supervisorIcon: String = ""
}

class WhipMeCell: UITableViewCell {
    
    
    var headV: UIImageView = UIImageView()
    var themeV: UIImageView = UIImageView()
    
    var themeL: UILabel = UILabel()
    var goingL: UILabel = UILabel()
    
    var subTitle: UILabel = UILabel()
    
    var guaranteeL: UILabel = UILabel()
    var refuseBtn: UIButton = UIButton()
    var acceptBtn: UIButton = UIButton()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = kColorWhite
        
        headV.layer.cornerRadius = 40/2
        headV.layer.masksToBounds = true
        headV.isUserInteractionEnabled = true
        self.contentView .addSubview(headV)
        headV.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(15)
            make.right.equalTo(-9)
        }
        
        self.contentView .addSubview(themeV)
        themeV.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.centerY.equalTo(headV.snp.centerY)
            make.left.equalTo(18)
        }
        
        themeL.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(themeL)
        themeL.snp.makeConstraints { (make) in
            make.left.equalTo(themeV.snp.right).offset(16)
            make.top.equalTo(headV.snp.top)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
        
        goingL.font = UIFont.systemFont(ofSize: 10)
        goingL.layer.masksToBounds = true
        goingL.layer.cornerRadius = 7
        goingL.textColor = kColorWhite
        goingL.textAlignment = .center
        self.contentView.addSubview(goingL)
        goingL.snp.makeConstraints { (make) in
            make.left.equalTo(themeL.snp.right).offset(7)
            make.centerY.equalTo(themeL)
            make.height.equalTo(14)
            make.width.equalTo(40)
        }
        
        subTitle.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(subTitle)
        subTitle.snp.makeConstraints { (make) in
            make.left.equalTo(themeV.snp.right).offset(16)
            make.top.equalTo(themeL.snp.bottom)
            make.height.equalTo(themeL)
            make.width.equalTo(200)
        }
    }
    
    func config() {
        let line: UIView = UIView.init()
        line.backgroundColor = Define.RGBColorAlphaFloat(153, g: 153, b: 153, a: 0.5)
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(themeL)
            make.right.equalTo(-3)
            make.height.equalTo(0.5)
            make.top.equalTo(75.5)
        }
        
        guaranteeL.font = UIFont.systemFont(ofSize: 10)
        guaranteeL.textColor = kColorRed
        self.contentView.addSubview(guaranteeL)
        guaranteeL.snp.makeConstraints { (make) in
            make.left.equalTo(line)
            make.height.equalTo(22)
            make.top.equalTo(line.snp.bottom).offset(11)
            make.width.equalTo(100)
        }
        
        
        acceptBtn.backgroundColor = kColorBlue
        acceptBtn.layer.cornerRadius = 11
        acceptBtn.layer.masksToBounds = true
        acceptBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        acceptBtn.setTitleColor(kColorWhite, for: .normal)
        acceptBtn.setTitle("接受", for: .normal)
        self.contentView.addSubview(acceptBtn)
        acceptBtn.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(50)
            make.right.equalTo(-9)
            make.centerY.equalTo(guaranteeL)
        }
        
        
        refuseBtn.backgroundColor = kColorGolden
        refuseBtn.layer.cornerRadius = 11
        refuseBtn.layer.masksToBounds = true
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        refuseBtn.setTitleColor(kColorWhite, for: .normal)
        refuseBtn.setTitle("拒绝", for: .normal)
        self.contentView.addSubview(refuseBtn)
        refuseBtn.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(50)
            make.right.equalTo(acceptBtn.snp.left).offset(-12)
            make.centerY.equalTo(guaranteeL)
        }
        
    
    }
    
    class func whipOtherCellHeight(model:WhipM) -> CGFloat {
        var height: CGFloat = 75.0
        if model.accept == 0 {
            height += 44
        }
        return height
    }
    
    class func whipMeCellHeight() -> CGFloat {
        return 75.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WhipCell: UITableViewCell {
    
    var bgView: UIView = UIView()
    var whipMeTable: UITableView = UITableView()
    
    lazy var modelArray: NSArray = {
        return NSArray()
    }()
    
    var myReuseIdentifier: String = ""
    
    var checkPlan:((IndexPath) -> Void)?
    var needReload:(() -> Void)?

    var sectionHArr_Me: NSArray = NSArray.init()
    var sectionHArr_Other: NSArray = NSArray.init()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = Define.kColorBackGround()
        self.myReuseIdentifier = reuseIdentifier!
        
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 5.0
        bgView.layer.masksToBounds = true
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(21)
            make.bottom.equalTo(kBottomMargin)
            make.left.equalTo(kLeftMargin)
            make.right.equalTo(kRightMargin)
        }
        
        let tip = UILabel.init()
        
        if reuseIdentifier == WhipCell.whipMeReuseIdentifier() {
            tip.text = "速速花"
            tip.backgroundColor = kColorBlack
        } else {
            tip.text = "速速花"
            tip.backgroundColor = kColorRed
        }
       
        tip.textColor = UIColor.white
        tip.font = UIFont.systemFont(ofSize: 10)
        tip.textAlignment = .center
        tip.layer.masksToBounds = true
        tip.layer.cornerRadius = 36/2
        self.addSubview(tip)
        tip.snp.makeConstraints { (make) in
            make.height.width.equalTo(36)
            make.top.equalTo(8)
            make.left.equalTo(14.5)
        }
       
        whipMeTable.isScrollEnabled = false
        whipMeTable.showsVerticalScrollIndicator = false
        whipMeTable.delegate = self
        whipMeTable.dataSource = self
        bgView.addSubview(whipMeTable)
        whipMeTable.snp.makeConstraints({ (make) in
            make.width.equalTo(bgView)
            make.left.equalTo(0)
            make.top.equalTo(tip.snp.bottom).offset(10)
            make.bottom.equalTo(0)
        })
    }

    func setDataWith(array: NSArray) {
        self.modelArray = array
        self.sectionHArr_Other = {
            let tempArr: NSMutableArray = NSMutableArray.init()
            for whipM in array {
                let height:CGFloat = WhipMeCell.whipOtherCellHeight(model: whipM as! WhipM)
                tempArr.add(height)
            }
            return tempArr.copy() as! NSArray
        }()

        self.sectionHArr_Me = {
            let tempArr: NSMutableArray = NSMutableArray.init()
            for _ in array {
                let height:CGFloat = WhipMeCell.whipMeCellHeight()
                tempArr.add(height)
            }
            return tempArr.copy() as! NSArray
        }()
        
        self.whipMeTable.reloadData()
    }
    
    class func cellHeight(array: NSArray, type: String) -> CGFloat {
        var height: CGFloat = 54.0
        if type == whipOtherReuseIdentifier() {
            for whipM in array {
                height += WhipMeCell.whipOtherCellHeight(model: whipM as! WhipM)
            }
        }
        else {
            for _ in array {
                height += WhipMeCell.whipMeCellHeight()
            }
        }
        return height
    }
    
    class func whipMeReuseIdentifier() -> String {
        return "WhipMeCell"
    }
    
    class func whipOtherReuseIdentifier() -> String {
        return "WhipOtherCell"
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func needReloaTW() {
        NotificationCenter.default.post(name: NSNotification.Name("needReloaTW"), object: nil)
    }
}

extension WhipCell: UITableViewDataSource {
    // Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WhipMeCell = WhipMeCell.init(style: .subtitle, reuseIdentifier: self.myReuseIdentifier)
        let whipM: WhipM = self.modelArray.object(at: indexPath.row) as! WhipM
        cell.themeV.setImageWith(urlString: whipM.themeIcon, placeholderImage: "zaoqi")
        cell.themeL.text = whipM.themeName
        let themeLWidth = whipM.themeName.getWidth(font: UIFont.systemFont(ofSize: 14), height: 20)
        cell.themeL.snp.updateConstraints { (make) in
            make.width.equalTo(themeLWidth)
        }
        
        if self.myReuseIdentifier == WhipCell.whipOtherReuseIdentifier() {
            cell.headV.setImageWith(urlString: whipM.icon, placeholderImage: "")
            cell.headV.bk_(whenTapped: { () -> Void in
                if whipM.creator.length > 2 {
                    let hud = MBProgressHUD.showAdded(to: kKeyWindows!, animated: true)
                    hud.label.text = "加载中..."
                    let params = [
                        "userId":whipM.creator,
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
                                    queryUserBlogC.navigationItem.title = whipM.nickname
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
                }
            })

            // 拒绝
            cell.refuseBtn.bk_(whenTapped: {
                if UserManager.shared.isManager == true {
                    let param = ["supervisor":UserManager.shared.userId,
                                 "supervisorName":UserManager.shared.nickname,
                                 "supervisorIcon":UserManager.shared.icon,
                                 "taskId":whipM.taskId,
                                 "creator":whipM.nickname,
                                 "creatorId":whipM.creator,
                                 "accept":"1",
                                 ]
                    HttpAPIClient.apiClientPOST("adminHandleTask", params: param, success: { (result) in
                        if let dataResult = result {
                            let json = JSON(dataResult)
                            let ret  = json["data"][0]["ret"].intValue
                            if ret == 0 {
                               self.needReloaTW()
                            } else {
                                Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                            }
                        }
                    }) { (error) in
                        Tool.showHUDTip(tipStr: "网络不给力")
                    }
                } else {
                    let param = ["userId":UserManager.shared.userId,
                                 "taskId":whipM.taskId,
                                 "accept":"1"]
                    HttpAPIClient.apiClientPOST("handleTask", params: param, success: { (result) in
                        if let dataResult = result {
                            let json = JSON(dataResult)
                            let ret  = json["data"][0]["ret"].intValue
                            if ret == 0 {
                                self.needReloaTW()
                            } else {
                                Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                            }
                        }
                    }) { (error) in
                        Tool.showHUDTip(tipStr: "网络不给力")
                    }
                }
            })
            
            // 同意
            cell.acceptBtn.bk_(whenTapped: {
                if UserManager.shared.isManager == true {
                    let param = ["supervisor":UserManager.shared.userId,
                                 "supervisorName":UserManager.shared.nickname,
                                 "supervisorIcon":UserManager.shared.icon,
                                 "taskId":whipM.taskId,
                                 "creator":whipM.nickname,
                                 "creatorId":whipM.creator,
                                 "accept":"2",
                                 ]
                    HttpAPIClient.apiClientPOST("adminHandleTask", params: param, success: { (result) in
                        if let dataResult = result {
                            let json = JSON(dataResult)
                            let ret  = json["data"][0]["ret"].intValue
                            if ret == 0 {
                                self.needReloaTW()
                            } else {
                                Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                            }
                        }
                    }) { (error) in
                        Tool.showHUDTip(tipStr: "网络不给力")
                    }
                } else {
                    let param = ["userId":UserManager.shared.userId,
                                 "taskId":whipM.taskId,
                                 "accept":"2"]
                    HttpAPIClient.apiClientPOST("handleTask", params: param, success: { (result) in
                        if let dataResult = result {
                            let json = JSON(dataResult)
                            let ret  = json["data"][0]["ret"].intValue
                            if ret == 0 {
                                self.needReloaTW()
                            } else {
                                Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                            }
                        }
                    }) { (error) in
                        Tool.showHUDTip(tipStr: "网络不给力")
                    }
                }
            })

            cell.subTitle.textColor = kColorGary
            if whipM.accept == 0 {
                cell.subTitle.text = "开始:"+whipM.startDate+"/结束:"+whipM.endDate
                cell.config()
                cell.guaranteeL.text = "保证金："+String(describing: whipM.guarantee)+"元"
            } else if (whipM.accept == 1){
                cell.subTitle.text = "开始:"+whipM.startDate+"/结束:"+whipM.endDate
                cell.goingL.text = "已拒绝"
                cell.subTitle.text = "开始:"+whipM.startDate+"/结束:"+whipM.endDate
            } else {
                cell.subTitle.text = "被监督"+String(describing: whipM.recordNum)+"次"
                if whipM.result == 2 {
                    cell.goingL.text = "已结束"
                    cell.goingL.backgroundColor = kColorRed

                } else {
                    cell.goingL.text = "进行中"
                    cell.goingL.backgroundColor = kColorGreen
                }
            }
        } else {
            cell.headV.setImageWith(urlString: whipM.supervisorIcon, placeholderImage: "")
            cell.headV.bk_(whenTapped: { () -> Void in
                if whipM.supervisor.length > 2 {
                    let hud = MBProgressHUD.showAdded(to: kKeyWindows!, animated: true)
                    hud.label.text = "加载中..."
                    let params = [
                        "userId":whipM.supervisor,
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
                                    queryUserBlogC.navigationItem.title = whipM.supervisorName
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
                }
            })

            cell.subTitle.textColor = kColorBlue
            let label = UILabel()
            label.adjustsFontSizeToFitWidth = true
            label.textColor = kColorGary
            label.text = "开始：" + whipM.startDate + "/结束：" + whipM.endDate
            label.font = cell.subTitle.font
            cell.contentView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.size.equalTo(cell.subTitle)
                make.left.equalTo(cell.subTitle)
                make.top.equalTo(cell.subTitle.snp.bottom).offset(-3)
            })
            if whipM.accept == 0 {
                if UserManager.shared.isManager == true {
                    cell.goingL.isHidden = true
                }
                cell.goingL.text = "待确认"
                cell.subTitle.text = "保证金:"+String(describing: whipM.guarantee)+"元"
                cell.goingL.backgroundColor = kColorYellow

            } else if whipM.accept == 1 {
                cell.goingL.text = "已拒绝"
                cell.subTitle.text = "保证金:"+String(describing: whipM.guarantee)+"元"
                cell.goingL.backgroundColor = kColorRed
            } else {
                cell.goingL.isHidden = true
                cell.subTitle.text = "被监督"+String(describing: whipM.recordNum)+"次"
            }
        }
        return cell
    }
}

extension WhipCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.checkPlan != nil {
            self.checkPlan!(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.myReuseIdentifier == WhipCell.whipOtherReuseIdentifier() {
            return self.sectionHArr_Other.object(at: indexPath.row) as! CGFloat
        } else {
            return self.sectionHArr_Me.object(at: indexPath.row) as! CGFloat
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.myReuseIdentifier == WhipCell.whipMeReuseIdentifier() {
            return true
        } else {
            return false
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertView.init(title: "确认删除你的计划？", message: nil, delegate: self, cancelButtonTitle: "取消")
            alert.bk_addButton(withTitle: "确认", handler: {
                let whipM: WhipM = self.modelArray.object(at: indexPath.row) as! WhipM
                let param = ["loginId":UserManager.shared.userId,
                             "taskId":whipM.taskId]
                HttpAPIClient.apiClientPOST("removeTask3", params: param, success: { (result) in
                    tableView.setEditing(false, animated: true)
                    if let dataResult = result {
                        
                        let json = JSON(dataResult)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            self.needReloaTW()
                            AppDelegate.removeNotification(myWhipM: whipM)
                        } else {
                            let log = UIAlertView.init(title: json["data"][0]["desc"].stringValue, message: nil, delegate: self, cancelButtonTitle: "确定")
                            log.show()
                        }
                    }
                }) { (error) in
                    tableView.setEditing(false, animated: true)
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            });
            alert.show()
        }
    }
}

class IndexViewController: UIViewController {
    
    fileprivate var myTable: UITableView = UITableView()
    var disposeBag = DisposeBag()
    
    lazy var biantataList :NSMutableArray = {
        return NSMutableArray.init()
    }()
    
    lazy var biantawoList :NSMutableArray = {
        return NSMutableArray.init()
    }()
    
    var sectionH_0: CGFloat = 0.0
    var sectionH_1: CGFloat = 0.0

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        queryDepositDes()
    }
    
    fileprivate func setup() {
        self.navigationItem.title = "速速花"
        self.view.backgroundColor = Define.kColorBackGround()
        NotificationCenter.default.addObserver(self, selector: #selector(setupAPI), name: NSNotification.Name(rawValue: "needReloaTW"), object: nil)
        prepareTableView()
        let addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(clickWithRightBarItem))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    func setupAPI() {
        self.myTable.mj_header.endRefreshing()
        weak var weakSelf = self
        let params = ["userId":UserManager.shared.userId]
        HttpAPIClient.apiClientPOST("biantawoList", params: params, success: { (result) in
            if (result != nil) {
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let woList  = json["data"][0]["biantawoList"].arrayObject
                    let taList  = json["data"][0]["biantataList"].arrayObject
                    weakSelf?.biantataList = WhipM.mj_objectArray(withKeyValuesArray: taList)
                    weakSelf?.biantawoList = WhipM.mj_objectArray(withKeyValuesArray: woList)
                    weakSelf?.sectionH_0 = WhipCell.cellHeight(array: self.biantataList, type: WhipCell.whipOtherReuseIdentifier())
                    weakSelf?.sectionH_1 = WhipCell.cellHeight(array: self.biantawoList, type: WhipCell.whipMeReuseIdentifier())
                    weakSelf?.myTable.reloadData()
  
                    if let array = weakSelf?.biantawoList {
                        for whipM in array {
                            AppDelegate.registerNotification(myWhipM: whipM as! WhipM)
                        }
                    }
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
        }
    }
    
    func queryDepositDes() -> Void {
        // 任务说明
        HttpAPIClient.apiClientPOST("queryTaskDes", params: nil, success: { (result) in
            if let dataResult = result {
                print(dataResult)
                let json = JSON(dataResult)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let queryTaskDes = json["data"][0]["explain"].stringValue
                    UserDefaults.standard.set(queryTaskDes, forKey: "queryTaskDes")
                } else {
                    UserDefaults.standard.removeObject(forKey: "queryTaskDes")
                }
            }
        }) { (error) in
            
        }
        
        // 充值说明
        HttpAPIClient.apiClientPOST("queryDepositDes", params: nil, success: { (result) in
            if let dataResult = result {
                print(dataResult)
                let json = JSON(dataResult)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let queryDepositDes = json["data"][0]["explain"].stringValue
                    UserDefaults.standard.set(queryDepositDes, forKey: "queryDepositDes")
                } else {
                    UserDefaults.standard.removeObject(forKey: "queryDepositDes")
                }
            }
        }) { (error) in
            
        }
    }

    
    fileprivate func prepareTableView() {
        myTable.backgroundColor = kColorBackGround
        myTable.register(WhipCell.self, forCellReuseIdentifier: WhipCell.whipMeReuseIdentifier())
        myTable.register(WhipCell.self, forCellReuseIdentifier: WhipCell.whipOtherReuseIdentifier())
        myTable.dataSource = self
        myTable.delegate = self
        myTable.emptyDataSetSource = self
        myTable.emptyDataSetDelegate = self
        myTable.separatorStyle = .none
        myTable.showsVerticalScrollIndicator = false
        view.addSubview(myTable)
        myTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(IndexViewController.setupAPI))
        self.myTable.mj_header = header
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickWithRightBarItem() {
        let addWhipC = AddWhipController.init()
        addWhipC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addWhipC, animated: true)
    }
}

/// TableViewDataSource methods.
extension IndexViewController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.biantataList.count > 0 {
                return 1
            }
            return 0
        }
        if section == 1 {
            if self.biantawoList.count > 0 {
                return 1
            }
            return 0
        }
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        if indexPath.section == 0 {
            let cell: WhipCell = WhipCell.init(style: .default, reuseIdentifier: WhipCell.whipOtherReuseIdentifier())
            cell.setDataWith(array: self.biantataList)
            cell.checkPlan = { clickIndexPath in
                let taCecordC = TaCecordController.init()
                taCecordC.hidesBottomBarWhenPushed = true
                taCecordC.myWhipM = weakSelf?.biantataList.object(at: clickIndexPath.row) as! WhipM
                weakSelf?.navigationController?.pushViewController(taCecordC, animated: true)
            }
            return cell
        }
        let cell: WhipCell = WhipCell.init(style: .default, reuseIdentifier: WhipCell.whipMeReuseIdentifier())
        cell.setDataWith(array: self.biantawoList)
        cell.checkPlan = { clickIndexPath in
                let meCecordC = MeCecordController.init()
                meCecordC.hidesBottomBarWhenPushed = true
                meCecordC.myWhipM = weakSelf?.biantawoList.object(at: clickIndexPath.row) as! WhipM
                weakSelf?.navigationController?.pushViewController(meCecordC, animated: true)
        }
        cell.needReload = { Void in
            self.setupAPI()
        }
        return cell
    }
}


/// UITableViewDelegate methods.
extension IndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return sectionH_0
        }
        if indexPath.section == 1 {
            return sectionH_1
        }
        return 0
    }
}

extension IndexViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let emptyStr = NSAttributedString.init(string: "您还没有添加任何计划哦\n快来添加吧！", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)])
        return emptyStr
    }
    /*
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let emptyImg = UIImage.init(named: "no_data")
        return emptyImg
    }
    */
}

extension IndexViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

