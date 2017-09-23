//
//  DDCoupons.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCoupons.h"

@implementation DDCoupons

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)couponsWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"couponName" : @"name",
             @"couponValid" : @"valid",
             @"couponValue" : @"value",
             @"couponId" : @"coupId",
             @"couponPurpose" : @"purpose",
             @"couponUsed" : @"used",
             @"couponExpire" : @"expire"
             };
}

@end
