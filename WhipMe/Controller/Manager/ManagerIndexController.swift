//
//  ManagerIndexController.swift
//  WhipMe
//
//  Created by Song on 2017/2/18.
//  Copyright © 2017年 -. All rights reserved.
//

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


class ManagerIndexController: UIViewController {
    
    fileprivate var myTable: UITableView = UITableView()
    var disposeBag = DisposeBag()
    
    lazy var needHandleList :NSMutableArray = {
        return NSMutableArray.init()
    }()
    
    lazy var needSuperviseList :NSMutableArray = {
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
    }
    
    fileprivate func setup() {
        self.navigationItem.title = "管理员"
        self.view.backgroundColor = Define.kColorBackGround()
        NotificationCenter.default.addObserver(self, selector: #selector(setupAPI), name: NSNotification.Name(rawValue: "needReloaTW"), object: nil)
        prepareTableView()
        let backBtn = UIBarButtonItem.init(title: "返回", style: .done, target: self, action: #selector(disMiss))
        self.navigationItem.leftBarButtonItem = backBtn

    }
    
    func disMiss() {
        self.dismiss(animated: true) {        }
    }

    func setupAPI() {
        self.myTable.mj_header.endRefreshing()
        weak var weakSelf = self
        let params = ["pageSize":"100","pageIndex":"1"]
        HttpAPIClient.apiClientPOST("needHandleList", params: params, success: { (result) in
            
            if (result != nil) {
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let list  = json["data"][0]["list"].arrayObject
                    weakSelf?.needHandleList = WhipM.mj_objectArray(withKeyValuesArray: list)
                    weakSelf?.sectionH_0 = WhipCell.cellHeight(array: self.needHandleList, type: WhipCell.whipOtherReuseIdentifier())
                    weakSelf?.myTable.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
        }
        
        let params2 = ["pageSize":"100","pageIndex":"1","userId":UserManager.shared.userId]
        HttpAPIClient.apiClientPOST("needSuperviseList", params: params2, success: { (result) in
            
            if (result != nil) {
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let list  = json["data"][0]["list"].arrayObject
                    weakSelf?.needSuperviseList = WhipM.mj_objectArray(withKeyValuesArray: list)
                    weakSelf?.sectionH_1 = WhipCell.cellHeight(array: self.needSuperviseList, type: WhipCell.whipMeReuseIdentifier())
                    weakSelf?.myTable.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
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
}

/// TableViewDataSource methods.
extension ManagerIndexController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.needHandleList.count > 0 {
                return 1
            }
            return 0
        }
        if section == 1 {
            if self.needSuperviseList.count > 0 {
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
            cell.setDataWith(array: self.needHandleList)
//            cell.checkPlan = { clickIndexPath in
//                let taCecordC = TaCecordController.init()
//                taCecordC.hidesBottomBarWhenPushed = true
//                taCecordC.myWhipM = weakSelf?.biantataList.object(at: clickIndexPath.row) as! WhipM
//                weakSelf?.navigationController?.pushViewController(taCecordC, animated: true)
//            }
            return cell
        }
        let cell: WhipCell = WhipCell.init(style: .default, reuseIdentifier: WhipCell.whipMeReuseIdentifier())
        cell.setDataWith(array: self.needSuperviseList)
        cell.checkPlan = { clickIndexPath in
            let detailC = ManagerIndexDetailController.init()
            detailC.hidesBottomBarWhenPushed = true
            detailC.myWhipM = weakSelf?.needSuperviseList.object(at: clickIndexPath.row) as! WhipM
            weakSelf?.navigationController?.pushViewController(detailC, animated: true)
        }
        cell.needReload = { Void in
            self.setupAPI()
        }
        return cell
    }
}


/// UITableViewDelegate methods.
extension ManagerIndexController: UITableViewDelegate {
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

extension ManagerIndexController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let emptyStr = NSAttributedString.init(string: "您还没有添加任何习惯哦\n快来添加吧！", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)])
        return emptyStr
    }
}

extension ManagerIndexController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
