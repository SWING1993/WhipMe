//
//  DDPayCostController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
/**
    支付费用页面
 */
#import "DDRootViewController.h"

@class DDOrderDetail,DDCostDetail, DDPayCostController;
@protocol DDPayCostDelegat <NSObject>

@optional
- (void)payCost:(DDPayCostController *)payCost didClickCallBackConfirmBtnWithIndexPath:(NSIndexPath *)indexPath;
- (void)payCostView:(DDPayCostController *)payCostView didClickBackConfirmBtnWithOrderId:(NSString *)orderId;
@end

@interface DDPayCostController : DDRootViewController

@property (nonatomic, strong) DDOrderDetail * orderDetail;
@property (nonatomic, strong) DDCostDetail * costDetail;
@property (nonatomic, copy) NSString *orderId;
/** 待订单列表中的行数 */
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<DDPayCostDelegat> delegate;

@end
