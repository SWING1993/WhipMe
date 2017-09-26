//
//  DDPreOrderDetail.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDPreOrderDetail : NSObject

/** 订单编号 */
@property (nonatomic,copy)  NSString * orderId;
/** 快递员编号 */
@property (nonatomic,copy)  NSString * courierId;
/** 快递员照片 */
@property (nonatomic,copy)  NSString * courierHeadIcon;
/** 快递员名字 */
@property (nonatomic,copy)  NSString * courierName;
/** 快递员电话 */
@property (nonatomic,copy)  NSString * courierPhone;
/** 快递员公司名称 */
@property (nonatomic,copy)  NSString * companyName;
/** 快递员评星图 */
@property (nonatomic,copy)  NSString * courierStar;
/** 快递员完成订单数 */
@property (nonatomic,assign)  NSInteger finishedOrderNumber;

/** 此单总费用 */
@property (nonatomic, assign) CGFloat orderCost;
/** 此单原始费用 */
@property (nonatomic, assign) CGFloat originalCost;
/** 此单小费 */
@property (nonatomic, assign) CGFloat tipCost;
/** 此单保费 */
@property (nonatomic, assign) CGFloat insuranceCost;
/** 此单优惠 */
@property (nonatomic, assign) CGFloat couponDiscount;
/** 余额优惠 */
@property (nonatomic, assign) CGFloat balanceDiscount;

/** 订单状态(0待抢单 1待取件 2待付款) */
@property (nonatomic, assign) CGFloat orderStatus;

@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;

@property (nonatomic, strong) NSString *companyId;

@end
