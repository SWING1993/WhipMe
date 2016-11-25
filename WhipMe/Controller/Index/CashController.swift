//
//  CashController.swift
//  WhipMe
//
//  Created by Song on 2016/11/23.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class CashController: UIViewController {

    var myTable: UITableView = UITableView()
    let rechargeTextFiele = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        steup()
    }
    
    func steup() {
        self.navigationItem.title = "保证金设置"
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
            make.height.equalTo(175)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        let OKBtn = UIBarButtonItem.init()
        self.navigationItem.rightBarButtonItem = OKBtn
        
        weak var weakSelf = self
        OKBtn.bk_init(withTitle: "完成", style: .plain) { (sender) in
            _ = weakSelf?.navigationController?.popViewController(animated: true)
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
            cashL.text = "余额：¥200"
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
            cashL.text = "保证金"
            cashL.font = UIFont.systemFont(ofSize: 16)
            cell.bgView.addSubview(cashL)
            cashL.snp.makeConstraints({ (make) in
                make.size.equalTo(CGSize.init(width: 150, height: 20))
                make.centerY.equalTo(iconV)
                make.left.equalTo(iconV.snp.right).offset(15)
            })
           
            
            rechargeTextFiele.font = UIFont.systemFont(ofSize: 13)
            rechargeTextFiele.keyboardType = .numberPad
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
            label2.text = "保证金说明：如果未达成目标，则扣除保证金，保证金归监督人所有，如果达成目标，则退还保证金。"
            label2.numberOfLines = 2
            label2.font = UIFont.systemFont(ofSize: 9)
            label2.textColor = kColorGray
            cell.bgView.addSubview(label2)
            label2.snp.makeConstraints({ (make) in
                make.height.equalTo(35)
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
        return 95.0
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
