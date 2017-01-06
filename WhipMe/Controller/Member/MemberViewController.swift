//
//  MemberViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SwiftyJSON

class MemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var userModel: UserManager!
    fileprivate var tableViewWM: UITableView!
    fileprivate var superviseView: UIView!
    fileprivate var growView: UIView!
    private let identifier_member: String = "memberTableViewCell"
    private let identifier_head: String = "tableViewView_head"
    fileprivate var arraySupervise: NSMutableArray = NSMutableArray.init()
    fileprivate var arrayGrow: NSMutableArray = NSMutableArray.init()
    
    fileprivate var viewHead: UIView!
    fileprivate var imageHead: UIImageView!
    fileprivate var iconWallet: UIImageView!
    fileprivate var lblUserName: UILabel!
    fileprivate var lblDescribe: UILabel!
    
    fileprivate let kHead_WH: CGFloat = 60.0
    fileprivate let kItem_Tag: Int = 7777
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的"
        self.view.backgroundColor = kColorBackGround
        
        
        if (userModel == nil) {
            userModel = UserManager()
            userModel.username = "幽叶"
            userModel.nickname = "榴莲"
            userModel.icon = "system_monitoring"
            userModel.sex = true
            userModel.age = "22"
            userModel.birthday = "1992-10-05"
            userModel.sign = "寂寞的幻境，朦胧的身影"
        }
        
        setup()
        
        setData()
        queryByUserInfo();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setData() {
        self.imageHead.setImageWith(urlString: self.userModel.icon, placeholderImage: Define.kDefaultImageHead());
        self.lblUserName.text = self.userModel.nickname;
        self.lblDescribe.text = self.userModel.sign;
    }
    
    func setup() {
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "set_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        viewHead = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 145.0))
        viewHead.backgroundColor = UIColor.white
        
        let line_view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 14.0))
        line_view.backgroundColor = kColorBackGround
        
        tableViewWM = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableViewWM.backgroundColor = UIColor.clear
        tableViewWM.delegate = self
        tableViewWM.dataSource = self
        tableViewWM.separatorStyle = UITableViewCellSeparatorStyle.none
        tableViewWM.tableFooterView = line_view
        tableViewWM.tableHeaderView = viewHead
        self.view.addSubview(tableViewWM)
        tableViewWM.snp.updateConstraints { (make) in
            make.left.top.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        tableViewWM.register(MemberTableViewCell.classForCoder(), forCellReuseIdentifier: identifier_member)
        tableViewWM.register(MemberHeadViewCell.classForCoder(), forCellReuseIdentifier: identifier_head)
        
        imageHead = UIImageView.init()
        imageHead.backgroundColor = Define.kColorBackGround()
        imageHead.layer.cornerRadius = kHead_WH/2.0
        imageHead.layer.masksToBounds = true
        imageHead.contentMode = UIViewContentMode.scaleAspectFill
        imageHead.clipsToBounds = true
        imageHead.isUserInteractionEnabled = true;
        viewHead.addSubview(imageHead)
        imageHead.snp.updateConstraints { (make) in
            make.left.equalTo(self.viewHead).offset(20.0)
            make.top.equalTo(self.viewHead).offset(14.0)
            make.size.equalTo(CGSize.init(width: kHead_WH, height: kHead_WH))
        }
        
        let tapGr: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickWithHead))
        self.imageHead.addGestureRecognizer(tapGr)
        let str_userName: NSString = "学习者"
        
        lblUserName = UILabel.init()
        lblUserName.backgroundColor = UIColor.clear
        lblUserName.textColor = Define.RGBColorFloat(51, g: 51, b: 51)
        lblUserName.font = kButtonFont
        lblUserName.textAlignment = NSTextAlignment.left
        lblUserName.text = str_userName as String
        viewHead.addSubview(lblUserName)
        
        let size_userName: CGSize = str_userName.size(attributes: [NSFontAttributeName:kButtonFont])
        lblUserName.snp.updateConstraints { (make) in
            make.left.equalTo(self.imageHead.snp.right).offset(14.0)
            make.top.equalTo(24)
            make.width.equalTo(floorf(Float(size_userName.width))+1)
            make.height.equalTo(20)
        }
        
        iconWallet = UIImageView.init()
        iconWallet.backgroundColor = UIColor.clear
        iconWallet.image = UIImage.init(named: "wallet_green_off")
        viewHead.addSubview(iconWallet)
        iconWallet.snp.updateConstraints { (make) in
            make.left.equalTo(self.lblUserName.snp.right).offset(10)
            make.top.equalTo(self.lblUserName.snp.top)
            make.size.equalTo(CGSize.init(width: 20.0, height: 20.0))
        }
        
        lblDescribe = UILabel.init()
        lblDescribe.backgroundColor = UIColor.clear
        lblDescribe.textColor = kColorGray
        lblDescribe.font = UIFont.systemFont(ofSize: 13.0)
        lblDescribe.textAlignment = NSTextAlignment.left
        lblDescribe.text = "监督，是一种责任！"
        viewHead.addSubview(lblDescribe)
        lblDescribe.snp.updateConstraints { (make) in
            make.left.equalTo(self.imageHead.snp.right).offset(14.0)
            make.top.equalTo(self.lblUserName.snp.bottom).offset(10.0)
            make.right.equalTo(self.viewHead).offset(-20.0)
            make.height.equalTo(20)
        }
        
        let line_head = UIView.init()
        line_head.backgroundColor = kColorLine
        viewHead.addSubview(line_head)
        line_head.snp.updateConstraints { (make) in
            make.left.equalTo(self.viewHead)
            make.width.equalTo(self.viewHead)
            make.top.equalTo(89.5)
            make.height.equalTo(0.5)
        }
        
        let view_item = UIView.init()
        view_item.backgroundColor = UIColor.clear
        viewHead.addSubview(view_item)
        view_item.snp.updateConstraints { (make) in
            make.left.equalTo(self.viewHead)
            make.width.equalTo(self.viewHead)
            make.top.equalTo(90.0)
            make.height.equalTo(55.0)
        }
        
        let titles: NSArray = ["钱包","关注","粉丝"];
        var image_normal = UIImage.imageWithDraw(Define.RGBColorFloat(247, g: 247, b: 247), sizeMake: CGRect.init(x: 0, y: 0, width: 20.0, height: 20.0))
        image_normal = image_normal.stretchableImage(withLeftCapWidth: 10, topCapHeight: 10)
        var origin_x: CGFloat = 0.0
        let size_item_w: CGFloat = Define.screenWidth()/3.0
        var item_tag = kItem_Tag
        for itemStr in titles {
            let itemButton = UIButton.init(type: UIButtonType.custom)
            itemButton.setBackgroundImage(UIImage.init(), for: UIControlState.normal)
            itemButton.setBackgroundImage(image_normal, for: UIControlState.highlighted)
            itemButton.titleLabel?.font = kTimeFont
            itemButton.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom;
            itemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10.0, 0)
            itemButton.setTitleColor(kColorGray, for: UIControlState.normal)
            itemButton.setTitleColor(self.lblDescribe.textColor, for: UIControlState.highlighted)
            itemButton.setTitle(itemStr as? String, for: UIControlState.normal)
            itemButton.addTarget(self, action: #selector(onClickWithItem(sender:)), for: UIControlEvents.touchUpInside)
            itemButton.tag = item_tag;
            view_item.addSubview(itemButton)
            itemButton.snp.updateConstraints({ (make) in
                make.top.equalTo(view_item)
                make.height.equalTo(view_item)
                make.left.equalTo(origin_x)
                make.width.equalTo(size_item_w)
            })
            origin_x += size_item_w
            item_tag += 1
            
            let itemLbl = UILabel.init()
            itemLbl.backgroundColor = UIColor.clear
            itemLbl.textColor = self.lblUserName.textColor
            itemLbl.textAlignment = NSTextAlignment.center
            itemLbl.font = kTitleFont
            itemLbl.text = "23"
            itemLbl.isUserInteractionEnabled = false
            itemButton.addSubview(itemLbl)
            itemLbl.snp.updateConstraints({ (make) in
                make.left.width.equalTo(itemButton)
                make.top.equalTo(10.0)
                make.height.equalTo(16.0)
            })
        }
        
    }
    
    func clickWithRightBarItem() {
        let controller: SetingViewController = SetingViewController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func clickWithHead() {
        let controller: WMUserInfoViewController = WMUserInfoViewController();
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func onClickWithItem(sender: UIButton) {
        print(sender)
        let index: Int = sender.tag%kItem_Tag
        if index == 0 {
            // 钱包
            let walletContrl: MyWalletViewController = MyWalletViewController();
            walletContrl.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(walletContrl, animated: true);
        } else {
            var style: WMFansAndFocusStyle = WMFansAndFocusStyle.fans
            if index == 1 {
                style = WMFansAndFocusStyle.focus
            }
            let controller: MyFansAndFocusController = MyFansAndFocusController()
            controller.style = style
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5+1
//        if section == 0 {
//            return self.arraySupervise.count
//        }
//        return self.arrayGrow.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return MemberHeadViewCell.cellHeight()
        }
        return 190.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: MemberHeadViewCell = tableView.dequeueReusableCell(withIdentifier: identifier_head) as! MemberHeadViewCell
            
            if indexPath.section == 0 {
                cell.setTitle(title: "我的历史监督")
            } else {
                cell.setTitle(title: "我的历史养成")
            }
            return cell
        }
        
        let cell: MemberTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier_member) as! MemberTableViewCell
        
        if (indexPath.row+1 == tableView.numberOfRows(inSection: indexPath.section)) {
            cell.lineView.isHidden = true
        } else {
            cell.lineView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let controller = HistoricalReviewController()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    // MARK: - network
    func queryByUserInfo() {
        let user = UserManager.shared
        HttpAPIClient.apiClientPOST("queryUserInfo", params: ["userId":user.userId], success: { (result) in
            if (result != nil) {
                print("mlogin is result: \(result)")
                let json = JSON(result!)
                let data  = json["data"][0]
                if (data["ret"].intValue == 0) {
                    let info = data["userInfo"]
                    let modle = UserManager.shared
                    modle.sign =  info["sign"].stringValue
                    modle.fansNum = info["fansNum"].stringValue

                    modle.focusNum = info["focusNum"].stringValue
                    let dic = modle.mj_keyValues()
                    let json_user = JSON(dic!)
                    UserManager.shared.storeUserData(data: json_user)
                    
                    let grow = data["myGrow"]
                    self.arrayGrow = mySuperviseModel.mj_objectArray(withKeyValuesArray: grow)
                    
                    let supervise = data["mySupervise"]
                    self.arraySupervise = mySuperviseModel.mj_objectArray(withKeyValuesArray: supervise)
                    
                    self.tableViewWM.reloadData()
                    
                } else {
                    Tool.showHUDTip(tipStr: data["desc"].stringValue)
                }
            }
        }) { (error) in
            print(error as Any)
        }
        
    }
}
