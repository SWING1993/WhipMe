//
//  DDOrderList.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDOrderList.h"

@implementation DDOrderList

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)orderListWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"orderId" : @"orderId",
             @"companyName" : @"corName",
             @"companyId" : @"corId",
             @"targetname" : @"recName",
             @"targetAddress" : @"recAddr",
             @"selfAddress" : @"sendAddr",
             @"expressDate" : @"date",
             @"expressStatus" : @"status",
             @"whetherEvaluated":@"eva"
             };
}

@end
