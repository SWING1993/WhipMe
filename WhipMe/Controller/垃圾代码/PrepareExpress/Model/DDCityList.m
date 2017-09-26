//
//  DDCityList.m
//  DDExpressCourier
//
//  Created by yoga on 16/3/18.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCityList.h"

@implementation DDCityList

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}




+ (instancetype)cityListWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}




+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"cityId" : @"id",
             @"cityName" : @"name",
             @"citySub" : @"sub",
             };
}
@end
