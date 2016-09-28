//
//  SetingViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/23.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class SetingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    var tableViewWM: UITableView!
    private let identifier_cell: String = "setingTableViewCell"
    var userModel: UserInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Define.kColorBackGround()
        self.navigationItem.title = "设置"
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setup() {
        
        tableViewWM = UITableView.init()
        tableViewWM.backgroundColor = UIColor.clear
        tableViewWM.delegate = self
        tableViewWM.dataSource = self
        tableViewWM.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableViewWM.separatorColor = Define.kColorLine()
        tableViewWM.separatorInset = UIEdgeInsets.zero
        tableViewWM.layoutMargins = UIEdgeInsets.zero
        tableViewWM.tableFooterView = UIView.init()
        self.view.addSubview(tableViewWM)
        tableViewWM.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        tableViewWM.register(UserInfoTableViewCell.classForCoder(), forCellReuseIdentifier: identifier_cell)
        
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
        let cell: UserInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier_cell) as! UserInfoTableViewCell
        cell.backgroundColor = UIColor.white
        cell.imageLogo.isHidden = true
        cell.lblText.isHidden = false
        cell.lblTitle.textAlignment = NSTextAlignment.left
        cell.lblTitle.textColor = Define.kColorBlack()
        
        var margin_x: CGFloat = 0.0
        if indexPath.row == 1 {
            cell.lblTitle?.text = "编辑个人资料"
            cell.lblText.isHidden = true
            cell.imageLogo.isHidden = false
            cell.imageLogo.backgroundColor = Define.kColorLight()
            cell.imageLogo.image = UIImage.full(toFilePath: userModel.avatar)
        } else if indexPath.row == 3 {
            cell.lblTitle?.text = "帮助中心"
            margin_x = 15.0
        } else if indexPath.row == 4 {
            cell.lblTitle?.text = "关于鞭挞我"
            margin_x = 15.0
        } else if indexPath.row == 5 {
            cell.lblTitle?.text = "管理员登录"
        } else if indexPath.row == 7 {
            cell.lblTitle?.text = "退出登录"
            cell.lblTitle.textColor = Define.kColorRed()
            cell.lblTitle.textAlignment = NSTextAlignment.center
        } else {
            cell.lblTitle?.text = ""
            cell.backgroundColor = UIColor.clear
        }
        cell.layoutMargins = UIEdgeInsets.init(top: 0, left: margin_x, bottom: 0, right: 0)
        cell.separatorInset = UIEdgeInsets.init(top: 0, left: margin_x, bottom: 0, right: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let controller: UserInfoViewController = UserInfoViewController()
            controller.userModel = userModel
            self.navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.row == 3{
            
        } else if indexPath.row == 4 {
            
            
        } else if indexPath.row == 5 {
            
        } else if indexPath.row == 7 {
            let sheetExit = UIActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "确认退出")
            sheetExit.show(in: self.view)
        }
    }
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print("button index is :\(buttonIndex)")
        if buttonIndex == 0 {
            print("exit is success! ")
        }
    }
}
