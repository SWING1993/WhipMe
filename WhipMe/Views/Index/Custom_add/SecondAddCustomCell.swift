//
//  SecondAddCustomCell.swift
//  WhipMe
//
//  Created by Song on 16/9/18.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

//定义闭包类型（特定的函数类型函数类型）
typealias InputClosureType = (IndexPath) -> Void

class SecondAddCustomCell: UITableViewCell {
    
    //接收上个页面穿过来的闭包块
    var backClosure:InputClosureType?
    
    //闭包变量的Seter方法
    func setBackMyClosure(tempClosure:@escaping  InputClosureType) {
        self.backClosure = tempClosure
    }
    
    var bgView : UIView!
    var table : UITableView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = KColorBackGround
        self.selectionStyle = .none
        
        
        if bgView == nil {
            bgView = UIView.init()
            bgView.backgroundColor = UIColor.white
            bgView.layer.cornerRadius = 5.0
            bgView.layer.masksToBounds = true
            self.addSubview(bgView)
            bgView.snp.makeConstraints { (make) in
                make.top.equalTo(9)
                make.bottom.equalTo(0)
                make.left.equalTo(9)
                make.right.equalTo(-9)
            }
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
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "开始时间"
            cell.detailTextLabel?.text = "2016.08.16"
            break
            
        case 1:
            cell.textLabel?.text = "结束时间"
            cell.detailTextLabel?.text = "未设置"
            break

        case 2:
            cell.textLabel?.text = "闹钟设置"
            cell.detailTextLabel?.text = "未设置"
            break

        case 3:
            cell.textLabel?.text = "隐私习惯"
            cell.detailTextLabel?.text = "所有人可见"
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

