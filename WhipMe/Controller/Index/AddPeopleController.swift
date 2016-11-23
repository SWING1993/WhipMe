//
//  AddPeopleController.swift
//  WhipMe
//
//  Created by Song on 2016/11/17.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SwiftyJSON


class FansM: NSObject {
    var num: String = ""
    var userId: String = ""
    var icon: String = ""
    var nickname: String = ""
}

class FansCell: UITableViewCell {
    
    var iconV: UIImageView = UIImageView()
    var nicknameL: UILabel = UILabel()
    var numL: UILabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        iconV.layer.cornerRadius = 22.5
        iconV.layer.masksToBounds = true
        self.contentView.addSubview(iconV)
        iconV.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 45, height: 45))
            make.left.equalTo(25)
            make.centerY.equalTo(self)
        }
        
        nicknameL.font = UIFont.systemFont(ofSize: 16)
        nicknameL.textColor = kColorBlack
        nicknameL.textAlignment = .left
        self.contentView.addSubview(nicknameL)
        nicknameL.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 150, height: 20))
            make.left.equalTo(iconV.snp.right).offset(25)
            make.centerY.equalTo(self)
        }
        
        numL.font = UIFont.systemFont(ofSize: 12)
        numL.textColor = kColorGary
        numL.textAlignment = .right
        self.contentView.addSubview(numL)
        numL.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 150, height: 20))
            make.right.equalTo(-25)
            make.centerY.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellReuseIdentifier() -> String {
        return "FansCell"
    }
}

class SystemView: UIView {
    var numL: UILabel = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = kColorBackGround
        let bgview: UIImageView = UIImageView.init()
        bgview.image = UIImage.init(named: "bg_icon")
        bgview.contentMode = .scaleAspectFit
        bgview.layer.masksToBounds = true
        bgview.layer.cornerRadius = 5
        bgview.backgroundColor = UIColor.white
        bgview.frame = CGRect.init(x: 10, y: 10, width: frame.width - 20, height: frame.height - 20)
        self.addSubview(bgview)

        let headV: UIImageView = UIImageView.init()
        headV.image = UIImage.init(named: "system_monitoring")
        headV.contentMode = .scaleAspectFill
        bgview.addSubview(headV)
        headV.snp.makeConstraints { (make) in
            make.top.equalTo(7.5)
            make.size.equalTo(CGSize.init(width: 67.5, height: 67.5))
            make.centerX.equalTo(self)
        }
        
        let title = UILabel.init()
        title.text = "小编君"
        title.font = UIFont.systemFont(ofSize: 16)
        title.textAlignment = .center
        bgview.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(headV.snp.bottom).offset(5)
            make.size.equalTo(CGSize.init(width: 200, height: 20))
            make.centerX.equalTo(self)
        }
        
        numL.font = UIFont.systemFont(ofSize: 12.5)
        numL.textAlignment = .center
        numL.textColor = kColorGary
        bgview.addSubview(numL)
        numL.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.size.equalTo(CGSize.init(width: 200, height: 20))
            make.centerX.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AddPeopleController: UIViewController {

    var chooseSupervisor:((IndexPath) -> Void)?

    var myTable: UITableView = UITableView.init()
    var systemView: SystemView = SystemView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 160))
    var myFansArr: NSMutableArray = NSMutableArray.init()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    func startRequests() {
        
        let params = ["userId":UserManager.getUser().userId]
        HttpAPIClient.apiClientPOST("querySupervisor", params: params, success: { (result) in
            print(result!)
            if (result != nil) {
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
                    let btNum  = json["data"][0]["btNum"].stringValue
                    self.systemView.numL.text = "正在监督"+btNum+"人"
                    let list  = json["data"][0]["list"].arrayObject
                    self.myFansArr = FansM.mj_objectArray(withKeyValuesArray: list)
                    
                    let tableH: CGFloat = CGFloat(self.myFansArr.count) * 65.0
                    self.myTable.snp.updateConstraints { (make) in
                        make.height.equalTo(tableH)
                    }
                    self.myTable.reloadData()
                    
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            print(error as Any);
        }
    }
    
    func setup() {
        self.navigationItem.title = "选择监督人"
        self.view.backgroundColor = kColorBackGround
        
        self.view.addSubview(self.systemView)
        
        myTable.register(FansCell.self, forCellReuseIdentifier: FansCell.cellReuseIdentifier())

        myTable.delegate = self
        myTable.dataSource = self
        myTable.isScrollEnabled = false
        myTable.layer.masksToBounds = true
        myTable.layer.cornerRadius = 5
        myTable.rowHeight = 65.0
        myTable.backgroundColor = UIColor.white
        
        self.view.addSubview(myTable)
        myTable.snp.makeConstraints { (make) in
            make.top.equalTo(systemView.snp.bottom)
            make.height.equalTo(0)
            make.left.equalTo(kLeftMargin)
            make.right.equalTo(kRightMargin)
        }
        
        let OKBtn = UIBarButtonItem.init()
        self.navigationItem.rightBarButtonItem = OKBtn
        
        weak var weakSelf = self
        OKBtn.bk_init(withTitle: "确定", style: .plain) { (sender) in
            _ = weakSelf?.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddPeopleController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.myFansArr.count
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FansCell = FansCell.init(style: UITableViewCellStyle.default, reuseIdentifier: FansCell.cellReuseIdentifier())
        let myFansM: FansM = self.myFansArr.object(at: indexPath.row) as! FansM
        cell.iconV.setImageWith(urlString: myFansM.icon, placeholderImage: "")
        print(myFansM.icon)
        cell.nicknameL.text = myFansM.nickname
        cell.numL.text = "正在监督"+myFansM.num+"人"
        return cell
    }
}

extension AddPeopleController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

