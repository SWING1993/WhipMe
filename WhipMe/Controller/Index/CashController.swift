//
//  CashController.swift
//  WhipMe
//
//  Created by Song on 2016/11/23.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SwiftyJSON

class CashController: UIViewController {

    var addTask = AddTaskM()
    var myTable = UITableView()
    let rechargeTextFiele = UITextField()
    var account = "0.00"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        steup()
        setupRequest()
    }
    
    func steup() {
        self.navigationItem.title = "自由服务费设置"
        self.view.backgroundColor = kColorBackGround
        
        myTable.register(NormalCell.self, forCellReuseIdentifier: "myCell")
        
        myTable.delegate = self
        myTable.dataSource = self
        myTable.isScrollEnabled = false
        myTable.layer.masksToBounds = true
        myTable.layer.cornerRadius = 5
        myTable.rowHeight = 65.0
        myTable.backgroundColor = UIColor.white
        myTable.separatorStyle = .none
        self.view.addSubview(myTable)
        myTable.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.height.equalTo(205)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        let OKBtn = UIBarButtonItem.init()
        self.navigationItem.rightBarButtonItem = OKBtn
        weak var weakSelf = self
        OKBtn.bk_init(withTitle: "完成", style: .plain) { (sender) in
            self.rechargeTextFiele.endEditing(true)
            if let guarantee = self.rechargeTextFiele.text {
                if let value1: Double = Double(guarantee) {
                    if let value2: Double = Double(self.account) {
                        if value1 > value2 {
                            Tool.showHUDTip(tipStr: "余额不足！")
                            return
                        }
                    }
                } else {
                    Tool.showHUDTip(tipStr: "请填写正确的金额！")
                    return
                }
                
                let tipStr = "确认自由服务费为"+guarantee+"元，完成任务将退还，未完成任务将不退还。"
                let tip = UIAlertView.init(title: tipStr, message: "", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                tip.show()
                tip.bk_setHandler({ 
                    weakSelf?.addTask.guarantee = guarantee
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AddWhipController.addSupervisorKey()), object: weakSelf?.addTask)
                    weakSelf?.dismiss(animated: true, completion: { })

                }, forButtonAt: 1)
            }
        }
    }
    
    func setupRequest() {
        let params = [
            "userId":UserManager.shared.userId
        ]
        HttpAPIClient.apiClientPOST("queryAccountById", params: params, success: { (result) in
            if let dataResult = result {
                print(dataResult)
                let json = JSON(dataResult)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    self.account = json["data"][0]["account"].stringValue
                    self.myTable.reloadData()
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            Tool.showHUDTip(tipStr: "网络不给力")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CashController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NormalCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "myCell")
       
        if indexPath.section == 0 {
            let iconV = UIImageView()
            iconV.image = UIImage.init(named: "balance")
            cell.bgView.addSubview(iconV)
            iconV.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 23, height: 23))
                make.centerY.equalTo(cell.bgView)
                make.left.equalTo(15)
            })

            let cashL = UILabel()
            cashL.text = "余额：¥"+self.account
            cashL.font = UIFont.systemFont(ofSize: 16)
            cell.bgView.addSubview(cashL)
            cashL.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 150, height: 20))
                make.centerY.equalTo(cell.bgView)
                make.left.equalTo(iconV.snp.right).offset(15)
            })
            
            let rechargeBtn = UIButton()
            rechargeBtn.layer.masksToBounds = true
            rechargeBtn.layer.cornerRadius = 11.5
            rechargeBtn.backgroundColor = kColorBlue
            rechargeBtn.setTitleColor(kColorWhite, for: .normal)
            rechargeBtn.setTitle("充值", for: .normal)
            rechargeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.5)
            cell.bgView.addSubview(rechargeBtn)
            rechargeBtn.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 50, height: 23))
                make.centerY.equalTo(cell.bgView)
                make.right.equalTo(-15)
            })
            
            rechargeBtn.bk_(whenTapped: { 
                let rechargeVC = TopUpViewController()
                self.navigationController?.pushViewController(rechargeVC, animated: true)
            })
        }
        else {
            let iconV = UIImageView()
            iconV.image = UIImage.init(named: "Bond")
            iconV.image = UIImage.init(named: "balance")
            cell.bgView.addSubview(iconV)
            iconV.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 23, height: 23))
                make.top.equalTo(15)
                make.left.equalTo(15)
            })
            
            let cashL = UILabel()
            cashL.text = "自由服务费"
            cashL.font = UIFont.systemFont(ofSize: 16)
            cell.bgView.addSubview(cashL)
            cashL.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 150, height: 20))
                make.centerY.equalTo(iconV)
                make.left.equalTo(iconV.snp.right).offset(15)
            })
           
            rechargeTextFiele.font = UIFont.systemFont(ofSize: 13)
            rechargeTextFiele.keyboardType = .decimalPad
            rechargeTextFiele.placeholder = "请输入"
            rechargeTextFiele.textAlignment = .right
            cell.bgView.addSubview(rechargeTextFiele)
            rechargeTextFiele.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 100, height: 25))
                make.centerY.equalTo(iconV)
                make.right.equalTo(-45)
            })
            
            let label = UILabel()
            label.text = "元"
            label.font = UIFont.systemFont(ofSize: 16)
            cell.bgView.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 20, height: 20))
                make.centerY.equalTo(iconV)
                make.right.equalTo(-15)
            })
            
            let label2 = UILabel()
            label2.text = "自由服务费说明：自由服务费是用来约束并打赏监督者或被监督者的随机筹码，如果完成任务，则退还自由服务费，未达成任务，则归监督人所有。\n自由服务费金额在1-100元之间。"
            label2.numberOfLines = 0
            label2.font = UIFont.systemFont(ofSize: 11)
            label2.textColor = kYellow
            cell.bgView.addSubview(label2)
            label2.snp.makeConstraints({ (make) in
                make.top.equalTo(iconV.snp.bottom).offset(5)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.bottom.equalTo(-5)
            })
        }
        return cell
    }
}

extension CashController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80.0
        }
        return 125.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CashController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            self.rechargeTextFiele.resignFirstResponder()
        }
    }
}
