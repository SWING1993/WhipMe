//
//  DDOrderList.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    订单列表
 */

#import <Foundation/Foundation.h>

@interface DDOrderList : NSObject

/** 订单编号 */
@property (nonatomic, copy) NSString *orderId;

/** 快递员公司编号 */
@property (nonatomic, copy) NSString *companyId;

/** 快递员公司名称 */
@property (nonatomic, copy) NSString *companyName;

/** 快递员公司图标 */
@property (nonatomic, copy) NSString *companyIcon;

/** 收件人名字 */
@property (nonatomic, copy) NSString *targetname;

/** 收件人地址 */
@property (nonatomic, copy) NSString *targetAddress;

/** 寄件人地址 */
@property (nonatomic, copy) NSString *selfAddress;

/** 快递日期 */
@property (nonatomic, copy) NSString *expressDate;

/** 快递完成状态 */
@property (nonatomic, assign) NSInteger expressStatus;

/** 已完成的订单是否已经评价的状态 */
@property (nonatomic, assign) NSInteger whetherEvaluated; // 0:未评价  1:已评价

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)orderListWithDict: (NSDictionary *)dict;


@end
