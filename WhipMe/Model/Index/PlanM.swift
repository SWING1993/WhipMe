//
//  CustomAddM.swift
//  WhipMe
//
//  Created by Song on 16/9/20.
//  Copyright © 2016年 -. All rights reserved.
//

import UIKit

enum PrivacyType {
    case all   //1
    case myFollow   //2
    case mySelf   //3
}

/*
let kPlan = "PlanKey"
class PlanM: NSObject {

    var themeName: String = ""
    var plan: String = ""
    var startTime: Date = Date()
    var endTime: Date = Date ()
    var alarmClock: Date = Date()
    var alarmWeeks: [Int] = []
    var privacy: PrivacyType = .all
    
    class func savePlan(value: PlanM) {
        var plans : NSMutableArray!
        if NSObject.value(byKey: kPlan) != nil {
            plans = NSObject.value(byKey: kPlan) as! NSMutableArray
        }
        else {
            plans = NSMutableArray.init()
        }
        plans.add(value)
        plans.storeValue(withKey: kPlan)
    }
    
    class func deletePlan(index: Int) {
        var plans : NSMutableArray!
        if NSObject.value(byKey: kPlan) != nil {
            plans = NSObject.value(byKey: kPlan) as! NSMutableArray
        }
        else {
            plans = NSMutableArray.init()
        }
        if index > plans.count - 1 {
            return
        }
        AppDelegate.removeNotification(plan: plans.object(at: index) as! PlanM)
        plans.removeObject(at: index)
        plans.storeValue(withKey: kPlan)
    }
    
    class func getPlans() -> NSArray? {
        let plans :NSArray? = NSObject.value(byKey: kPlan) as? NSArray
        return plans
    }
}
*/
