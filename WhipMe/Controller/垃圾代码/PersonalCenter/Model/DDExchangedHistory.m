//
//  DDExchangedHistory.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDExchangedHistory.h"

@implementation DDExchangedHistory

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)exchangedHisWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
