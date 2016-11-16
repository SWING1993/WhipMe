//
//  FriendsListController.swift
//  WhipMe
//
//  Created by anve on 16/9/19.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit


public enum WMFriendsListViewModel : NSInteger {
    case none
    case addFriend
    case friendList
}

class FriendsListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var arrayContent: NSMutableArray!
    var tableViewWM: UITableView!
    
    public var controlModel: WMFriendsListViewModel?
    private let identifier_cell: String = "friendsListViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Define.kColorBackGround()
        
        setup()
        
        queryByFriends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {

        let flag: Bool = controlModel == WMFriendsListViewModel.addFriend ? true : false
        let str_title: String = flag ? "添加好友" : "好友列表"
       
        self.navigationItem.title = str_title;
        let rightBarItem: UIBarButtonItem!
        if flag {
            rightBarItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithCancel))
        } else {
            rightBarItem = UIBarButtonItem.init(image: UIImage.init(named: "add_friend"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        }
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :kContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        arrayContent = NSMutableArray.init(capacity: 0)
        
        tableViewWM = UITableView.init()
        tableViewWM?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableViewWM?.separatorColor = Define.kColorLine()
        tableViewWM?.layoutMargins = UIEdgeInsets.zero
        tableViewWM?.separatorInset = UIEdgeInsets.zero
        tableViewWM?.backgroundColor = UIColor.white
        tableViewWM?.layer.cornerRadius = 4.0
        tableViewWM?.layer.masksToBounds = true
        tableViewWM?.delegate = self
        tableViewWM?.dataSource = self
        tableViewWM?.showsVerticalScrollIndicator = true
        tableViewWM?.showsHorizontalScrollIndicator = false
        tableViewWM.translatesAutoresizingMaskIntoConstraints = false
        tableViewWM?.tableFooterView = UIView.init(frame: CGRect.zero)
        tableViewWM.register(FriendsListViewCell.classForCoder(), forCellReuseIdentifier: identifier_cell)
        self.view.addSubview(tableViewWM)
        tableViewWM.snp.makeConstraints { (make) in
            make.top.left.equalTo(10.0)
            make.right.bottom.equalTo(-10.0)
        }
        
    }
    
    func clickWithRightBarItem() {
        print(NSStringFromClass(self.classForCoder))
        let controller : AddFriendsController = AddFriendsController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func clickWithCancel() {
        print(self.classForCoder)
    }
    
    // BACK: - UITableViewDelegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayContent.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendsListViewCell = FriendsListViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier_cell)
        
        let model: JMSGUser = self.arrayContent.object(at: indexPath.row) as! JMSGUser
        cell.setCellWithModel(model: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row+indexPath.section)
    }
    
    // BACK: - network Data
    func queryByFriends() {
        let lists: [String] = ["youye","youye1","youye2"]
        
        JMSGUser.userInfoArray(withUsernameArray: lists, appKey: JMESSAGE_APPKEY) { (result, error) in
            
            print("resutl : \(result) error is \(error)")
            
            self.arrayContent.removeAllObjects()
            if result != nil {
                self.arrayContent = NSMutableArray.init(array: result as! NSArray)
            }
            
            self.tableViewWM.reloadData()
        }
    }
}
