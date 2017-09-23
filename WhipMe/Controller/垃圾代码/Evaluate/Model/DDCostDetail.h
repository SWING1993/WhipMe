//
//  DDCostDetail.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/2.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDCostDetail : NSObject

/* 此单付款类型(现付或到付) **/
@property (nonatomic, assign) NSInteger orderPayType;
/* 最终支付费用 **/
@property (nonatomic, assign) CGFloat orderCost;
/* 原始快递费用 **/
@property (nonatomic, assign) CGFloat originalCost;
/* 此单小费 **/
@property (nonatomic, assign) CGFloat tipCost;
/* 此单保费 **/
@property (nonatomic, assign) CGFloat insuranceCost;
/* 此单优惠 **/
@property (nonatomic, assign) CGFloat couponDiscount;
/* 余额 **/
@property (nonatomic, assign) CGFloat balance;
/* 支付方式 **/
@property (nonatomic, assign) NSInteger payType;        //1 支付宝    2  微信    3 银联   4 apple{ay

@end
