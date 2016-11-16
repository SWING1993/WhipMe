//
//  FriendCircleController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftyJSON

class FriendCircleM: NSObject {
    var comment: NSArray = NSArray.init()
    
    var commentNum: Int = 0
    var likeNum: Int = 0
    var shareNum: Int = 0

    var content: String = ""
    var createDate: String = ""
    var icon: String = ""
    var nickname: String = ""
    var picture: String = ""
    var position: String = ""
    var recordId: String = ""
    var taskId: String = ""
    var themeId: String = ""
    var themeName: String = ""
    var userId: String = ""
}

class FriendCircleController: UIViewController {
    
    fileprivate var recommendTable: UITableView = UITableView.init()
    fileprivate var friendCircleModelArr: NSMutableArray = NSMutableArray.init();
    fileprivate var picPrefix: String = ""
    fileprivate var iconPrefix: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let params = [
            "pageSize":"20",
            "pageIndex":"1",
        ]
        
        HttpAPIClient.apiClientPOST("biantaquanList", params: params, success: { (result) in
            print(result!)
            if (result != nil) {
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    self.iconPrefix = json["data"][0]["iconPrefix"].stringValue
                    self.picPrefix = json["data"][0]["picPrefix"].stringValue
                    let list = json["data"][0]["list"].arrayObject
                    self.friendCircleModelArr = FriendCircleM.mj_objectArray(withKeyValuesArray: list)
                    self.recommendTable.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            print(error as Any);
        }

    }
    
    fileprivate func setup() {
        self.view.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        prepareTableView()
        prepareSegmented()
    }
    
    fileprivate func prepareSegmented() {
        let titles_nav: NSArray = ["推荐","关注"]
        let segmentedView: UISegmentedControl = UISegmentedControl.init(items: titles_nav as [AnyObject])
        segmentedView.frame = CGRect(x: 0, y: 0, width: 132.0, height: 30.0)
        segmentedView.backgroundColor = Define.kColorNavigation()
        segmentedView.layer.cornerRadius = segmentedView.height/2.0
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.borderColor = UIColor.white.cgColor
        segmentedView.layer.borderWidth = 1.0
        segmentedView.tintColor = UIColor.white
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action:#selector(clickWithSegmentedItem), for: UIControlEvents.valueChanged)
        self.navigationItem.titleView = segmentedView
        
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "people_care"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.white
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :kContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    fileprivate func prepareTableView() {
        recommendTable = UITableView.init()
        recommendTable.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.cellReuseIdentifier())
        recommendTable.dataSource = self
        recommendTable.delegate = self
        recommendTable.separatorStyle = .none
        view.addSubview(recommendTable)
        recommendTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickWithSegmentedItem(_ sender: UISegmentedControl) {
        print(sender.numberOfSegments+sender.selectedSegmentIndex)
        recommendTable.reloadData()
    }
    
    func clickWithRightBarItem() {
        print(NSStringFromClass(self.classForCoder))
    }
    
}

/// TableViewDataSource methods.
extension FriendCircleController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendCircleModelArr.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
        
        let model:FriendCircleM = self.friendCircleModelArr.object(at: indexPath.row) as! FriendCircleM
        let avatarUrl = self.iconPrefix + model.icon
        let picUrl = self.picPrefix + model.picture
        
        cell.avatarV.setIconURL(NSURL.init(string:avatarUrl) as URL!)
        cell.pictrueView.setIconURL(NSURL.init(string:picUrl) as URL!)
        cell.contentL.text = model.content
        cell.nickNameL.text = model.nickname
        cell.topicL.text = model.themeName
        cell.timeL.text = model.createDate
        cell.pageView.text = String(model.likeNum) + "次"
        cell.locationB.text = model.position
        
        cell.likeB.setTitle("12", for: .normal)
        cell.commentB.setTitle(String(model.commentNum), for: .normal)
        cell.shareB.setTitle(String(model.shareNum), for: .normal)

        return cell
    }
}


/// UITableViewDelegate methods.
extension FriendCircleController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
//    /// Sets the tableView header height.
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 200
//    }
    //    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 15
    //    }
    
}
