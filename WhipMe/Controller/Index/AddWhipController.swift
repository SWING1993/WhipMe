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

class QueryHotThemeM: NSObject {
    var num:String = ""
    var themeIcon:String = ""
    var themeId:String = ""
    var themeName:String = ""
}

class AddWhipController: UIViewController {

    var disposeBag = DisposeBag()
    lazy var myCostomAM :PlanM! = {
        let plam = PlanM.init()
        return plam
    }()
    
    fileprivate var queryHotThemeMArr: NSArray = NSArray.init()
    fileprivate var customTable: UITableView = UITableView.init()
    fileprivate var hotTable: UITableView = UITableView.init()
    fileprivate var submitBtn: UIBarButtonItem = UIBarButtonItem.init()
    fileprivate var segmentedView: UISegmentedControl = UISegmentedControl.init()
    fileprivate var hideHot: Bool = false
    
    
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
    

    fileprivate func setup() {
        self.view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        self.submitBtn.bk_init(withTitle: "提交", style: .plain) { (sender) in
            
            if self.myCostomAM.themeName.length <= 0 {
                Tool.showHUDTip(tipStr: "请填写标题后再提交")
                return
            }
            if self.myCostomAM.plan.length <= 0 {
                Tool.showHUDTip(tipStr: "请填写内容后再提交")
                return
            }
            
            /*
            themeName":"主题名称",
            "creator":"创建人的userId",
            "plan":"计划",
            "startDate":"任务开始时间2016-01-01",
            "endDate":"任务结束时间2016-01-01",
            "clockTime":"闹钟时间（4位数表示18:30 用 1830）",
            "privacy":"隐私(1所有人公开2关注人公开3只向自己公开)",
            "type":"监督类型(1: 平台监督 2：好友监督 3：无监督)",
            "supervisor":"监督人的userId",
            "guarantee":"保证金"
*/
            
            let startDate: String = self.myCostomAM.startTime.string(custom: "yyyy-MM-dd")
            let endDate: String = self.myCostomAM.endTime.string(custom: "yyyy-MM-dd")
            let clockTime: String = self.myCostomAM.alarmClock.string(custom: "HHmm")
            
            print(clockTime)
      
            let params = [
                "themeName":self.myCostomAM.themeName,
                "creator":UserManager.getUser().userId,
                "nickname":UserManager.getUser().nickname,
                "icon":UserManager.getUser().icon,
                "plan":self.myCostomAM.plan,
                "startDate":startDate,
                "endDate":endDate,
                "clockTime":clockTime,
                "type":"3",
                "privacy":"1",
                "supervisor":"",
                "supervisorName":"",
                "supervisorIcon":"",
                "guarantee":""
            ]
            
            HttpAPIClient.apiClientPOST("addTask", params: params, success: { (result) in
                print(result!)
                if (result != nil) {
                    let json = JSON(result!)
                    let ret  = json["data"][0]["ret"].intValue
                    
                    if ret == 0 {
                        Tool.showHUDTip(tipStr: "添加成功")
                        _ = self.navigationController?.popViewController(animated: true)

                    } else {
                        Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    }
                }
            }) { (error) in
                print(error as Any);
            }
//            PlanM.savePlan(value: self.myCostomAM)
//            print(self.myCostomAM.alarmWeeks )
//            AppDelegate.registerNotification(plan: self.myCostomAM)
//            _ = self.navigationController?.popViewController(animated: true)
        }
        
        if hideHot == false {
            prepareSegmented()
            prepareHotTable()
            loadHotThemeData()
        }
        prepareCustomTable()
    }
    
    fileprivate func loadHotThemeData() {
        HttpAPIClient.apiClientPOST("queryHotThemeList", params: nil, success: { (result) in
            if (result != nil) {
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                
                if ret == 0 {
                    let list = json["data"][0]["list"].arrayObject
                    self.queryHotThemeMArr = QueryHotThemeM.mj_objectArray(withKeyValuesArray: list)
                    self.hotTable.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            print(error as Any);
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
        
        
        let searchBar = UITextField.init()
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
        
        searchBtn.bk_addEventHandler({ (sender) in
            if searchBar.text!.length <= 0 {
                Tool.showHUDTip(tipStr: "请输入关键字")
                return
            }
            HttpAPIClient.apiClientPOST("queryThemeByName", params: ["themeName":searchBar.text!], success: { (result) in
                if (result != nil) {
                    let json = JSON(result!)
                    let ret  = json["data"][0]["ret"].intValue
                    if ret == 0 {
                        let list = json["data"][0]["list"].arrayObject
                        self.queryHotThemeMArr = QueryHotThemeM.mj_objectArray(withKeyValuesArray: list)
                        self.hotTable.reloadData()
                    } else {
                        Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                    }
                }
            }) { (error) in
                print(error as Any);
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
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        let cell = self.customTable.cellForRow(at: IndexPath.init(row: 0, section: 0))
        cell?.resignFirstResponder()
        return true
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
        if tableView.tag == 100 {
            if indexPath.row == 0 && indexPath.section == 0 {
                let cell: FirstAddCustomCell = FirstAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: FirstAddCustomCell.cellReuseIdentifier())
                
                weak var weakSelf = self
                cell.titleChangedBlock =  { (value) -> Void in
                    weakSelf?.myCostomAM.themeName = value
                }
                
                cell.contentChangedBlock =  { (value) -> Void in
                    weakSelf?.myCostomAM.plan = value
                }
                return cell
            }
            if indexPath.section == 1 {
                let cell: SecondAddCustomCell = SecondAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: SecondAddCustomCell.cellReuseIdentifier())
                
                weak var weakSelf = self
                cell.privacydBlock = { (value:PlanM) -> Void in
                    weakSelf?.myCostomAM.privacy = value.privacy
                }
                
                cell.alarmClockBlock = { (value:PlanM) -> Void in
                    weakSelf?.myCostomAM.alarmClock = value.alarmClock
                    weakSelf?.myCostomAM.alarmWeeks = value.alarmWeeks
                }

                cell.backClosure = { (inputText:IndexPath) -> Void in
                    print(inputText);
                    _ = self.resignFirstResponder()
                    if inputText.row == 0 {
                        SGHDateView.sharedInstance.pickerMode = .date
                        SGHDateView.sharedInstance.show();
                        SGHDateView.sharedInstance.okBlock = { (date) -> Void in
                            self.myCostomAM.startTime = date
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getStartTimeK()), object: self.myCostomAM)
                        }
                    }
                    
                    if inputText.row == 1 {
                        SGHDateView.sharedInstance.pickerMode = .date
                        SGHDateView.sharedInstance.show();
                        SGHDateView.sharedInstance.okBlock = { (date) -> Void in
                            self.myCostomAM.endTime = date
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getEndTimeK()), object: self.myCostomAM)
                        }
                    }
                    
                    if inputText.row == 2 {
                        let alarmC = AlarmClockController.init()
                        self.navigationController?.pushViewController(alarmC, animated: true)
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
                return cell
            }
        }
        
        if tableView.tag == 101 {
            let cell: HotAddCell = HotAddCell.init(style: UITableViewCellStyle.default, reuseIdentifier: HotAddCell.cellReuseIdentifier())
            
            let model:QueryHotThemeM = self.queryHotThemeMArr[indexPath.row] as! QueryHotThemeM
            print(model.themeName)
            cell.titleL.text = model.themeName
            cell.subTitleL.text = "已有" + model.num + "位参加"
            cell.cellImage.image = UIImage.init(named: model.themeIcon)
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
            let vc = AddWhipController.init()
            vc.hideHot = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AddWhipController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            _ = self.resignFirstResponder()
        }
    }
}
