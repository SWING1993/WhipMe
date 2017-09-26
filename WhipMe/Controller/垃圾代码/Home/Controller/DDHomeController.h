//
//  DDHomeController.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/23.
//  Copyright © 2016年 诺晟. All rights reserved.
//

/**
    程序主页
 */

#import "DDRootViewController.h"

@class DDCourierDetail, DDAddressDetail;


typedef enum {
    
    DDHomePageWaitInit = -2,
    DDHomePageWaitNone = -1,
    DDHomePageWaitForRush = 0,
    DDHomePageWaitForGetExpress = 1,
    DDHomePageWaitForPay = 2
    
} DDHomePageStatusEnum;

@interface DDHomeController : DDRootViewController

@property (assign, nonatomic) DDHomePageStatusEnum homePageStatus;
/** 快递员信息 */
@property (strong, nonatomic) DDCourierDetail *waitedCourierDetail;

@property (nonatomic, strong) DDAddressDetail *selectedAddressDetail;

@property (nonatomic, assign) BOOL showLoginStart;//是否在显示的时候进入登录界面

/** 未付款订单个数 */
//@property (nonatomic,assign) NSInteger unPayCount;

@end
