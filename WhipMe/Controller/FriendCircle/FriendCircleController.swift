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
import HandyJSON
import MJRefresh

class FriendCircleM: HandyJSON {
    var comment: NSArray = NSArray.init()
    var recordIdNum: Int = 0
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
    var creator: String = ""
    var creatorId :String = ""
    var liked :Bool = false
    
    required init() {}

}

class FriendCircleController: UIViewController {

    fileprivate var recommendTable: UITableView = UITableView()
    fileprivate var friendCircleModels: [FriendCircleM] = [];
    fileprivate var cellHeights: [CGFloat] = []
    
    fileprivate var focusList: UITableView = UITableView()
    fileprivate var focusModels: [FriendCircleM] = [];
    fileprivate var focusCellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = kColorBackGround
        prepareTableView()
        prepareSegmented()
        setupRecommendRequest()
    }
    
    func setupFocusRequest() {
        self.focusList.mj_header.endRefreshing()
        weak var weakSelf = self
        let params = [
            "pageSize":"20",
            "pageIndex":"1",
            "userId":UserManager.shared.userId
            ]
        HttpAPIClient.apiClientPOST("biantaquanFocusList", params: params, success: { (result) in
            if let dataResult = result {
                let json = JSON(dataResult)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let list = json["data"][0]["list"].arrayValue
                    weakSelf?.focusModels = {
                        var temps: [FriendCircleM] = []
                        for json in list {
                            let jsonString = String(describing: json)
                            if let model = JSONDeserializer<FriendCircleM>.deserializeFrom(json: jsonString) {
                                temps.append(model)
                            }
                        }
                        return temps
                    }()
                    
                    weakSelf?.focusCellHeights = {
                        var tempHeights:[CGFloat] = []
                        for model in self.focusModels {
                            let cellHeight = RecommendCell.cellHeight(model: model )
                            tempHeights.append(cellHeight)
                        }
                        return tempHeights
                    }()
                    weakSelf?.focusList.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
        }
    }
    
    func setupRecommendRequest() {
        self.recommendTable.mj_header.endRefreshing()
        weak var weakSelf = self
        let params = [
            "pageSize":"20",
            "pageIndex":"1",
            ]
        HttpAPIClient.apiClientPOST("biantaquanList", params: params, success: { (result) in
            if let dataResult = result {
                let json = JSON(dataResult)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let list = json["data"][0]["list"].arrayValue
                    weakSelf?.friendCircleModels = {
                        var temps: [FriendCircleM] = []
                        for json in list {
                            let jsonString = String(describing: json)
                            if let model = JSONDeserializer<FriendCircleM>.deserializeFrom(json: jsonString) {
                               temps.append(model)
                            }
                        }
                        return temps
                    }()
                    
                    weakSelf?.cellHeights = {
                        var tempHeights:[CGFloat] = []
                        for model in self.friendCircleModels {
                            let cellHeight = RecommendCell.cellHeight(model: model )
                            tempHeights.append(cellHeight)
                        }
                        return tempHeights
                    }()
                    weakSelf?.recommendTable.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
             Tool.showHUDTip(tipStr: "网络不给力")
        }
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

        /*
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "people_care"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.white
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :kContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
 */
    }
    
    fileprivate func prepareTableView() {
        recommendTable = UITableView.init()
        recommendTable.backgroundColor = kColorBackGround
        recommendTable.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.cellReuseIdentifier())
        recommendTable.dataSource = self
        recommendTable.delegate = self
        recommendTable.emptyDataSetSource = self
        recommendTable.emptyDataSetDelegate = self
        recommendTable.separatorStyle = .none
        recommendTable.tag = 100
        view.addSubview(recommendTable)
        recommendTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        focusList = UITableView.init()
        focusList.backgroundColor = kColorBackGround
        focusList.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.focusCellReuseIdentifier())
        focusList.dataSource = self
        focusList.delegate = self
        focusList.emptyDataSetSource = self
        focusList.emptyDataSetDelegate = self
        focusList.separatorStyle = .none
        focusList.tag = 101
        view.addSubview(focusList)
        focusList.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(-49)
        }
        
        recommendTable.isHidden = false
        focusList.isHidden = true
        
        let leftHeader = MJRefreshNormalHeader()
        leftHeader.setRefreshingTarget(self, refreshingAction: #selector(FriendCircleController.setupRecommendRequest))
        self.recommendTable.mj_header = leftHeader
        
        let rightHeader = MJRefreshNormalHeader()
        rightHeader.setRefreshingTarget(self, refreshingAction: #selector(FriendCircleController.setupFocusRequest))
        self.focusList.mj_header = rightHeader
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickWithSegmentedItem(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            recommendTable.isHidden = false
            focusList.isHidden = true
            setupRecommendRequest()
        }
        else {
            recommendTable.isHidden = true
            focusList.isHidden = false
            setupFocusRequest()
        }
    }
    
}

/// TableViewDataSource methods.
extension FriendCircleController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {
            return self.friendCircleModels.count
        }
        return self.focusModels.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100 {
            let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
            let model:FriendCircleM = self.friendCircleModels[indexPath.row]
            cell.setRecommendData(model: model)
            cell.commentSuccess = { () -> Void in
                self.setupRecommendRequest()
            }
            return cell
        }
        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.focusCellReuseIdentifier())
        let model:FriendCircleM = self.focusModels[indexPath.row]
        cell.setRecommendData(model: model)
        cell.commentSuccess = { () -> Void in
            self.setupFocusRequest()
        }
        return cell
    }
}

/// UITableViewDelegate methods.
extension FriendCircleController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 100 {
            return self.cellHeights[indexPath.row]
        }
        return self.focusCellHeights[indexPath.row]
    }
}

extension FriendCircleController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let emptyStr = NSAttributedString.init(string: "暂无数据哦！", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)])
        return emptyStr
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let emptyImg = UIImage.init(named: "no_data")
        return emptyImg
    }
}

extension FriendCircleController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
