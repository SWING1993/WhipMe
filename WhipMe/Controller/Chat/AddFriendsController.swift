//
//  AddFriendsController.swift
//  WhipMe
//
//  Created by anve on 16/9/19.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class AddFriendsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var viewSearch: UISearchBar!
    var arrayContent: NSMutableArray!
    var tableViewWM: UITableView!
    
    private let identifier_cell: String = "addFriendsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "添加好友"
        self.view.backgroundColor = Define.kColorBackGround()
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        
        viewSearch = UISearchBar.init()
        viewSearch.backgroundColor = UIColor.white
        viewSearch.barTintColor = UIColor.clear
        viewSearch.barStyle = UIBarStyle.blackTranslucent
        viewSearch.keyboardType = UIKeyboardType.emailAddress
        viewSearch.delegate = self
        viewSearch.layer.cornerRadius = 25.0
        viewSearch.layer.masksToBounds = true
        viewSearch.placeholder = "输入你想搜索的好友名称"
        self.view.addSubview(viewSearch)
        viewSearch.snp.makeConstraints { (make) in
            make.left.top.equalTo(10.0)
            make.width.equalTo(Define.screenWidth() - 20.0)
            make.height.equalTo(50.0)
        }
        
        //清除UISearchBar的子视图背景
        for itemView in viewSearch.subviews {
            if itemView.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                itemView.removeFromSuperview()
                break
            }
            if itemView.isKind(of: NSClassFromString("UIView")!) && itemView.subviews.count > 0 {
                itemView.subviews.first?.removeFromSuperview()
                break
            }
        }
        
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
            make.top.equalTo(viewSearch.snp.bottom).offset(10.0)
            make.left.equalTo(10.0)
            make.right.bottom.equalTo(-10.0)
        }
        
    }
    
    func nameBySearch(text: String) -> String {
        let textTemp: String = "卢萨卡啊开始减肥啦快点减肥啊快点减肥啊立法局卡卡里打飞机啊打飞机啊收到了开发"
        let rangeSize: NSInteger = 3
        let textCount: NSInteger = NSInteger(textTemp.characters.count) - rangeSize
        
        print(textTemp+"______")
        print(textCount)
        
        var searchText: String = ""
        
        let index = textTemp.index(textTemp.startIndex, offsetBy: 3)
        searchText = textTemp.substring(from: index)
        
        return text+searchText
    }
    
    /** UISearchBarDelegate */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let count: UInt32 = arc4random()%11
        arrayContent.removeAllObjects()
        
        for _ in 0..<count {
            let str_item: String = nameBySearch(text: searchBar.text!)
            arrayContent.add(str_item)
        }
        tableViewWM.reloadData()
        
        print("search")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("change")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("endEditing")
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
        
        let str_title: String = arrayContent.object(at: indexPath.row) as! String
    
        let dict: NSMutableDictionary = NSMutableDictionary.init(capacity: 0)
        dict.setValue(str_title, forKey: "title")
        
        cell.setCellWithModel(model: dict)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row+indexPath.section)
        
        
        let controller : FriendsListController = FriendsListController()
        controller.controlModel = WMFriendsListViewModel.addFriend
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
