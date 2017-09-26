//
//  DDActivity.m
//  DDExpressCourier
//
//  Created by Steven.Liu on 16/4/14.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDActivity.h"

@implementation DDActivity

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"activityId" : @"acId",
             @"activityImage" : @"img",
             @"activityUrl" : @"url",
             @"activityDescribe" : @"des",
             @"activityTime" : @"time",
             };
}

@end
