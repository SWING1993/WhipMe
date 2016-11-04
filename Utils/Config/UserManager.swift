//
//  UserManager.swift
//  WhipMe
//
//  Created by Song on 2016/11/4.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit
import YTKKeyValueStore
import SwiftyJSON


//private let sharedKraken = UserTable()
//class UserTable: NSObject {
//    class var sharedInstance: UserTable {
//        return sharedKraken
//    }
//}

let userdbName = "whipMe.db"
let userTableName = "user_table"
let userID = "user_data"

class UserManager: NSObject {
    var sex = Bool()
    var icon = String()
    var nickname = String()
    var userId = String()
    var iconPrefix = String()
    
    class func storeUserData(data: JSON) {
        let store = YTKKeyValueStore.init(dbWithName: userdbName)
        let tableName = userTableName
        print(data)
        store?.createTable(withName: tableName)
        let dataDic = data.dictionaryObject
        store?.put(dataDic, withId: userID, intoTable: tableName);
        print(NSHomeDirectory());
    }
    
    class func getUser() -> UserManager {
        let user = UserManager()
        let store = YTKKeyValueStore.init(dbWithName: userdbName)
        if store?.getObjectById(userID, fromTable: userTableName) != nil {
            
            let userDic:NSDictionary = store?.getObjectById(userID, fromTable: userTableName) as! NSDictionary
            user.nickname = userDic.object(forKey: "nickname") as! String
            user.icon = userDic.object(forKey: "icon") as! String
            user.userId = userDic.object(forKey: "userId") as! String
            user.iconPrefix = userDic.object(forKey: "iconPrefix") as! String
            user.sex = userDic.object(forKey: "sex") as! Bool
        }
        return user;
    }
}
