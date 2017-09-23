//
//  DDAreaList.m
//  DDExpressCourier
//
//  Created by yoga on 16/3/22.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDAreaList.h"

@implementation DDAreaList
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"areaId" : @"id",
             @"areaName" : @"name",
             };
}
@end
