//
//  PrivateChatViewController.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class PrivateChatController: RootViewController {
    
    var arrayNavButton: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        let titles_nav: NSArray = ["私信","通知"]
        let segmentedView: UISegmentedControl = UISegmentedControl.init(items: titles_nav as [AnyObject])
        segmentedView.frame = CGRect(x: 0, y: 0, width: 132.0, height: 30.0)
        segmentedView.backgroundColor = KColorNavigation
        segmentedView.layer.cornerRadius = segmentedView.height/2.0
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.borderColor = UIColor.white.cgColor
        segmentedView.layer.borderWidth = 1.0
        segmentedView.tintColor = UIColor.white
        segmentedView.selectedSegmentIndex = 0
        segmentedView.addTarget(self, action:#selector(clickWithNavItem), for: UIControlEvents.valueChanged)
        self.navigationItem.titleView = segmentedView
        
        let rightBarItem: UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "people_care"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickWithRightBarItem))
        rightBarItem.tintColor = UIColor.white
        rightBarItem.setTitleTextAttributes([kCTFontAttributeName as String :KContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        
    }
    
    func clickWithNavItem(_ sender: UISegmentedControl) {
       
        print(sender.numberOfSegments+sender.selectedSegmentIndex)

    }

    func clickWithRightBarItem() {
        print(NSStringFromClass(self.classForCoder))
    }
}