//
//  DDCourierDetail.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/2.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierDetail.h"

@implementation DDCourierDetail

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+ (instancetype)courierDetailWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"courierID" : @"couId",
             @"companyId" : @"corId",
             @"companyName" : @"corName",
             @"courierName" : @"couName",
             @"courierHeadIcon" : @"icon",
             @"courierIdentityID" : @"card",           // 新增的
             @"orderId" : @"orderId",
             @"finishedOrderNumber" : @"count",
             @"courierRank": @"rank",                 //  新增的
             @"courierPhone" : @"phone",
             @"courierStar" : @"star",
             @"msgId" : @"mid",
             @"latitude": @"lat",
             @"longitude": @"lon"
             };
}

- (BOOL)isEqual:(DDCourierDetail *)object {
    return [self.orderId isEqualToString: object.orderId];
}

@end
