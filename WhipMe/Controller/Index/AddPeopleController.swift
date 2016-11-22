//
//  AddPeopleController.swift
//  WhipMe
//
//  Created by Song on 2016/11/17.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SwiftyJSON


class FansM: NSObject {
    var num: Int = 0
    var userId: String = ""
    var icon: String = ""
    var nickname: String = ""
}

class AddPeopleController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        /*
 
         {
         "data": [{
         "ret”:”0",
         "desc":"成功",
         "btNum":"小鞭君正在监督的人数",
         "list": [
         {
         "userId":"用户的userId",
         "icon":"用户的头像",
         "num":"正在监督的人数",
         "nickname":"用户的昵称"
         }
         ]
         }]
         }
 */
        
        self.view.backgroundColor = kColorWhite
        self.title = "选择监督人"
    
        let params = ["userId":UserManager.getUser().userId]
        
        HttpAPIClient.apiClientPOST("querySupervisor", params: params, success: { (result) in
            print(result!)
            if (result != nil) {
                let json = JSON(result!)
                let ret  = json["data"][0]["ret"].intValue
                if ret == 0 {
//                    Tool.showHUDTip(tipStr: "添加成功")
                } else {
                    Tool.showHUDTip(tipStr: json["data"][0]["desc"].stringValue)
                }
            }
        }) { (error) in
            print(error as Any);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
