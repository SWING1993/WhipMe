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
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = KColorNavigation
        
        self.navigationController?.navigationBar.titleTextAttributes = [kCTFontAttributeName as String:KButtonFont, kCTForegroundColorAttributeName as String:UIColor.white]
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        
//        backBarItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.plain, target:self, action:Selector(clickWithBack()))
        backBarItem?.tintColor = UIColor.white
        backBarItem?.setTitleTextAttributes([kCTFontAttributeName as String :KContentFont, kCTForegroundColorAttributeName as String:UIColor.white], for: UIControlState())
        self.navigationItem.backBarButtonItem = backBarItem
        
        self.navigationItem.title = NSStringFromClass(self.classForCoder)
        
    }
    
//    func clickWithBack() {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
//    override func delete(_ sender: AnyObject?) {
//        print(NSStringFromClass(self.classForCoder))
//    }
    
}
