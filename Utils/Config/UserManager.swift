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

private let sharedKraken = { () -> UserManager in
    var user = UserManager()
    let store = YTKKeyValueStore.init(dbWithName: userdbName)
    if store?.getObjectById(userID, fromTable: userTableName) != nil {
        let userDic:NSDictionary = store?.getObjectById(userID, fromTable: userTableName) as! NSDictionary
        user = UserManager.mj_object(withKeyValues: userDic)
    }
    return user;
}()

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
    var wallet: String = ""
    
    class var shared: UserManager {
        return sharedKraken
    }
    
    class func storeUserWith(dict: NSDictionary) {
        let store = YTKKeyValueStore.init(dbWithName: userdbName)
        let tableName = userTableName
        store?.createTable(withName: tableName)
        let dataDic = dict;
        store?.put(dataDic, withId: userID, intoTable: tableName)
        UserManager.getUserWith(dataDic: dataDic);
    }

    class func storeUserWith(json: JSON) {
        let store = YTKKeyValueStore.init(dbWithName: userdbName)
        let tableName = userTableName
        store?.createTable(withName: tableName)
        let dataDic = json.dictionaryObject
        store?.put(dataDic, withId: userID, intoTable: tableName)
        
        let dict = NSDictionary.init(dictionary: dataDic!);
        UserManager.getUserWith(dataDic: dict);
    }
    
    class func getUserWith(dataDic: NSDictionary) {
        var user = UserManager()
        user = UserManager.mj_object(withKeyValues: dataDic)
        UserManager.shared.createDate = user.createDate
        UserManager.shared.mobile = user.mobile
        UserManager.shared.supervisor = user.supervisor
        UserManager.shared.type = user.type
        UserManager.shared.age = user.age
        UserManager.shared.sex = user.sex
        UserManager.shared.icon = user.icon
        UserManager.shared.username = user.username
        UserManager.shared.nickname = user.nickname
        UserManager.shared.userId = user.userId
        UserManager.shared.iconPrefix = user.iconPrefix
        UserManager.shared.sign = user.sign
        UserManager.shared.birthday = user.birthday
        UserManager.shared.focusNum = user.focusNum
        UserManager.shared.fansNum = user.fansNum
        UserManager.shared.pwdim = user.pwdim
    }
}
