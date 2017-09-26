//
//  DDCourierDetail.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/2.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCourierDetail : NSObject

/** 快递员编号 */
@property (nonatomic,copy)  NSString * courierID;
/** 快递员照片 */
@property (nonatomic,copy)  NSString * courierHeadIcon;
/** 快递员名字 */
@property (nonatomic,copy)  NSString * courierName;
/** 快递员电话 */
@property (nonatomic,copy)  NSString * courierPhone;
/** 快递员公司名称 */
@property (nonatomic,copy)  NSString * companyName;
/** 快递员公司ID */
@property (nonatomic,copy)  NSString * companyId;

/** 快递员身份证号 */
@property (nonatomic,copy)  NSString * courierIdentityID;
/** 快递员评分 */
@property (nonatomic,copy)  NSString * courierGrade;
/** 快递员完成订单数 */
@property (nonatomic,copy)  NSString * finishedOrderNumber;
/** 快递员排名 */
@property (nonatomic,copy)  NSString * courierRank;
/** 快递员评星图 */
@property (nonatomic,copy)  NSString * courierStar;

/** 订单号 */
@property (nonatomic,copy)  NSString * orderId;

/** 消息ID */
@property (nonatomic,copy)  NSString * msgId;

/** 经度 */
@property (nonatomic,copy)  NSString * longitude;
/** 纬度 */
@property (nonatomic,copy)  NSString * latitude;


- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)courierDetailWithDict: (NSDictionary *)dict;

@end
