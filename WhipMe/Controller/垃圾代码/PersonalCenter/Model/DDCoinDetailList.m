//
//  DDCoinDetailList.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCoinDetailList.h"

@implementation DDCoinDetailList

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)coinDetailListWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
