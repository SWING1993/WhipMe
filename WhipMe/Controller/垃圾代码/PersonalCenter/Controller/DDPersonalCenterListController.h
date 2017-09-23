//
//  DDPersonalCenterListController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

/** 个人中心菜单 */


#import "DDRootViewController.h"
#import "Constant.h"

//#define DDRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//#define MAIN_COLOR DDRGBCOLOR(255, 218, 68)

typedef NS_ENUM(NSInteger, DDPersonalCenterListMenus) {
    /** 我的订单 */
    DDPersonalCenterListOrderList     = 0,
    /** 我的钱包 */
    DDPersonalCenterListWalle = 1,
    /** 通知中心 */
    DDPersonalCenterListNotification = 2,
    /** 嘟嘟商城 */
    //DDPersonalCenterListMarket = 3,
    /** 推荐奖励 */
    DDPersonalCenterListRecommenPrize = 3,
    /** 设置 */
    DDPersonalCenterListSetting = 4,
    /** 客服电话 */
    DDPersonalCenterListServiceAlert = 5,
    
};

@interface DDPersonalCenterListController : DDRootViewController

@end
