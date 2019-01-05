//
//  MoneyRecordModel.h
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyRecordModel : NSObject

/** 充值还是体现（0：充值  1：体现） */
@property (nonatomic, assign) NSInteger type;
/** 金额 */
@property (nonatomic, copy) NSString *amount;
/** 充值提现时间 */
@property (nonatomic, copy) NSString *createDate;


@end
