//
//  MyFansAndFocusController.swift
//  WhipMe
//
//  Created by anve on 16/11/18.
//  Copyright © 2016年 -. All rights reserved.
//  我的粉丝&关注列表

import UIKit

enum WMFansAndFocusStyle: Int {
    case fans
    case focus
}

class MyFansAndFocusController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyFansAndFocusCellDelegate {
    
    fileprivate var arrayContent: NSMutableArray!
    fileprivate var tableViewWM: UITableView!
    fileprivate let identifier_cell = "myFansAndFocusCell"
    
    open var style: WMFansAndFocusStyle = WMFansAndFocusStyle.fans
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kColorBackGround
        if self.style == .fans {
            self.navigationItem.title = "我的粉丝"
        } else {
            self.navigationItem.title = "我的关注"
        }

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        let line_head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 10.0))
        line_head.backgroundColor = kColorBackGround
        
        let line_foot = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 10.0))
        line_foot.backgroundColor = kColorBackGround
        
        tableViewWM = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableViewWM.backgroundColor = UIColor.clear
        tableViewWM.delegate = self
        tableViewWM.dataSource = self
        tableViewWM.separatorStyle = UITableViewCellSeparatorStyle.none
        tableViewWM.tableFooterView = line_head
        tableViewWM.tableHeaderView = line_foot
        self.view.addSubview(tableViewWM)
        tableViewWM.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        tableViewWM.register(MyFansAndFocusCell.classForCoder(), forCellReuseIdentifier: identifier_cell)
        
    }
    // MARK: - UITableViewDelegate Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyFansAndFocusCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyFansAndFocusCell = tableView.dequeueReusableCell(withIdentifier: identifier_cell) as! MyFansAndFocusCell
        
        let model: Dictionary<String, String> = ["title":"小溪漓江", "describe":"监督是一种责任"]
        cell.cellModel(model: model, style: self.style)
        cell.delegate = self
        if (indexPath.row+1 == tableView.numberOfRows(inSection: indexPath.section)) {
            cell.lineView.isHidden = true
        } else {
            cell.lineView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: - MyFansAndFocusCellDelegate
    func fansAndFocusCheck() {
        if self.style == .fans {
            Tool.showHUDTip(tipStr: "关注成功！")
        } else {
            Tool.showHUDTip(tipStr: "已经取消关注！")
        }
    }
    
}
