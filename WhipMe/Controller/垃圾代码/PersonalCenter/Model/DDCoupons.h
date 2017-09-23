//
//  DDCoupons.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    优惠券
 */

#import <Foundation/Foundation.h>

@interface DDCoupons : NSObject

/** 优惠券名称 */
@property (nonatomic, copy) NSString *couponName;

/** 优惠券 id */
@property (nonatomic, copy) NSString *couponId;

/** 优惠券有效期至 */
@property (nonatomic, copy) NSString *couponValid;

/** 优惠券价值 */
@property (nonatomic, assign) NSUInteger couponValue;

/** 优惠券用途 */
@property (nonatomic, copy) NSString *couponPurpose;

/**  优惠券是否已使用     0未使用 */
@property (nonatomic, assign) NSInteger *couponUsed;

/**  优惠券是否已过期   0 未过期 */
@property (nonatomic, assign) NSInteger couponExpire;


- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)couponsWithDict: (NSDictionary *)dict;

@end
