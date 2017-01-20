//
//  QueryUserBlogC.swift
//  WhipMe
//
//  Created by Song on 2017/1/19.
//  Copyright © 2017年 -. All rights reserved.
//

import UIKit
import HandyJSON

class GrowM: HandyJSON {
    var creator: String = ""
    var endDate: String = ""
    var icon: String = ""
    var nickname: String = ""
    var recordNum: String = ""
    var startDate: String = ""
    var taskId: String = ""
    var themeId: String = ""
    var themeName: String = ""
    var threeDay: [Any] = []
    
    required init() {}

}

class UserBlogM: HandyJSON {
    var myGrow: [GrowM] = []
    var mySupervise: [GrowM] = []
    var userInfo: [String: String] = [:]
    
    required init() {}

}

class UserBlogCell: NormalCell {
    
    var myGrowM = GrowM()
    var themeLabel = UILabel()
    var dateLabel = UILabel()
    var recordNumLabel = UILabel()
    var firstPic = UIImageView()
    var secondPic = UIImageView()
    var thirdPic = UIImageView()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        themeLabel.backgroundColor = UIColor.random()
        self.bgView.addSubview(themeLabel)
        themeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(20)
            make.top.equalTo(15)
        }
        
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.backgroundColor = UIColor.random()
        self.bgView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(themeLabel.snp.left)
            make.height.equalTo(themeLabel.snp.height)
            make.top.equalTo(themeLabel.snp.bottom).offset(15)
            make.width.equalTo(150)
        }
        
        recordNumLabel.textAlignment = .right
        recordNumLabel.backgroundColor = UIColor.random()
        self.bgView.addSubview(recordNumLabel)
        recordNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(themeLabel.snp.right)
            make.height.equalTo(themeLabel.snp.height)
            make.top.equalTo(themeLabel.snp.bottom).offset(15)
            make.width.equalTo(150)
        }
        
        
        firstPic.backgroundColor = UIColor.random()
        secondPic.backgroundColor = firstPic.backgroundColor
        thirdPic.backgroundColor = secondPic.backgroundColor
        
//        let space = 9
        let pic_W_H = (Define.screenWidth() - 66)/3
      
        secondPic.contentMode = .scaleToFill
        self.bgView.addSubview(secondPic)
        secondPic.snp.makeConstraints { (make) in
            make.top.equalTo(recordNumLabel.snp.bottom).offset(15)
            make.centerX.equalTo(self.bgView.snp.centerX)
            make.size.equalTo(CGSize.init(width: pic_W_H, height: pic_W_H))
        }
        
        firstPic.contentMode = .scaleToFill
        self.bgView.addSubview(firstPic)
        firstPic.snp.makeConstraints { (make) in
            make.top.equalTo(secondPic)
            make.left.equalTo(15)
            make.size.equalTo(CGSize.init(width: pic_W_H, height: pic_W_H))
        }
        
        thirdPic.contentMode = .scaleToFill
        self.bgView.addSubview(thirdPic)
        thirdPic.snp.makeConstraints { (make) in
            make.top.equalTo(secondPic)
            make.right.equalTo(-15)
            make.size.equalTo(CGSize.init(width: pic_W_H, height: pic_W_H))
        }

    }
    
    func setMyGrowMWith(model: GrowM) {
        self.myGrowM = model
        themeLabel.text = self.myGrowM.themeName
        dateLabel.text = self.myGrowM.startDate + " - " + self.myGrowM.endDate
        recordNumLabel.text = "已鞭挞" + self.myGrowM.recordNum + "次"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func cellHeight(model:GrowM) -> CGFloat {
        var height:CGFloat = 215
        return height
    }

    class func cellReuseIdentifier() -> String {
        return "QueryUserBlogCell"
    }
}

class QueryUserBlogC: UIViewController {

    var userBlogM = UserBlogM.init()
    var myTable = UITableView()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.setup()
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = kColorBackGround
        self.prepareViews()
        
        let backBtn: UIBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(QueryUserBlogC.goBack))
        self.navigationItem.leftBarButtonItem = backBtn
        
        let rightBtn: UIBarButtonItem = UIBarButtonItem.init(title: "关注", style: .plain, target: self, action: #selector(QueryUserBlogC.follow))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func goBack() {
        self.dismiss(animated: true) {
            
        }
    }
    
    // 添加关注
    func follow() {
    
    }
    

    fileprivate func prepareViews() {
        self.myTable.backgroundColor = kColorBackGround
        self.myTable.separatorStyle = .none
        self.myTable.register(UserBlogCell.self, forCellReuseIdentifier: UserBlogCell.cellReuseIdentifier())
        self.myTable.dataSource = self
        self.myTable.delegate = self
        self.view.addSubview(self.myTable)
        self.myTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension QueryUserBlogC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.userBlogM.myGrow.count
        } else {
            return self.userBlogM.mySupervise.count
        }
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserBlogCell = UserBlogCell.init(style: UITableViewCellStyle.default, reuseIdentifier: UserBlogCell.cellReuseIdentifier())
        if indexPath.section == 0 {
            let growM = self.userBlogM.myGrow[indexPath.row]
            cell.setMyGrowMWith(model: growM)
        } else {
            let growM = self.userBlogM.mySupervise[indexPath.row]
            cell.setMyGrowMWith(model: growM)
        }
        return cell
    }
}

extension QueryUserBlogC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }

}
