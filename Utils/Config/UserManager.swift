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
    var createDate: String = ""
    var mobile: String = ""
    var supervisor: String = ""
    var type: String = ""
    var age: String = ""
    var sex: Bool = false //0.女  1.男
    var icon: String = ""
    var username: String = ""
    var nickname: String = ""
    var userId: String = ""
    var iconPrefix: String = ""
    var sign: String = ""
    var birthday: String = ""
    
    var focusNum: String = ""
    var fansNum: String = ""
    var pwdim: String = ""

    class func storeUserData(data: JSON) {
        let store = YTKKeyValueStore.init(dbWithName: userdbName)
        let tableName = userTableName
        print(data)
        store?.createTable(withName: tableName)
        let dataDic = data.dictionaryObject
        store?.put(dataDic, withId: userID, intoTable: tableName);
    }
    
    class func getUser() -> UserManager {
        var user = UserManager()
        let store = YTKKeyValueStore.init(dbWithName: userdbName)
        if store?.getObjectById(userID, fromTable: userTableName) != nil {
            let userDic:NSDictionary = store?.getObjectById(userID, fromTable: userTableName) as! NSDictionary
            user = UserManager.mj_object(withKeyValues: userDic)
        }
        return user;
    }
}
