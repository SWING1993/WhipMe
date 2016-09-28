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
    var myCostomAM = PlanM.init()

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
        self.view.backgroundColor = Define.kColorBackGround()
        alarmClockTable = UITableView.init()
        alarmClockTable.register(LeftTextCell.self, forCellReuseIdentifier: LeftTextCell.cellReuseIdentifier())
        alarmClockTable.register(CenterTextCell.self, forCellReuseIdentifier: CenterTextCell.cellReuseIdentifier())
        alarmClockTable.register(WeekCell.self, forCellReuseIdentifier: WeekCell.cellReuseIdentifier())
        alarmClockTable.separatorStyle = .none
        alarmClockTable.delegate = self
        alarmClockTable.dataSource = self
        alarmClockTable.isScrollEnabled = false
        alarmClockTable.layer.masksToBounds = true
        alarmClockTable.layer.cornerRadius = 5
        alarmClockTable.rowHeight = WeekCell.cellHeight()
        self.view.addSubview(alarmClockTable)
        alarmClockTable.snp.makeConstraints { (make) in
            make.height.equalTo(174)
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
    }
}

extension AlarmClockController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            weak var weakSelf = self
            let weakCell:CenterTextCell = alarmClockTable.cellForRow(at: indexPath) as! CenterTextCell
            SGHDateView.sharedInstance.pickerMode = .time
            SGHDateView.sharedInstance.show();
            SGHDateView.sharedInstance.cancelBlock = { () -> Void in
                weakCell.cellTitle?.text = "点击设置"
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getAlarmClockK()), object: weakSelf?.myCostomAM)
            }
            SGHDateView.sharedInstance.okBlock = { (date) -> Void in
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                weakCell.cellTitle?.text = formatter.string(from: date as Date)
                self.myCostomAM.alarmClock = date as NSDate?
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getAlarmClockK()), object: weakSelf?.myCostomAM)
            }
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
        if indexPath.row == 0 {
            let cell: LeftTextCell = LeftTextCell.init(style: UITableViewCellStyle.default, reuseIdentifier: LeftTextCell.cellReuseIdentifier())
            cell.cellTitle.text = "写代码"
            return cell
        }
        else if indexPath.row == 1 {
            let cell: CenterTextCell = CenterTextCell.init(style: UITableViewCellStyle.default, reuseIdentifier: CenterTextCell.cellReuseIdentifier())
            cell.cellTitle.text = "点击设置"
            return cell
        }
        else if indexPath.row == 2 {
            let cell: WeekCell = WeekCell.init(style: UITableViewCellStyle.default, reuseIdentifier: WeekCell.cellReuseIdentifier())
            return cell
        }
        let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        return cell
    }
}
