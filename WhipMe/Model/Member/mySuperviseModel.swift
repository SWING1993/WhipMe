//
//  mySuperviseModel.swift
//  WhipMe
//
//  Created by anve on 16/11/16.
//  Copyright © 2016年 -. All rights reserved.
//

import Foundation

class threeDayModel: NSObject {
    open var picture: String = ""
    open var content: String = ""
    open var whichDay: String = ""
    
}

class mySuperviseModel: NSObject {
    open var creator: String = ""
    open var userId: String = ""
    open var nickname: String = ""
    open var icon: String = ""
    open var taskId: String = ""
    open var themeId: String = ""
    
    open var themeName: String = ""
    open var recordNum: String = ""
    open var threeDay: NSArray = NSArray.init()
    open var startDate: String = ""
    open var endDate: String = ""
    
}
