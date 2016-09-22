//
//  CustomAddM.swift
//  WhipMe
//
//  Created by Song on 16/9/20.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

enum PrivacyType {
    case all
    case mySelf
    case myFollow
}
let kPlan = "PlanKey"

class CustomAddM: NSObject {

    var title:String?
    var content:String?
    var startTime:NSDate?
    var endTime:NSDate?
    var alarmClock:NSDate?
    var privacy:PrivacyType?
    
    class func savePlan(value:CustomAddM) {
        var plans : NSMutableArray?
        if NSObject.value(byKey: kPlan) != nil {
            plans = NSObject.value(byKey: kPlan) as? NSMutableArray
        }
        else {
            plans = NSMutableArray.init()
        }
        plans?.add(value)
        plans?.storeValue(withKey: kPlan)
        print(value.startTime)
    }
    
    class func getPlans() -> NSArray {
        let plans : NSArray = NSObject.value(byKey: kPlan) as! NSArray
        return plans
    }
}
