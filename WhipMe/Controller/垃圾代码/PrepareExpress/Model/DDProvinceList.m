//
//  DDProvinceList.m
//  DDExpressCourier
//
//  Created by yoga on 16/3/18.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDProvinceList.h"

@implementation DDProvinceList



- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)provinceListWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"provinceId" : @"id",
             @"provinceName" : @"name",
             @"provinceSub" : @"sub",
             };
}

@end
