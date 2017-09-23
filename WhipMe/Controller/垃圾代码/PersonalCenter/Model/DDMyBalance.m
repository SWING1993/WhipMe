//
//  DDMyBalance.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/4/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDMyBalance.h"

@implementation DDMyBalance

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"balanceTitle" : @"title",
             @"balanceNum" : @"money",
             @"balanceDesc" : @"des",
             @"balanceType" : @"type",
              @"balanceTime" : @"time"
             };
}

@end
