//
//  DDWalletCoin.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    我的嘟币
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDWalletCoin : NSObject

/** 嘟币总数 */
//@property (nonatomic, assign) NSInteger coinCount;

/** 余额数 */
@property (nonatomic, assign) CGFloat balanceNum;

/** 优惠券数量 */
@property (nonatomic, assign) NSInteger couponCount;

/** 嘟币使用详情 */
//@property (nonatomic, strong) NSArray *coinDetailList;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)walletCoinWithDict: (NSDictionary *)dict;

@end
