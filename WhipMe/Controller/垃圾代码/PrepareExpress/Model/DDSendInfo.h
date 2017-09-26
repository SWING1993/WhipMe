//
//  DDSendInfo.h
//  DDExpressClient
//
//  Created by SongGang on 2/23/16.
//  Copyright © 2016 NS. All rights reserved.
//

/**
    寄件信息模型
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DDAddressDetail.h"
#import "YYModel.h"

@interface DDSendInfo : NSObject

/** 寄件人信息 */
@property(nonatomic,copy) NSString   * selfAddressId;
/** 收件人信息 */
@property(nonatomic,copy) NSString   * targetAddressId;
/** 快递公司 */
@property(nonatomic,copy) NSArray * companyIds;
/** 取件时间 */
@property(nonatomic,copy) NSString * takeTime;
/** 物品重量 */
@property(nonatomic,copy) NSString * itemWeight;
/** 预估费用 */
@property(nonatomic,copy) NSString * budgetCost;
/** 物品照片 */
@property(nonatomic,copy) NSString * itemImage;
/** 保费 */
@property(nonatomic,assign) CGFloat  itemInsure;
/** 小费 */
@property(nonatomic,assign) CGFloat  itemTip;
/** 物品类型 */
@property(nonatomic,copy) NSString *  itemType;
/** 捎句话 */
@property(nonatomic,copy) NSString * itemTag;
/** 是否到付 */
@property(nonatomic,assign) NSInteger  targetPay;
@end
