//
//  DDOrderDetailController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
typedef enum {
    /** 匿名评论订单 */
    DDOrderDetailControlStyleAnonymous = 0,
    /** 评论完成 */
    DDOrderDetailControlStyleEvaluationOfComplete = 1
} DDOrderDetailControlStyle;

/**
    订单详情页面
 */
#import "DDRootViewController.h"

@class DDOrderDetail;
@interface DDOrderDetailController : DDRootViewController

/** 枚举，显示界面为匿名评价订单还是实名评价订单 */
- (instancetype)initWithOrderStyle:(DDOrderDetailControlStyle)controlStyle;

@property (nonatomic,strong) DDOrderDetail *orderDetail;

@end
