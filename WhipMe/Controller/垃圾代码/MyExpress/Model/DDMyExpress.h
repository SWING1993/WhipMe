//
//  DDMyExpress.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDMyExpress : NSObject

/**< 包裹ID */
//@property (nonatomic, strong) NSString *expressID;
/** 寄出还是收取 */
@property (nonatomic, assign) NSInteger expressType;
/** 快递状态(已揽收/已发货/已签收) */
@property (nonatomic, assign) NSInteger expressStatus;
/** 快递公司ID */
@property (nonatomic, strong) NSString *companyId;
/** 快递公司名称 */
@property (nonatomic, strong) NSString *companyName;
/** 快递公司LOGO */
@property (nonatomic, strong) NSString *companyLogo;
/** 快递单号 */
@property (nonatomic, strong) NSString *expressNumber;
/**< 寄件人名字 */
@property (nonatomic, strong) NSString *sendName;
/**< 收件人名字 */
@property (nonatomic, strong) NSString *revName;
/** 快递日期 */
@property (nonatomic, strong) NSString *expressDate;
/**< 客户热线 */
@property (nonatomic, strong) NSString *companyPhone;
@property (nonatomic, strong) NSString *htelPhone;
/**< 快递员经度 */
@property (nonatomic, assign) float courierLon;
/**< 快递员纬度 */
@property (nonatomic, assign) float courierLat;
/** 快递备注 */
@property (nonatomic, strong) NSString *expressComment;
/** 最后一条物流信息 */
@property (nonatomic, strong) NSString *laLog;
/**< 物流信息数组 里面存的是字典 "content" 物流信息 "time" 时间 */
@property (nonatomic, strong) NSMutableArray *processList;
/** 是否已经派送 0没有 1已经派送 */
@property (nonatomic, assign) NSInteger sended;


/** 我的包裹详情信息解析 */
@property (nonatomic, strong) NSDictionary *detailExpressResult;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)myExpressWithDict: (NSDictionary *)dict;

/** 返回(1已揽收/2已发货/3已签收) */
+ (NSString *)expressForStatu:(NSInteger)index;

@end
