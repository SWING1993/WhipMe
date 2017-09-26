//
//  DDOrderDetail.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDOrderDetail.h"

@implementation DDOrderDetail

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)orderDetailWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"companyName" : @"corName",
             @"companyId" : @"corId",
             @"courierId" : @"couId",
             @"courierIcon" : @"couIcon",
             @"courierName" : @"couName",
             @"courierCard" : @"couCard",
             @"courierStar" : @"couStart",
             @"finishedCount" : @"couOrderNum",
             @"courierRank" : @"couRank",
             @"courierPhone" : @"couPhone",
             @"orderCost" : @"pay",
             @"orderStatus" : @"status",
             @"evaluateGrade" : @"evaStar",
             @"evaluateArray" : @"content"
             };
}

@end
