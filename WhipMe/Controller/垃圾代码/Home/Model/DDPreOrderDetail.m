//
//  DDPreOrderDetail.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPreOrderDetail.h"

@implementation DDPreOrderDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"orderId" : @"orderId",
             @"orderStatus" : @"status",
             @"orderCost" : @"pay",
             @"tipCost" : @"tip",
             @"couponDiscount" : @"coupon",
             @"insuranceCost" : @"insure",
             @"originalCost" : @"cost",
             
             @"companyName" : @"corName",
             @"courierId" : @"couId",
             @"courierName" : @"couName",
             @"courierHeadIcon" : @"icon",
             @"orderId" : @"orderId",
             @"courierPhone" : @"phone",
             @"courierStar" : @"star",
             @"finishedOrderNumber" : @"count",
              @"balanceDiscount" : @"yue",
             @"companyId" : @"corId"
             };
}

@end
