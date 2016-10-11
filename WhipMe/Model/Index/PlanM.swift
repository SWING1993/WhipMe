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

class PlanM: NSObject {

    var title = String()
    var content = String()
    var startTime = Date()
    var endTime = Date ()
    var alarmClock = Date()
    var alarmWeeks:[Int] = NSArray() as! [Int]
    var privacy:PrivacyType?
    
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
        print(value.title)
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
        plans.removeObject(at: index)
        plans.storeValue(withKey: kPlan)
    }
    
    class func getPlans() -> NSArray? {
        let plans :NSArray? = NSObject.value(byKey: kPlan) as? NSArray
        return plans
    }
}
