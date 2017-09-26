//
//  DDSelfIdentity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/2.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDSelfIdentity.h"

@implementation DDSelfIdentity

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)selfIdentityWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
