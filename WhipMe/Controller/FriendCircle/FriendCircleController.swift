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
    
    private let recommendTable: UITableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        prepareTableView()
    }
    
    private func setup() {
        let titles_nav: NSArray = ["推荐","关注"]
        let segmentedView: UISegmentedControl = UISegmentedControl.init(items: titles_nav as [AnyObject])
        segmentedView.frame = CGRectMake(0, 0, 132.0, 30.0)
        segmentedView.backgroundColor = KColorNavigation
        segmentedView.layer.cornerRadius = segmentedView.height/2.0
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.borderColor = UIColor.whiteColor().CGColor
        segmentedView.layer.borderWidth = 1.0
        segmentedView.tintColor = UIColor.whiteColor()
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action:#selector(clickWithNavItem), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = segmentedView
        
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "people_care"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.whiteColor()
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :KContentFont, kCTForegroundColorAttributeName as String:UIColor.whiteColor()], forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = rightBarItem
        
    }
    
    func clickWithNavItem(sender: UISegmentedControl) {
        print(sender.numberOfSegments+sender.selectedSegmentIndex)
    }
    
    func clickWithRightBarItem() {
        print(NSStringFromClass(self.classForCoder))
    }
    
    func loadData() {
        
    }
 
    private func prepareTableView() {
        recommendTable.registerClass(RecommendCell.self, forCellReuseIdentifier: "Cell")
        recommendTable.dataSource = self
        recommendTable.delegate = self
        recommendTable.separatorStyle = .None
        view.addSubview(recommendTable)
        recommendTable.translatesAutoresizingMaskIntoConstraints = false
        recommendTable.snp_makeConstraints { (make) in
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = .None
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
