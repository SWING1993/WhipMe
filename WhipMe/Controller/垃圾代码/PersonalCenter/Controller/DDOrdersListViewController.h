//
//  DDOrdersListViewController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

/**
    我的订单页面
 */
#import "DDRootViewController.h"

/** 订单列表类型枚举*/
typedef NS_ENUM(NSInteger,KDDOrderListStatus) {
    KDDOrderListWait = 1,           /**  待取件  */
    KDDOrderListNotPay = 2,         /**  待付款  */
    KDDOrderListAchieve = 3,        /**  已完成  */
    KDDOrderListAll = 0             /**  全部  */
} ;

@interface DDOrdersListViewController : DDRootViewController

@end
