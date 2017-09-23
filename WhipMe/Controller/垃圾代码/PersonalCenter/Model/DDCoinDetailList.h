//
//  DDCoinDetailList.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    嘟币使用详情
 */

#import <Foundation/Foundation.h>

@interface DDCoinDetailList : NSObject

/** 嘟币增减数 */
@property (nonatomic, assign) NSInteger coinNumber;

/** 嘟币增减原因 */
@property (nonatomic, copy) NSString *coinCause;

/** 嘟币增减日期时间 */
@property (nonatomic, copy) NSString *coinDate;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)coinDetailListWithDict: (NSDictionary *)dict;

@end
