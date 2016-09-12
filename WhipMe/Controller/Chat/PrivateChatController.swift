//
//  PrivateChatViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class PrivateChatController: RootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {
        
        let viewNavTar: UIView = UIView.init(frame: CGRectMake(0, 0, 132.0, 30.0))
        viewNavTar.backgroundColor = UIColor.whiteColor()
        viewNavTar.layer.cornerRadius = 4.0
        viewNavTar.layer.masksToBounds = true
        viewNavTar.layer.borderColor = UIColor.whiteColor().CGColor
        viewNavTar.layer.borderWidth = 1.0
        self.navigationItem.titleView = viewNavTar;
        
        let titles_nav: NSArray = ["私信","通知"]
        
        
        
        for i in 0 ..< titles_nav.count {
            let itemButton: UIButton = UIButton.init(type: UIButtonType.Custom)
            itemButton.frame = CGRectMake(CGFloat(i)*66.0, 0, 66.0, 30.0)
            
        }
        
    }

}
