//
//  DDRecommendPrize.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDRecommendPrize.h"

@implementation DDRecommendPrize

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)recommendPrizeWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
