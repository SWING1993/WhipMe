//
//  DDCouponCell.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    优惠券 cell
 */

#import <UIKit/UIKit.h>

@class DDCoupons;
@interface DDCouponCell : UITableViewCell

/** 优惠券列表cell的类方法 */
+ (instancetype)couponCellWithTableView: (UITableView *)tableView;

/** 优惠券数据模型 */
@property (nonatomic, strong) DDCoupons *coupon;

@end
