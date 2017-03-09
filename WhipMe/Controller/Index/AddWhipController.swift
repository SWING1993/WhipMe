//
//  AddWhipController.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import SwiftDate
import HandyJSON

class AddTaskM: NSObject {
    /*
    "themeName":"主题名称",
    "creator":"创建人的userId",
    "nickname":"创建人昵称",
    "icon":"创建人的头像",
    "plan":"计划",
    "startDate":"任务开始时间2016-01-01",
    "endDate":"任务结束时间2016-01-01",
    "clockTime":"闹钟时间（4位数表示18:30 用 1830）",
    "privacy":"隐私(1所有人公开2关注人公开3只向自己公开)",
    "type":"监督类型(1: 平台监督 2：好友监督 3：无监督)",
    "supervisor":"监督人的userId",
    "supervisorName":"监督人的昵称",
    "supervisorIcon":"监督人的头像",
    "guarantee":"保证金"
     
     "type":"监督类型(1: 平台监督 2：好友监督 3：无监督)",
     "supervisor":"监督人的userId",
     "supervisorName":"监督人的昵称",
     "supervisorIcon":"监督人的头像",
     "guarantee":"保证金"
     "type"为3时，supervisor、supervisorName、supervisorIcon 、guarantee传空值 “”
     "type"为1时，supervisor、supervisorName、supervisorIcon  传空值 “”
 */
    var themeName: String = ""
    var creator: String = ""
    var nickname: String = ""
    var icon: String = ""
    var plan: String = ""
    var startDate: Date?
    var endDate: Date?
    var clockTime: Date?
    var privacy: PrivacyType = .all
    var type: String = "3"
    var supervisor: String = ""
    var supervisorName: String = ""
    var supervisorIcon: String = ""
    var guarantee: String = ""
}

class QueryHotThemeM: HandyJSON {
    var num:String = ""
    var themeIcon:String = ""
    var themeId:String = ""
    var themeName:String = ""
    
    required init() {}
}

class AddWhipController: UIViewController {

    var queryHorThemeName: String = ""
    var hideHot: Bool = false
    var addTask = AddTaskM()
    var disposeBag = DisposeBag()
    
    fileprivate var queryHotThemeMArr : [QueryHotThemeM] = []
    fileprivate var customTable = UITableView()
    fileprivate var hotTable = UITableView()
    fileprivate var submitBtn = UIBarButtonItem()
    fileprivate var segmentedView = UISegmentedControl()
    fileprivate var searchBar = UITextField()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func addSupervisorKey() -> String {
        return "addSupervisorKey"
    }
    
    func setSupervisor(notification:Notification) -> Void {
        let costomAM:AddTaskM = notification.object as! AddTaskM
        addTask.type = costomAM.type
        addTask.supervisorName = costomAM.supervisorName
        addTask.supervisorIcon = costomAM.supervisorIcon
        addTask.supervisor = costomAM.supervisor
        addTask.guarantee = costomAM.guarantee
        customTable.reloadData()
    }

    fileprivate func setup() {
        self.view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        if hideHot == false {
            prepareSegmented()
            prepareHotTable()
            loadHotThemeData()
        }
        else {
            self.navigationItem.rightBarButtonItem = self.submitBtn
        }
        prepareCustomTable()
        NotificationCenter.default.addObserver(self, selector: #selector(setSupervisor), name: NSNotification.Name(rawValue: AddWhipController.addSupervisorKey()), object: nil)
        
        weak var weakSelf = self
        self.submitBtn.bk_init(withTitle: "提交", style: .plain) { (sender) in
            if (weakSelf?.addTask.themeName.length)! <= 0 {
                Tool.showHUDTip(tipStr: "请填写标题后再提交!")
                return
            }
            if (weakSelf?.addTask.plan.length)! <= 0 {
                Tool.showHUDTip(tipStr: "请填写内容后再提交!")
                return
            }
            if (weakSelf?.addTask.plan.length)! >= 200 {
                Tool.showHUDTip(tipStr: "内容最长可为200字!")
                return
            }
            
            var startDate: String = ""
            if let date = weakSelf!.addTask.startDate {
                startDate = date.string(custom: "yyyy-MM-dd")
            } else {
                Tool.showHUDTip(tipStr: "请选择开始时间")
                return
            }
            
            var endDate: String = ""
            if let date = weakSelf!.addTask.endDate {
                endDate = date.string(custom: "yyyy-MM-dd")
            } else {
                Tool.showHUDTip(tipStr: "请选择结束时间")
                return
            }
            
            var clockTime: String = ""
            if let date = weakSelf!.addTask.clockTime {
                clockTime = date.string(custom: "HHmm")
            }
            
            var privacy: String = ""
            switch self.addTask.privacy {
                case .mySelf:
                privacy = "3"
                break
            case .myFollow:
                privacy = "2"
                break
            default:
                privacy = "1"
                break
            }
                  
            let params = [
                "themeName":self.addTask.themeName,
                "creator":UserManager.shared.userId,
                "nickname":UserManager.shared.nickname,
                "icon":UserManager.shared.icon,
                "plan":self.addTask.plan,
                "startDate":startDate,
                "endDate":endDate,
                "clockTime":clockTime,
                "privacy":privacy,
                "type":self.addTask.type,
                "supervisor":self.addTask.supervisor,
                "supervisorName":self.addTask.supervisorName,
                "supervisorIcon":self.addTask.supervisorIcon,
                "guarantee":self.addTask.guarantee
            ]
            
            let alert = UIAlertView.init(title: "确认提交你的鞭挞计划？", message: nil, delegate: self, cancelButtonTitle: "取消")
            alert.bk_addButton(withTitle: "确认", handler: {
                HttpAPIClient.apiClientPOST("addTask", params: params, success: { (result) in
                    if let resultData = result {
                        let json = JSON(resultData)
                        let ret  = json["data"][0]["ret"].intValue
                        if ret == 0 {
                            _ = weakSelf?.navigationController?.popToRootViewController(animated: true)
                        } else {
                            Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                        }
                    }
                }) { (error) in
                    Tool.showHUDTip(tipStr: "网络不给力")
                }
            });
            alert.show()
        }
    }
    
    fileprivate func loadHotThemeData() {
        weak var weakSelf = self
        HttpAPIClient.apiClientPOST("queryHotThemeList", params: nil, success: { (result) in
            if let resultData = result {
                
                let json = JSON(resultData)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let list = json["data"][0]["list"].arrayValue
                    weakSelf?.queryHotThemeMArr = {
                        var temps : [QueryHotThemeM] = []
                        for json in list {
                            let jsonString = String(describing: json)
                            if let model = JSONDeserializer<QueryHotThemeM>.deserializeFrom(json: jsonString) {
                                temps.append(model)
                            }
                        }
                        return temps
                    }()
                    weakSelf?.hotTable.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
        }
    }
    
    fileprivate func prepareHotTable() {
        
        hotTable.backgroundColor = kColorBackGround
        hotTable.tag = 101
        hotTable.register(HotAddCell.self, forCellReuseIdentifier: HotAddCell.cellReuseIdentifier())
        hotTable.dataSource = self
        hotTable.delegate = self
        hotTable.showsVerticalScrollIndicator = false
        hotTable.separatorStyle = .none
        view.addSubview(hotTable)
        hotTable.translatesAutoresizingMaskIntoConstraints = false
        hotTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 68))
        searchView.backgroundColor = kColorBackGround
        
        let bgview = UIView.init(frame: CGRect.init(x: 10, y: 10, width: Define.screenWidth() - 20, height: 50))
        bgview.layer.masksToBounds = true
        bgview.layer.cornerRadius = 25.0
        bgview.backgroundColor = UIColor.white
        searchView.addSubview(bgview)
        
        searchBar.placeholder  = "输入关键字"
        bgview.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-65)
        }
        
        let searchBtn = UIButton.init(type: .custom)
        searchBtn.setImage(UIImage.init(named: "search_icon"), for: .normal)
        bgview.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 50, height: 50))
            make.top.right.equalTo(0)
        }
        
        weak var weakSelf = self
        searchBtn.bk_addEventHandler({ (sender) in
            if self.searchBar.text!.length <= 0 {
                Tool.showHUDTip(tipStr: "请输入关键字")
                return
            }
            HttpAPIClient.apiClientPOST("queryThemeByName", params: ["themeName":self.searchBar.text!], success: { (result) in
                if let resultData = result {
                    let json = JSON(resultData)
                    let ret  = json["data"][0]["ret"].intValue
                    if ret == 0 {
                        let list = json["data"][0]["list"].arrayValue
                        weakSelf?.queryHotThemeMArr = {
                            var temps : [QueryHotThemeM] = []
                            for json in list {
                                let jsonString = String(describing: json)
                                if let model = JSONDeserializer<QueryHotThemeM>.deserializeFrom(json: jsonString) {
                                    temps.append(model)
                                }
                            }
                            return temps
                        }()
                        weakSelf?.hotTable.reloadData()
                    } else {
                        Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    }
                }
            }) { (error) in
                Tool.showHUDTip(tipStr: "网络不给力")
            }
        }, for: .touchUpInside)
        
        hotTable.tableHeaderView = searchView
    }
    
    fileprivate func prepareCustomTable() {
        customTable.backgroundColor = kColorBackGround
        customTable.tag = 100
        customTable.register(FirstAddCustomCell.self, forCellReuseIdentifier: FirstAddCustomCell.cellReuseIdentifier())
        customTable.register(SecondAddCustomCell.self, forCellReuseIdentifier: SecondAddCustomCell.cellReuseIdentifier())
        customTable.register(ThirdAddCustomCell.self, forCellReuseIdentifier: ThirdAddCustomCell.cellReuseIdentifier())
        customTable.dataSource = self
        customTable.delegate = self
        customTable.showsVerticalScrollIndicator = false
        customTable.separatorStyle = .none
        view.addSubview(customTable)
        customTable.translatesAutoresizingMaskIntoConstraints = false
        customTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    fileprivate func prepareSegmented() {
        let titles_nav: NSArray = ["热门","自定义"]
        segmentedView = UISegmentedControl.init(items: titles_nav as [AnyObject])
        segmentedView.frame = CGRect(x: 0, y: 0, width: 132.0, height: 30.0)
        segmentedView.backgroundColor = kColorNavigation
        segmentedView.layer.cornerRadius = segmentedView.height/2.0
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.borderColor = UIColor.white.cgColor
        segmentedView.layer.borderWidth = 1.0
        segmentedView.tintColor = UIColor.white
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action:#selector(clickWithSegmentedItem), for: UIControlEvents.valueChanged)
        self.navigationItem.titleView = segmentedView

        customTable.isHidden = true
        hotTable.isHidden = false
    }
    
    func clickWithSegmentedItem(_ sender: UISegmentedControl) {
        self.resignMyFirstResponder()
        if sender.selectedSegmentIndex == 0 {
            customTable.isHidden = true
            hotTable.isHidden = false
            self.navigationItem.rightBarButtonItem = nil
        }
        if sender.selectedSegmentIndex == 1 {
            customTable.isHidden = false
            hotTable.isHidden = true
            self.navigationItem.rightBarButtonItem = self.submitBtn
        }
    }
    
    func resignMyFirstResponder() {
        super.resignFirstResponder()
        self.searchBar.resignFirstResponder()
        self.searchBar.endEditing(true)
        let cell = self.customTable.cellForRow(at: IndexPath.init(row: 0, section: 0))
        cell?.resignFirstResponder()
    }
}
/// TableViewDataSource methods.
extension AddWhipController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 101 {
            return self.queryHotThemeMArr.count
        }
        return 4
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        if tableView.tag == 100 {
            if indexPath.row == 0 && indexPath.section == 0 {
                let cell: FirstAddCustomCell = FirstAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: FirstAddCustomCell.cellReuseIdentifier())
                
                if self.queryHorThemeName.isEmpty == false {
                    cell.titleT.isEnabled = false;
                    self.addTask.themeName = self.queryHorThemeName
                    cell.titleT.text = self.addTask.themeName
                    cell.contentT.text = self.addTask.plan

                } else {
                    cell.titleT.text = self.addTask.themeName
                    cell.contentT.text = self.addTask.plan
                }
                
                cell.titleChangedBlock =  { (value) -> Void in
                    weakSelf?.addTask.themeName = value
                }
                
                cell.contentChangedBlock =  { (value) -> Void in
                    weakSelf?.addTask.plan = value
                }
                return cell
            }
            if indexPath.section == 1 {
                let cell: SecondAddCustomCell = SecondAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: SecondAddCustomCell.cellReuseIdentifier())
                cell.setAddTask(task: self.addTask)
                
                cell.privacydBlock = { (value:AddTaskM) -> Void in
                    weakSelf?.addTask.privacy = value.privacy
                }
                
                cell.alarmClockBlock = { (value:AddTaskM) -> Void in
                    weakSelf?.addTask.clockTime = value.clockTime
                }

                cell.backClosure = { (inputText:IndexPath) -> Void in
                    _ = weakSelf?.resignMyFirstResponder()
                    if inputText.row == 0 {
                        SGHDateView.sharedInstance.pickerMode = .date
                        SGHDateView.sharedInstance.show();
                        SGHDateView.sharedInstance.okBlock = { (date) -> Void in
                            weakSelf?.addTask.startDate = date
                            weakSelf?.customTable.reloadData()
                        }
                    }
                    
                    if inputText.row == 1 {
                        SGHDateView.sharedInstance.pickerMode = .date
                        SGHDateView.sharedInstance.show();
                        SGHDateView.sharedInstance.okBlock = { (date) -> Void in
                            weakSelf?.addTask.endDate = date
                            weakSelf?.customTable.reloadData()
                        }
                    }
                    
                    if inputText.row == 2 {
                        SGHDateView.sharedInstance.pickerMode = .time
                        SGHDateView.sharedInstance.show();
                        SGHDateView.sharedInstance.okBlock = { (date) -> Void in
                            weakSelf?.addTask.clockTime = date
                            weakSelf?.customTable.reloadData()
                        }
                    }

                    if inputText.row == 3 {
                        let privacyC = PrivacyViewController.init()
                        self.navigationController?.pushViewController(privacyC, animated: true)
                    }
                }
                return cell
            }
            if indexPath.section == 2 {
                let cell: ThirdAddCustomCell = ThirdAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: ThirdAddCustomCell.cellReuseIdentifier())
                cell.setAddTask(task: self.addTask)
                cell.addBtn.bk_addEventHandler({ (sender) in
                    let addPeopleC = AddPeopleController()
                    let addPeopleN = UINavigationController.init(rootViewController: addPeopleC)
                    weakSelf?.present(addPeopleN, animated: true, completion: nil)
                }, for: .touchUpInside)
                return cell
            }
        }
        
        if tableView.tag == 101 {
            let cell: HotAddCell = HotAddCell.init(style: UITableViewCellStyle.default, reuseIdentifier: HotAddCell.cellReuseIdentifier())
            let model:QueryHotThemeM = self.queryHotThemeMArr[indexPath.section]
            cell.titleL.text = model.themeName
            cell.subTitleL.text = "已有" + model.num + "位参加"
            cell.cellImage.setImageWith(urlString: model.themeIcon, placeholderImage: "nilTouSu")
            return cell
        }
        
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "subtitlecell")
        return cell
    }
}


/// UITableViewDelegate methods.
extension AddWhipController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 100 {
            if indexPath.row == 0 && indexPath.section == 0 {
                return FirstAddCustomCell.cellHeight()
            }
            if indexPath.section == 1 {
                return SecondAddCustomCell.cellHeight()
            }
            
            if indexPath.section == 2 {
                return ThirdAddCustomCell.cellHeight()
            }
        }
        if tableView.tag == 101 {
            return HotAddCell.cellHeight()
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 101 {
            self.searchBar.endEditing(true)
            let model:QueryHotThemeM = self.queryHotThemeMArr[indexPath.section]
            let whipM = WhipM()
            whipM.themeId = model.themeId
            whipM.themeName = model.themeName
            whipM.themeIcon = model.themeIcon
            let classVC = ClassifyController()
            classVC.isJoin = true
            classVC.myWhipM = whipM
            self.navigationController?.pushViewController(classVC, animated: true)
            
        }
    }
}

extension AddWhipController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            _ = self.resignMyFirstResponder()
        }
    }
}

