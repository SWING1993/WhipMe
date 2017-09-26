//
//  DDRecommendPrize.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    推荐有奖奖励明细
 */

#import <Foundation/Foundation.h>

@interface DDRecommendPrize : NSObject

/** 奖励时间 */
@property (nonatomic, copy) NSString *prizeDate;

/** 奖励原因 */
@property (nonatomic, copy) NSString *prizeCause;

/** 奖励额度 */
@property (nonatomic, assign) NSInteger couponValue;

/** 页码 */
@property (nonatomic, assign) NSInteger pageNumber;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)recommendPrizeWithDict: (NSDictionary *)dict;

@end
