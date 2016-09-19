//
//  PrivateChatViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class PrivateChatController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayNavButton: NSMutableArray!
    var tableViewWM: UITableView!
    var arrayContent: NSMutableArray!
    
    private let identifier_cell: String = "chatConversationListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = KColorBackGround
        
        setup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        
        let titles_nav: NSArray = ["私信","通知"]
        let segmentedView: UISegmentedControl = UISegmentedControl.init(items: titles_nav as [AnyObject])
        segmentedView.frame = CGRect(x: 0, y: 0, width: 132.0, height: 30.0)
        segmentedView.backgroundColor = KColorNavigation
        segmentedView.layer.cornerRadius = segmentedView.height/2.0
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.borderColor = UIColor.white.cgColor
        segmentedView.layer.borderWidth = 1.0
        segmentedView.tintColor = UIColor.white
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action:#selector(clickWithNavItem), for: UIControlEvents.valueChanged)
        self.navigationItem.titleView = segmentedView
        
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "people_care"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.white
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :KContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        arrayContent = NSMutableArray.init(capacity: 0)
        
        tableViewWM = UITableView.init()
        tableViewWM?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableViewWM?.separatorColor = KColorLine
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
        tableViewWM.register(ChatConversationListCell.classForCoder(), forCellReuseIdentifier: identifier_cell)
        self.view.addSubview(tableViewWM)
        tableViewWM.snp.makeConstraints { (make) in
            make.top.left.equalTo(10.0)
            make.right.bottom.equalTo(-10.0)
        }
        
        
    }
    
    func clickWithNavItem(_ sender: UISegmentedControl) {
       
        print(sender.numberOfSegments+sender.selectedSegmentIndex)

    }

    func clickWithRightBarItem() {
        print(NSStringFromClass(self.classForCoder))
        let controller : FriendsListController = FriendsListController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /** UITableViewDelegate and Datasource */
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
        let cell: ChatConversationListCell = ChatConversationListCell.init(style: UITableViewCellStyle.default, reuseIdentifier: identifier_cell)
        
        cell.setCellWithModel(model: NSDictionary.init())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row+indexPath.section)
        
        let controller: ChatConversationController = ChatConversationController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
