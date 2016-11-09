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

    /*
     "themeName":self.myCostomAM.title,
     "creator":UserManager.getUser().userId,
     "nickname":UserManager.getUser().nickname,
     "icon":UserManager.getUser().icon,
     "plan":self.myCostomAM.content,
     "startDate":startDate,
     "endDate":endDate,
     "clockTime":clockTime,
     "type":"3",
     "privacy":"1",
     "supervisor":"",
     "supervisorName":"",
     "supervisorIcon":"",
     "guarantee":""

 */
    
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
        print(value.themeName)
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
