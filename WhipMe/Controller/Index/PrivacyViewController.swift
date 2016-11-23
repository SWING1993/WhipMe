//
//  PrivacyViewController.swift
//  WhipMe
//
//  Created by Song on 16/9/20.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    var myPrivacyTable: UITableView = UITableView()
    let items = ["所有人可见","仅我关注的人可见","仅自己可见"]
    var myCostomAM = PlanM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() -> Void {
        self.navigationItem.title = "隐私设置"
        self.view.backgroundColor = kColorBackGround
        myPrivacyTable = UITableView.init()
        myPrivacyTable.register(SelectedCell.self, forCellReuseIdentifier: SelectedCell.cellReuseIdentifier())
        myPrivacyTable.delegate = self
        myPrivacyTable.dataSource = self
        myPrivacyTable.isScrollEnabled = false
        myPrivacyTable.layer.masksToBounds = true
        myPrivacyTable.layer.cornerRadius = 5
        myPrivacyTable.rowHeight = 50.0
        self.view.addSubview(myPrivacyTable)
        myPrivacyTable.snp.makeConstraints { (make) in
            make.height.equalTo(148)
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        let OKBtn = UIBarButtonItem.init()
        self.navigationItem.rightBarButtonItem = OKBtn
        
        weak var weakSelf = self
        OKBtn.bk_init(withTitle: "确定", style: .plain) { (sender) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SecondAddCustomCell.getPrivacyK()), object: weakSelf?.myCostomAM)
            _ = weakSelf?.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension PrivacyViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectedCell = SelectedCell.init(style: UITableViewCellStyle.default, reuseIdentifier: SelectedCell.cellReuseIdentifier())
        cell.cellTitle.text = items[indexPath.row]
        return cell
    }

}

extension PrivacyViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        
        case 0:
            myCostomAM.privacy = PrivacyType.all
            break
            
        case 1:
            myCostomAM.privacy = PrivacyType.myFollow
            break
            
        case 2:
            myCostomAM.privacy = PrivacyType.mySelf
            break
            
        default:
            break
        }
    }
}
