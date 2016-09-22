//
//  UserInfoViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
//    var arrayContent: NSMutableArray! = ["","头像","","昵称","性别","生日","","签名"]
    
    private let identifier_cell: String = "userInfoViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "编辑个人资料"
        self.view.backgroundColor = KColorBackGround
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        
        
        tableView = UITableView.init()
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.tableFooterView = UIView.init()
        self.view.addSubview(tableView)
        tableView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier_cell)
    }
    
    // MARK: - UITableViewDelegate Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 0.0
        if indexPath.row == 0 {
            rowHeight = 10.0
        } else if (indexPath.row == 2 || indexPath.row == 6) {
            rowHeight = 12.0
        } else if (indexPath.row == 1) {
            rowHeight = 75.0
        } else {
            rowHeight = 48.0
        }
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier_cell)!
        
        if cell == nil {
            print("indexPath is row \(indexPath.row)")
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "")
        }
        
        if indexPath.row == 1 {
            cell.textLabel?.text = "头像"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "昵称"
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "性别"
        } else if indexPath.row == 5 {
            cell.textLabel?.text = "生日"
        } else if indexPath.row == 7 {
            cell.textLabel?.text = "签名"
        } else {
            cell.textLabel?.text = ""
        }
        
        return cell
    }

}
