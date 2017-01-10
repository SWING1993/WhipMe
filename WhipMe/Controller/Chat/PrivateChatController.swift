//
//  PrivateChatViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class PrivateChatController: UIViewController, UITableViewDelegate, UITableViewDataSource, JMessageDelegate {
    
    var arrayNavButton: NSMutableArray!
    var tableViewWM: UITableView!
    
    private let identifier_cell: String = "chatConversationListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kColorBackGround
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getConversationList()
    }
    
    private func setup() {
        
        let titles_nav: NSArray = ["私信","通知"]
        let segmentedView: UISegmentedControl = UISegmentedControl.init(items: titles_nav as [AnyObject])
        segmentedView.frame = CGRect(x: 0, y: 0, width: 132.0, height: 30.0)
        segmentedView.backgroundColor = kColorNavigation
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
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :kContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        tableViewWM = UITableView.init()
        tableViewWM?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableViewWM?.separatorColor = kColorLine
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
            make.width.equalTo(Define.screenWidth()-20.0)
            make.height.equalTo(Define.screenHeight()-64.0 - 49.0 - 20.0)
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
    
    // MARK: - UITableViewDelegate and Datasource
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
    
    // MARK: - Action 方法
    
    func getConversationList() {
        
        JMSGConversation.allConversations { (result, error) in
            
            print("resutl : \(result) error is \(error)")
            
            self.arrayContent.removeAllObjects()
            if (result != nil) {
                self.arrayContent = NSMutableArray.init(array: result as! NSArray)
            }
            
            self.tableViewWM.reloadData()
//            let sortKey: NSSortDescriptor = NSSortDescriptor.init(key: "latestMessage.timestamp", ascending: true)
//            self.arrayContent.sorted(by: { (model1 JMSGConversation, model2 JMSGConversation) -> Bool in
//                return model1 < model2
//            })
            
        }
    }
    
    // MARK: - JMessageDelegate
    
    // JMSGDBMigrateDelegate 数据库升级通知
    func onDBMigrateStart() {
        print("onDBmigrateStart in appdelegate")
    }
    
    func onDBMigrateFinishedWithError(_ error: Error!) {
        print("onDBmigrateFinish in appdelegate")
        getConversationList()
    }
    
    // JMSGMessageDelegate 消息相关的变更通知
    // 发送消息结果返回回调
    func onSendMessageResponse(_ message: JMSGMessage!, error: Error!) {
        print("Action -- onSendMessageResponse \(message) , error:\(error)")
    }
    
    // 接收消息(服务器端下发的)回调
    func onReceive(_ message: JMSGMessage!, error: Error!) {
        print("Action -- onReceivemessage \(message), error:\(error)")
        
        getConversationList()
    }
    
    // 接收消息媒体文件下载失败的回调
    func onReceiveMessageDownloadFailed(_ message: JMSGMessage!) {
        print("Action -- onReceiveMessageDownloadFailed \(message)")
    }

    // JMSGConversationDelegate 会话相关变更通知
    // 会话信息变更通知
    func onConversationChanged(_ conversation: JMSGConversation!) {
        print("Action -- onConversationChanged")
    }
    
    // 当前剩余的全局未读数
    func onUnreadChanged(_ newCount: UInt) {
        print("Action -- onUnreadChanged")
    }
    
    // MARK: - 懒加载
    lazy var arrayContent: NSMutableArray! = {
        print("只走一次")
        var arrayContent = NSMutableArray()
        return arrayContent
    }()
    
    
}
