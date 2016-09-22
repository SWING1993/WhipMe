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

//定义闭包类型（特定的函数类型函数类型）
//typealias InputClosureType = (IndexPath) -> Void

class SecondAddCustomCell: UITableViewCell {
    
    //接收上个页面穿过来的闭包块
    var backClosure:((IndexPath) -> Void)?
//    //闭包变量的Seter方法
//    func setBackMyClosure(tempClosure:@escaping  InputClosureType) {
//        self.backClosure = tempClosure
//    }
    
    var alarmClockBlock : ((CustomAddM) -> Void)?
    var privacydBlock : ((CustomAddM) -> Void)?
    
    var bgView : UIView!
    var table : UITableView!
    var myCostomAM = CustomAddM.init()
    
    let itmes = ["开始时间", "结束时间", "闹钟设置", "隐私习惯"]
    
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
        let costomAM:CustomAddM = notification.object as! CustomAddM
        myCostomAM.startTime = costomAM.startTime
        table.reloadData()
    }
    
    func setEndTime(notification:Notification) -> Void {
        let costomAM:CustomAddM = notification.object as! CustomAddM
        myCostomAM.endTime = costomAM.endTime
        table.reloadData()
    }

    
    func setAlarmClock(notification:Notification) -> Void {
        let costomAM:CustomAddM = notification.object as! CustomAddM
        myCostomAM.alarmClock = costomAM.alarmClock
        table.reloadData()
        if self.alarmClockBlock != nil {
            self.alarmClockBlock!(self.myCostomAM)
        }
    }

    func setPrivacy(notification:Notification) -> Void {
        let costomAM:CustomAddM = notification.object as! CustomAddM
        myCostomAM.privacy = costomAM.privacy
        table.reloadData()
        if self.privacydBlock != nil {
            self.alarmClockBlock!(self.myCostomAM)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = KColorBackGround
        self.selectionStyle = .none
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(setStartTime), name: NSNotification.Name(rawValue: SecondAddCustomCell.getStartTimeK()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setEndTime), name: NSNotification.Name(rawValue: SecondAddCustomCell.getEndTimeK()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setAlarmClock), name: NSNotification.Name(rawValue: SecondAddCustomCell.getAlarmClockK()), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPrivacy), name: NSNotification.Name(rawValue: SecondAddCustomCell.getPrivacyK()), object: nil)
    
        
        if bgView == nil {
            bgView = UIView.init()
            bgView.backgroundColor = UIColor.white
            bgView.layer.cornerRadius = 5.0
            bgView.layer.masksToBounds = true
            self.addSubview(bgView)
            bgView.snp.makeConstraints { (make) in
                make.top.equalTo(kTopMargin)
                make.bottom.equalTo(kBottomMargin)
                make.left.equalTo(kLeftMargin)
                make.right.equalTo(kRightMargin)            }
        }
        
        if table == nil {
            table = UITableView.init()
            table.dataSource = self
            table.delegate = self
            table.isScrollEnabled = false
            bgView.addSubview(table)
            table.snp.makeConstraints { (make) in
                make.top.equalTo(2)
                make.left.right.equalTo(0)
                make.height.equalTo(200)
            }
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 10)
        cell.textLabel?.text = itmes[indexPath.row]

        cell.detailTextLabel?.text = "未设置"

        switch indexPath.row {
        case 0:
            if myCostomAM.startTime != nil {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                cell.detailTextLabel?.text = formatter.string(from: myCostomAM.startTime as! Date)
            }
            else {
                cell.detailTextLabel?.text = "未设置"
            }
            break
        case 1:
            if myCostomAM.endTime != nil {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                cell.detailTextLabel?.text = formatter.string(from: myCostomAM.endTime as! Date)
            }
            else {
                cell.detailTextLabel?.text = "未设置"
            }
            break
        case 2:
            if myCostomAM.alarmClock != nil {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                cell.detailTextLabel?.text = formatter.string(from: myCostomAM.alarmClock as! Date)
            }
            else {
                cell.detailTextLabel?.text = "未设置"
            }
            break
        case 3:
            if myCostomAM.privacy == PrivacyType.all {
                cell.detailTextLabel?.text = "所有人可见"
            }
            
            else if myCostomAM.privacy == PrivacyType.myFollow {
                cell.detailTextLabel?.text = "仅我关注的人可见"
            }
            
            else if myCostomAM.privacy == PrivacyType.mySelf {
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

