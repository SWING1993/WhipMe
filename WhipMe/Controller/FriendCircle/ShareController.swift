//
//  ShareController.swift
//  WhipMe
//
//  Created by Song on 2017/2/3.
//  Copyright © 2017年 -. All rights reserved.
//

import UIKit
import CoreGraphics

class ShareController: UIViewController {
    
    var myFriendCircleM = FriendCircleM()
    var captureHeight: CGFloat = 0.0
    fileprivate var myTable = UITableView()

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
    }
    
    func goBack() {
        self.dismiss(animated: true) { }
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

        //截取全屏
        UIGraphicsBeginImageContext(CGSize.init(width: Define.screenWidth(), height: Define.screenHeight()))
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //截取所需区域
        let captureRect: CGRect = CGRect.init(x: 0, y: 0, width: Define.screenWidth(), height: captureHeight)
        if let sourceImageRef: CGImage = image.cgImage {
            if let newImageRef: CGImage = sourceImageRef.cropping(to: captureRect) {
                captureImage = UIImage.init(cgImage: newImageRef)
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
        captureHeight = height
        return captureHeight
    }
}

