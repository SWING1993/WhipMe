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

class QueryUserBlogC: UIViewController {

    var userBlogM = UserBlogM.init()
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.

        super.viewDidLoad()
        self.view.backgroundColor = kColorBackGround

        print(self.userBlogM.myGrow.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
