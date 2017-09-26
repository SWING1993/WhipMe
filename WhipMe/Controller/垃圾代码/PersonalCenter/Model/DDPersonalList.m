//
//  DDPersonalList.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/24.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPersonalList.h"

@implementation DDPersonalList

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)personalListWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
