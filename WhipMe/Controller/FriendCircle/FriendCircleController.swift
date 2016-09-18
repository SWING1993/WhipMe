//
//  FriendCircleController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SnapKit
class FriendCircleController: RootViewController {
    
    fileprivate let recommendTable: UITableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        prepareTableView()
    }
    
    fileprivate func setup() {
        let titles_nav: NSArray = ["推荐","关注"]
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
        
    }
    
    func clickWithNavItem(_ sender: UISegmentedControl) {
        print(sender.numberOfSegments+sender.selectedSegmentIndex)
    }
    
    func clickWithRightBarItem() {
        print(NSStringFromClass(self.classForCoder))
    }
    
    func loadData() {
        
    }
 
    fileprivate func prepareTableView() {
        recommendTable.register(RecommendCell.self, forCellReuseIdentifier: "Cell")
        recommendTable.dataSource = self
        recommendTable.delegate = self
        recommendTable.separatorStyle = .none
        view.addSubview(recommendTable)
        recommendTable.translatesAutoresizingMaskIntoConstraints = false
        recommendTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
//        recommendTable.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { 
//            self.loadData()
//        })
//        self.tableView.mj_header.beginRefreshing()
//        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget:self, refreshingAction:#selector(TodayController.callMeFooter))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

/// TableViewDataSource methods.
extension FriendCircleController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.selectionStyle = .none
//        let item: Item = items[indexPath.section]
//        cell.pictrueView.sd_setImageWithURL(NSURL.init(string: item.thumb_hd))
//        cell.contentLabel.text = item.content
        return cell
    }
}
//extension FriendCircleController: UITableViewDataSource {

//    
//    
//    
//    //    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//    //        let tableViewFooter = UIView(frame: CGRectMake(0, 0, view.bounds.width, 15))
//    //        tableViewFooter.backgroundColor = MaterialColor.grey.base
//    //        return tableViewFooter
//    //    }
//    
////    //didDeselectRowAtIndexPath
////    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
////        
////        
////        self.photos.removeAllObjects()
////        
////        let item: Item = items[indexPath.section]
////        let photo :MWPhoto = MWPhoto.init(URL: NSURL.init(string: item.cover_hd_568h as String))
////        photo.caption =  item.content as String
////        self.photos.addObject(photo)
////        let browser:MWPhotoBrowser = MWPhotoBrowser.init()
////        browser.delegate = self
////        browser.title = item.title as String
////        browser.setCurrentPhotoIndex(0)
////        self.navigationController?.pushViewController(browser, animated: true)
////        
////    }
//}

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
