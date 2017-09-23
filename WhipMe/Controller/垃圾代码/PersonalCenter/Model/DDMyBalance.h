//
//  DDMyBalance.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/4/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DDMyBalance : NSObject

/** 余额标题 */
@property (nonatomic, copy) NSString *balanceTitle;

/** 余额数 */
@property (nonatomic, assign) CGFloat balanceNum;

/** 余额描述 */
@property (nonatomic, copy) NSString *balanceDesc;

/** 明细类型 0 支出 1收入 */
@property (nonatomic, assign) NSInteger balanceType;

/** 余额时间*/
@property (nonatomic, copy) NSString *balanceTime;

@end
