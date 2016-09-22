//
//  MemberViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的"
        self.view.backgroundColor = KColorBackGround
        
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "add_superintendent"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        
    }
    
    func clickWithRightBarItem() {
        let controller: UserInfoViewController = UserInfoViewController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
