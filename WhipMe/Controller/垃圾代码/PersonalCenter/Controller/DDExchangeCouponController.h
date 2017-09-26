//
//  DDExchangeCouponController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

/**
    兑换优惠券
 */

#import "DDRootViewController.h"


@class DDExchangeCouponController;
@protocol DDExchangeCouponDelegate <NSObject>
@required
- (void)reloadDataListByAddExchangeCoupon;

@end




@interface DDExchangeCouponController : DDRootViewController


@property (nonatomic,weak) id<DDExchangeCouponDelegate> delegate;
@end
