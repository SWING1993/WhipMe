//
//  DDCostDetail.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/2.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCostDetail.h"

@implementation DDCostDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"orderPayType" : @"ePay",
             @"orderCost" : @"pay",
             @"originalCost" : @"cost",
             @"tipCost" : @"tip",
             @"couponDiscount" : @"coupon",
             @"insuranceCost" : @"insure",
             @"payType" : @"pType",
             @"balance" : @"yue"
             };
}
@end
