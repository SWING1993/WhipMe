//
//  DDWalletCoin.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDWalletCoin.h"
#import "DDCoinDetailList.h"

@implementation DDWalletCoin

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)walletCoinWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"balanceNum" : @"yue",
             @"couponCount" : @"coupon"
             };
}

@end
