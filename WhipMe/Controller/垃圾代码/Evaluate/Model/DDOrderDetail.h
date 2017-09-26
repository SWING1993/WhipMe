//
//  DDOrderDetail.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    订单详情
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDOrderDetail : NSObject

/** 订单编号 */
@property (nonatomic, copy) NSString *orderId;

/** 快递公司名字 */
@property (nonatomic, copy) NSString *companyName;

/** 快递公司名字 */
@property (nonatomic, copy) NSString *companyId;

/** 快递员id */
@property (nonatomic, copy) NSString *courierId;

/** 快递员头像 */
@property (nonatomic, copy) NSString *courierIcon;

/** 快递员名字 */
@property (nonatomic, copy) NSString *courierName;

/** 快递员身份证号 */
@property (nonatomic, copy) NSString *courierCard;

/** 快递员星级 */
@property (nonatomic, copy) NSString *courierStar;

/** 完成单数 */
@property (nonatomic, assign) NSInteger finishedCount;

/** 快递员排名 */
@property (nonatomic, copy) NSString *courierRank;

/** 快递员电话 */
@property (nonatomic, copy) NSString *courierPhone;

/** 支付费用 */
@property (nonatomic,assign) CGFloat orderCost;

/** 订单状态 */
@property (nonatomic,assign) NSInteger orderStatus;

/** 此单评分 */
@property (nonatomic, assign) CGFloat evaluateGrade;

/** 此单评价内容 */
@property (nonatomic, strong) NSArray *evaluateArray;


- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)orderDetailWithDict: (NSDictionary *)dict;

@end
