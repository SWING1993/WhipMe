//
//  SecondAddCustomCell.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SecondAddCustomCell: NormalCell {
    
    //接收上个页面穿过来的闭包块
    let itmes = ["开始时间", "结束时间", "闹钟设置", "隐私习惯"]
    var backClosure:((IndexPath) -> Void)?
    var alarmClockBlock : ((AddTaskM) -> Void)?
    var privacydBlock : ((AddTaskM) -> Void)?
    
    var table = UITableView()
    var addTask = AddTaskM()
    
    func setAddTask(task:AddTaskM) {
        self.addTask = task
        self.table.reloadData()
    }
    
    class func getStartTimeK() -> String {
        return "getStartTimeK";
    }
    class func getEndTimeK() -> String {
        return "getEndTimeK";
    }
    class func getAlarmClockK() -> String {
        return "getAlarmClockK";
    }
    class func getPrivacyK() -> String {
        return "getPrivacyK";
    }
    
    func setStartTime(notification:Notification) -> Void {
        let costomAM:AddTaskM = notification.object as! AddTaskM
        addTask.startDate = costomAM.startDate
        table.reloadData()
    }
    
    func setEndTime(notification:Notification) -> Void {
        let costomAM:AddTaskM = notification.object as! AddTaskM
        addTask.endDate = costomAM.endDate
        table.reloadData()
    }

    
    func setAlarmClock(notification:Notification) -> Void {
        let costomAM:AddTaskM = notification.object as! AddTaskM
        addTask.clockTime = costomAM.clockTime
        table.reloadData()
        if self.alarmClockBlock != nil {
            self.alarmClockBlock!(self.addTask)
        }
    }

    func setPrivacy(notification:Notification) -> Void {
        let costomAM:AddTaskM = notification.object as! AddTaskM
        addTask.privacy = costomAM.privacy
        table.reloadData()
        if self.privacydBlock != nil {
            self.privacydBlock!(self.addTask)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = kColorBackGround
        self.selectionStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(setStartTime), name: NSNotification.Name(rawValue: SecondAddCustomCell.getStartTimeK()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setEndTime), name: NSNotification.Name(rawValue: SecondAddCustomCell.getEndTimeK()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setAlarmClock), name: NSNotification.Name(rawValue: SecondAddCustomCell.getAlarmClockK()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPrivacy), name: NSNotification.Name(rawValue: SecondAddCustomCell.getPrivacyK()), object: nil)
    
        table.dataSource = self
        table.delegate = self
        table.isScrollEnabled = false
        table.layer.masksToBounds = true
        self.bgView.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(200)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellHeight() -> CGFloat {
        return 210
    }
    
    class func cellReuseIdentifier() -> String {
        return "SecondAddCustomCell"
    }
}

/// TableViewDataSource methods.
extension SecondAddCustomCell:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.5)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.text = itmes[indexPath.row]

        cell.detailTextLabel?.text = "未设置"

        switch indexPath.row {
        
        case 0:
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone.system
                formatter.dateFormat = "yyyy.MM.dd"
                cell.detailTextLabel?.text = addTask.startDate?.string(format: .custom("yyyy.MM.dd"))
            break
        
        case 1:
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone.system
                formatter.dateFormat = "yyyy.MM.dd"
                cell.detailTextLabel?.text = addTask.endDate?.string(format: .custom("yyyy.MM.dd"))
            break
        
        case 2:
                cell.detailTextLabel?.text = addTask.clockTime?.string(format: .custom("HH:mm"))
            break
        
        case 3:
            if addTask.privacy == PrivacyType.all {
                cell.detailTextLabel?.text = "所有人可见"
            }
            
            else if addTask.privacy == PrivacyType.myFollow {
                cell.detailTextLabel?.text = "仅我关注的人可见"
            }
            
            else if addTask.privacy == PrivacyType.mySelf {
                cell.detailTextLabel?.text = "仅自己可见"
            }
            else {
                cell.detailTextLabel?.text = "未设置"
            }
            break
        
        default:
            break
        }
        
        return cell
    }
}


/// UITableViewDelegate methods.
extension SecondAddCustomCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.backClosure != nil {
            self.backClosure!(indexPath)
        }
    }
}

