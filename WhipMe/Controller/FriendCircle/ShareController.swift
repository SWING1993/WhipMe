//
//  ShareController.swift
//  WhipMe
//
//  Created by Song on 2017/2/3.
//  Copyright © 2017年 -. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import CoreGraphics

class ShareController: UIViewController {
    
    var myFriendCircleM = FriendCircleM()
    var captureHeight: CGFloat = 150.0
    fileprivate var myTable = UITableView()
    fileprivate var imageShare = WMShareImageView()
    fileprivate var imageTemp = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    fileprivate func setup() {
        self.view.backgroundColor = kColorWhite
        prepareTableView()
    }
    
    func prepareTableView() {
        let backBtn: UIBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(ShareController.goBack))
        self.navigationItem.leftBarButtonItem = backBtn
        
        let reportBtn: UIBarButtonItem = UIBarButtonItem.init(title: "举报", style: .plain, target: self, action: #selector(ShareController.reportAction))
        self.navigationItem.rightBarButtonItem = reportBtn
        
        let bottomView = UIView()
        bottomView.backgroundColor = Define.RGBColorFloat(52, g: 53, b: 54)
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(64)
        }
        
        let label = UILabel()
        label.text = "分享到"
        label.textColor = kColorWhite
        label.font = UIFont.systemFont(ofSize: 15)
        bottomView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100, height: 30))
            make.centerY.equalTo(bottomView.snp.centerY)
            make.left.equalTo(30)
        }
        
        let btn1 = UIButton()
        btn1.tag = 1
        btn1.addTarget(self, action:  #selector(ShareController.shareWX(btn:)), for: .touchUpInside)
        btn1.setImage(UIImage.init(named: "friend_circle"), for: .normal)
        bottomView.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 40, height: 40))
            make.centerY.equalTo(bottomView.snp.centerY)
            make.right.equalTo(-22)
        }
        
        let btn2 = UIButton()
        btn2.tag = 2
        btn2.addTarget(self, action:  #selector(ShareController.shareWX(btn:)), for: .touchUpInside)
        btn2.setImage(UIImage.init(named: "weixin_icon"), for: .normal)
        bottomView.addSubview(btn2)
        btn2.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 40, height: 40))
            make.centerY.equalTo(bottomView.snp.centerY)
            make.right.equalTo(btn1.snp.left).offset(-20)
        }
        
        myTable = UITableView.init()
        myTable.backgroundColor = kColorWhite
        myTable.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.cellReuseIdentifier())
        myTable.dataSource = self
        myTable.delegate = self
        myTable.separatorStyle = .none
        view.addSubview(myTable)
        myTable.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        let qrcodeView = UIView()
        qrcodeView.backgroundColor = kColorWhite
        qrcodeView.frame = CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: 150)
        myTable.tableFooterView = qrcodeView
        
        let qrcodeImageView = UIImageView()
        qrcodeImageView.contentMode = .scaleAspectFill
        qrcodeImageView.image = UIImage.init(named: "QRcode")
        qrcodeView.addSubview(qrcodeImageView)
        qrcodeImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 81, height: 81))
            make.centerY.equalTo(qrcodeView)
            make.right.equalTo(kRightMargin)
        }
        
        let title1 =  UILabel()
        title1.textColor = kColorGary
        title1.textAlignment = .right
        title1.font = UIFont.systemFont(ofSize: 14)
        title1.text = "长按识别二维码，下载鞭挞我"
        qrcodeView.addSubview(title1)
        title1.snp.makeConstraints { (make) in
            make.bottom.equalTo(qrcodeView.snp.centerY)
            make.right.equalTo(qrcodeImageView.snp.left).offset(-20)
            make.left.equalTo(20)
            make.height.equalTo(40)
        }
        
        let title2 =  UILabel()
        title2.textColor = kColorGary
        title2.textAlignment = .right
        title2.font = UIFont.systemFont(ofSize: 16)
        title2.text = "开启你的坚持故事"
        qrcodeView.addSubview(title2)
        title2.snp.makeConstraints { (make) in
            make.top.equalTo(qrcodeView.snp.centerY)
            make.right.equalTo(qrcodeImageView.snp.left).offset(-20)
            make.left.equalTo(20)
            make.height.equalTo(40)
        }
        
        imageShare = WMShareImageView()
        self.view.addSubview(imageShare)
        imageShare.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(self.view)
            make.top.equalTo(self.myTable.snp.bottom).offset(100.0);
        }
        
        imageTemp = UIImageView()
        imageTemp.isHidden = true
        if (NSString.isBlankString(self.myFriendCircleM.picture) == false) {
            imageTemp.setImageWith(urlString: self.myFriendCircleM.picture, placeholderImage: "nilTouSu")
        }
        self.view.addSubview(imageTemp)
        imageTemp.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
    }
    
    func goBack() {
        self.dismiss(animated: true) { }
    }
    
    func reportAction() {
        let sheet: UIActionSheet = UIActionSheet.init(title: "举报", delegate: self as? UIActionSheetDelegate, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        let dataDict : NSDictionary = (UserDefaults.standard.object(forKey: "queryReportItem") as! NSDictionary)
        let json = JSON(dataDict)
        let dataArr = json["data"][0]["list"].arrayValue
        for item in dataArr {
            let reportItemDes = item["reportItemDes"].stringValue
            let reportItemId = item["reportItemId"].stringValue
            let params = ["reportItemId":reportItemId,"loginId":UserManager.shared.userId,"recordId":self.myFriendCircleM.recordId]
            sheet.bk_addButton(withTitle: reportItemDes, handler: {
                HttpAPIClient.apiClientPOST("uploadReport", params: params, success: { (result) in
                    if let dataResult = result {
                        print(dataResult)
                        Tool.showHUDTip(tipStr: "举报成功，谢谢您的支持！")
                    }
                }) { (error) in
                }
            })
        }
        sheet.show(in: self.view)
    }
    
    func shareWX(btn: UIButton) {
        
        if btn.tag == 1 {
            // 朋友圈
            WMShareEngine.sharedInstance().share(withScene: 1, with: self.capture())
        } else {
            // 微信
            WMShareEngine.sharedInstance().share(withScene: 0, with: self.capture())
        }
        
        let params = [
            "recordId":self.myFriendCircleM.recordId,
            "userId":UserManager.shared.userId,
            ]
        HttpAPIClient.apiClientPOST("addShare", params: params, success: { (result) in }) { (error) in }
    }
    
    func capture() -> UIImage {
        var captureImage = UIImage()
        if (NSString.isBlankString(self.myFriendCircleM.picture)) {
            captureImage = UIImage.convertView(toImage: self.myTable)
        } else {
            if self.imageTemp.image != nil {
                self.imageShare.image = self.imageTemp.image
                self.imageShare.name = self.myFriendCircleM.nickname
                
                let image_save: UIImage = UIImage.convertView(toImage: self.imageShare)
                let image_scale: UIImage = UIImage.scale(image_save)
                let data_min: Data = UIImage.dataRepresentationImage(image_scale)
                captureImage = UIImage.init(data: data_min)!
                
            } else {
                captureImage = UIImage.convertView(toImage: self.myTable)
            }
        }
        return captureImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/// TableViewDataSource methods.
extension ShareController:UITableViewDataSource {

    /// Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Returns the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecommendCell = RecommendCell.init(style: UITableViewCellStyle.default, reuseIdentifier: RecommendCell.cellReuseIdentifier())
        cell.backgroundColor = kColorWhite
        cell.setRecommendData(model: self.myFriendCircleM)
        return cell
    }
}

/// UITableViewDelegate methods.
extension ShareController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 100.0
        if self.myFriendCircleM.picture.isEmpty == false {
            height += Define.screenWidth()/2
            height += 15
        }
        if self.myFriendCircleM.position.isEmpty {
            height -= 9
        }
        let content: NSString = NSString.init(string: self.myFriendCircleM.content)
        height += content.getHeightWith(UIFont.systemFont(ofSize: 14), constrainedTo: CGSize.init(width: Define.screenWidth() - 48, height: CGFloat.greatestFiniteMagnitude))
        captureHeight = 150
        captureHeight += height
        return height
    }
}

