//
//  AddWhipController.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class AddWhipController: UIViewController {

    fileprivate var myTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = UIColor.white
        prepareSegmented()
        prepareTableView()
    }
    
    fileprivate func prepareTableView() {
        myTable = UITableView.init()
        myTable.register(FirstAddCustomCell.self, forCellReuseIdentifier: FirstAddCustomCell.cellReuseIdentifier())
        myTable.register(SecondAddCustomCell.self, forCellReuseIdentifier: SecondAddCustomCell.cellReuseIdentifier())
        myTable.dataSource = self
        myTable.delegate = self
        myTable.showsVerticalScrollIndicator = false
        myTable.separatorStyle = .none
        view.addSubview(myTable)
        myTable.translatesAutoresizingMaskIntoConstraints = false
        myTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    fileprivate func prepareSegmented() {
        let titles_nav: NSArray = ["热门","自定义"]
        let segmentedView: UISegmentedControl = UISegmentedControl.init(items: titles_nav as [AnyObject])
        segmentedView.frame = CGRect(x: 0, y: 0, width: 132.0, height: 30.0)
        segmentedView.backgroundColor = KColorNavigation
        segmentedView.layer.cornerRadius = segmentedView.height/2.0
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.borderColor = UIColor.white.cgColor
        segmentedView.layer.borderWidth = 1.0
        segmentedView.tintColor = UIColor.white
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action:#selector(clickWithSegmentedItem), for: UIControlEvents.valueChanged)
        self.navigationItem.titleView = segmentedView
    }
    
    func clickWithSegmentedItem(_ sender: UISegmentedControl) {
        print(sender.numberOfSegments+sender.selectedSegmentIndex)
    }

}

/// TableViewDataSource methods.
extension AddWhipController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 4
        }
        else if section == 2 {
            return 1
        }
        else {
            return 0
        }
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell: FirstAddCustomCell = FirstAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: FirstAddCustomCell.cellReuseIdentifier())
            return cell
        }
        if indexPath.section == 1 {
            let cell: SecondAddCustomCell = SecondAddCustomCell.init(style: UITableViewCellStyle.default, reuseIdentifier: SecondAddCustomCell.cellReuseIdentifier())
            return cell
        }
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "subtitlecell")
        return cell
    }
}


/// UITableViewDelegate methods.
extension AddWhipController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return FirstAddCustomCell.cellHeight()
        }
        if indexPath.section == 1 {
            return SecondAddCustomCell.cellHeight()
        }
        return 0
    }
    
    //    /// Sets the tableView header height.
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 200
    //    }
    //    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return 15
    //    }
    
}
