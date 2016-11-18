//
//  FinancialDetailsController.swift
//  WhipMe
//
//  Created by anve on 16/11/18.
//  Copyright © 2016年 -. All rights reserved.
//  钱包收支明细

import UIKit

class FinancialDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var arrayContent: NSMutableArray!
    fileprivate var tableViewWM: UITableView!
    fileprivate let identifier_cell = "financialDetailsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kColorBackGround
        self.navigationItem.title = "明细"

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        let line_head = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 10.0))
        line_head.backgroundColor = kColorBackGround
        
        let line_foot = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 10.0))
        line_foot.backgroundColor = kColorBackGround
        
        tableViewWM = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableViewWM.backgroundColor = UIColor.clear
        tableViewWM.delegate = self
        tableViewWM.dataSource = self
        tableViewWM.separatorStyle = UITableViewCellSeparatorStyle.none
        tableViewWM.tableFooterView = line_head
        tableViewWM.tableHeaderView = line_foot
        self.view.addSubview(tableViewWM)
        tableViewWM.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        tableViewWM.register(FinancialDetailsCell.classForCoder(), forCellReuseIdentifier: identifier_cell)
    }
    
    // MARK: - UITableViewDelegate Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FinancialDetailsCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FinancialDetailsCell = tableView.dequeueReusableCell(withIdentifier: identifier_cell) as! FinancialDetailsCell
        
        let model: Dictionary<String, String> = ["title":"充值", "time":"2016-11-18 13:56:12","money":"30","type":"1"]
        cell.cellModel(model: model)
        if (indexPath.row+1 == tableView.numberOfRows(inSection: indexPath.section)) {
            cell.lineView.isHidden = true
        } else {
            cell.lineView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

}
