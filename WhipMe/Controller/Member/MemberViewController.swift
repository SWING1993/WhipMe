//
//  MemberViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {
    
    var userModel: UserInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的"
        self.view.backgroundColor = Define.kColorBackGround()
        
        
        if (userModel == nil) {
            userModel = UserInfoModel()
            userModel.username = "幽叶"
            userModel.nickname = "榴莲"
            userModel.avatar = "system_monitoring"
            userModel.sex = "男"
            userModel.age = "22"
            userModel.birthday = "1992-10-05"
            userModel.signature = "寂寞的幻境，朦胧的身影"
        }
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "set_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        
    }
    
    func clickWithRightBarItem() {
        let controller: SetingViewController = SetingViewController()
        controller.userModel = userModel
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
