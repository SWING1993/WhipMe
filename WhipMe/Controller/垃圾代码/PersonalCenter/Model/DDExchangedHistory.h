//
//  DDExchangedHistory.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    兑换历史
 */

#import <Foundation/Foundation.h>

@interface DDExchangedHistory : NSObject

/** 优惠券名称 */
@property (nonatomic, copy) NSString *couponName;

/** 嘟币价值 */
@property (nonatomic, assign) NSUInteger *coinValue;

/** 优惠券类型 */
@property (nonatomic, copy) NSString *couponClass;

/** 优惠券 logo */
@property (nonatomic, copy) NSString *couponLogo;

/** 优惠券 id */
@property (nonatomic, copy) NSString *couponId;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)exchangedHisWithDict: (NSDictionary *)dict;

@end
