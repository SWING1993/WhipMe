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
}

class FriendCircleController: UIViewController {
    
    
    fileprivate var cellHeights: [CGFloat] = []
    fileprivate var recommendTable: UITableView = UITableView()
    fileprivate var friendCircleModels: [FriendCircleM] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = kColorBackGround
        prepareTableView()
        prepareSegmented()
        setupRequest()
    }
    
    fileprivate func setupRequest() {
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
                    let list = json["data"][0]["list"].arrayObject
                    self.friendCircleModels = {
                        var temps: [FriendCircleM] = []
                        let tempArr = FriendCircleM.mj_objectArray(withKeyValuesArray: list)
                        for model in tempArr! {
                            temps.append(model as! FriendCircleM)
                        }
                        return temps
                    }()
                    
                    for model in self.friendCircleModels {
                        let cellHeight = RecommendCell.cellHeight(model: model )
                        self.cellHeights.append(cellHeight)
                    }
                    self.recommendTable.reloadData()
                    
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            print(error as Any);
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
        
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "people_care"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.white
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :kContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    fileprivate func prepareTableView() {
        recommendTable = UITableView.init()
        recommendTable.backgroundColor = kColorBackGround
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
        return self.friendCircleModels.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
        let model:FriendCircleM = self.friendCircleModels[indexPath.row]
        cell.setRecommendData(model: model)
        return cell
    }
}

/// UITableViewDelegate methods.
extension FriendCircleController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeights[indexPath.row]
    }
}
