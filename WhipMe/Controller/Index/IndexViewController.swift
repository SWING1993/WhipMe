//
//  IndexViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SnapKit

class IndexViewController: UIViewController {
    
    fileprivate var myTable: UITableView!

    var dataArray :NSMutableArray?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dataArray?.removeAllObjects()
        if PlanM.getPlans() != nil {
            for (_, value) in PlanM.getPlans()!.enumerated() {
                self.dataArray?.add(value)
            }
            self.myTable?.reloadData()
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    fileprivate func setup() {
        self.navigationItem.title = "鞭挞"
        self.dataArray = NSMutableArray.init()

        self.view.backgroundColor = Define.kColorBackGround()
        prepareTableView()
        let addBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(clickWithRightBarItem))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    fileprivate func prepareTableView() {
        myTable = UITableView.init()
//        myTable.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.cellReuseIdentifier())
        myTable?.dataSource = self
        myTable?.delegate = self
        myTable?.emptyDataSetSource = self
        myTable?.emptyDataSetDelegate = self
//        myTable?.separatorStyle = .none
        view.addSubview(myTable!)
        myTable?.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickWithRightBarItem() {
//        let addWhipC = AddWhipController.init()
//        addWhipC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(addWhipC, animated: true)
        let addWhipC = LogController.init()
        addWhipC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addWhipC, animated: true)
    }
}

/// TableViewDataSource methods.
extension IndexViewController:UITableViewDataSource {
    // Determines the number of rows in the tableView.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
        let cell:UITableViewCell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        
        let model:PlanM? = self.dataArray?.object(at: indexPath.row) as! PlanM?
        cell.textLabel?.text = model?.title
        
        
        var str :String = String.init()
        
        if model?.alarmClock != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let alarmS = "提醒时间：" + formatter.string(from: (model?.alarmClock)! as Date)
            str.append(alarmS)
        }
        
        if model?.startTime != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let alarmS = "开始时间：" + formatter.string(from: (model?.startTime)! as Date)
            str.append(alarmS)
        }

        if model?.endTime != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let alarmS = "结束时间：" + formatter.string(from: (model?.endTime)! as Date)
            str.append(alarmS)
        }
        cell.detailTextLabel?.text = str
        
        return cell
    }
}


/// UITableViewDelegate methods.
extension IndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension IndexViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        let emptyStr = NSAttributedString.init(string: "暂无数据哦!")
        return emptyStr
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let emptyImg = UIImage.init(named: "no_data")
        return emptyImg
    }
}

extension IndexViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

