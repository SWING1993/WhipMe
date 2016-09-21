//
//  AlarmClockController.swift
//  WhipMe
//
//  Created by Song on 16/9/21.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class AlarmClockController: UIViewController {

    
    var alarmClockTable = UITableView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.navigationItem.title = "闹钟提醒"
        self.view.backgroundColor = KColorBackGround
        alarmClockTable = UITableView.init()
        alarmClockTable.register(WeekCell.self, forCellReuseIdentifier: WeekCell.cellReuseIdentifier())
        alarmClockTable.delegate = self
        alarmClockTable.dataSource = self
        alarmClockTable.isScrollEnabled = false
        alarmClockTable.layer.masksToBounds = true
        alarmClockTable.layer.cornerRadius = 5
        alarmClockTable.rowHeight = 58.0
        self.view.addSubview(alarmClockTable)
        alarmClockTable.snp.makeConstraints { (make) in
            make.height.equalTo(148)
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }
}

extension AlarmClockController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 0:
//            myCostomAM.privacy = PrivacyType.all
            break
            
        case 1:
//            myCostomAM.privacy = PrivacyType.myFollow
            break
            
        case 2:
//            myCostomAM.privacy = PrivacyType.mySelf
            break
            
        default:
            break
        }
    }
}

extension AlarmClockController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeekCell = WeekCell.init(style: UITableViewCellStyle.default, reuseIdentifier: WeekCell.cellReuseIdentifier())
        return cell
    }

}
