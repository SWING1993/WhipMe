//
//  DDGlobalVariables.h
//  DDExpressClient
//
//  Created by yangg on 16/3/22.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "DDAddressDetail.h"
#import "DDCourierDetail.h"

@class DDSelfInfomation,DDAddressModel,DDCourierDetail;

@interface DDGlobalVariables : NSObject

+ (DDGlobalVariables *)sharedInstance;

/** 我的包裹修改备注的判断，用于返回列表时刷新 */
@property (nonatomic, assign) BOOL toExpressComment;

/** 所有快递公司，全局变量，只在快递查询处查询一次 */
@property (nonatomic, strong) NSMutableArray *arrayCourierCompany;


@property (nonatomic, strong) DDAddressDetail *selfAddressDetail;

@property (nonatomic, strong) DDAddressDetail *targetAddressDetail;

@property (nonatomic, strong) DDAddressDetail *homeLocAddressDetail;

/** 地址坐标 */
//@property (nonatomic) CLLocationCoordinate2D locationCenter;

/** 用户首页发送的订单号 */
@property (nonatomic, strong) NSString *currentOrderId;
/** 判断是否是自动登录 */
@property (nonatomic, assign) BOOL autoLogin;

/** 首页地址搜索更改的实体信息传递 */
//@property (nonatomic, strong) DDAddressModel *addressModel;
@property (nonatomic,strong) DDCourierDetail *courierDetailForWaitCourierListToHomePage;
@property (nonatomic,assign) BOOL backHomeViewNeedToShowCourierDetail;

/** 保存定时器的秒数 */
@property (nonatomic,assign) NSUInteger waitForCourierRushCountTime;

@end
