//
//  RootViewControll.swift
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var backBarItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = KColorGary
        
        self.navigationController?.navigationBar.titleTextAttributes = [kCTFontAttributeName as String:KButtonFont, kCTForegroundColorAttributeName as String:UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        backBarItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.Plain, target:self, action:Selector(clickWithBack()))
        backBarItem?.tintColor = UIColor.whiteColor()
        backBarItem?.setTitleTextAttributes([kCTFontAttributeName as String :KContentFont, kCTForegroundColorAttributeName as String:UIColor.whiteColor()], forState: UIControlState.Normal)
        self.navigationItem.backBarButtonItem = backBarItem
        
        self.navigationItem.title = NSStringFromClass(self.classForCoder)
        
    }
    
    func clickWithBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func delete(sender: AnyObject?) {
        print(NSStringFromClass(self.classForCoder))
    }
    
}
