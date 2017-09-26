//
//  DDHomeController.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/23.
//  Copyright © 2016年 诺晟. All rights reserved.
//

#import "DDHomeController.h"
#import "Constant.h"

#import "DDPrepareSendViewController.h"
#import "DDMyExpressListController.h"
#import "DDPersonalCenterListController.h"
#import "DDInputAddressController.h"
#import "DDCourierCompanyViewController.h"
#import "DDCourierDetailController.h"
#import "DDRegistController.h"
#import "DDOrdersListViewController.h"
#import "DDPayCostController.h"

#import "DDWaitCourierRushOrderView.h"
#import "DDCancelOrderView.h"
#import "DDWaitForCourierView.h"
#import "DDRemindToPayView.h"
#import "DDLoadingView.h"

#import "DDCompanyModel.h"
#import "DDCourierCoordinate.h"
#import "DDCenterCoordinate.h"
#import "YYModel.h"
#import "DDPreOrderDetail.h"
#import "DDCourierDetail.h"
#import "DDOrderDetail.h"
#import "DDAddressDetail.h"

#import "CustomStringUtils.h"
#import "DDGlobalVariables.h"
#import "MBProgressHUD.h"
#import "QYMapPointAnnotation.h"
#import "QYAnnotationView.h"
#import "MapResult.h"

#import "RESideMenu.h"
#import "DDHomeAnnotation.h"
#import "DDHomeAnnotationView.h"

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "DDInterfaceTool.h"
#import "LSJPush.h"
#import "DDSelfInfomation.h"
#import "CustomSizeUtils.h"

#import "DDLocalUserInfoUtils.h"
#import "UIImageView+WebCache.h"

#import "DDRadarView.h"

/** 调节泡泡视图的上下位置 */
#define USER_LOCATION_RADIUS 60

#define DDHomeNavigationBarColor DDRGBAColor(212,25,38,1)
#define SenderDistanceFromMe 20

@interface DDHomeController() <
UIGestureRecognizerDelegate,
BMKMapViewDelegate,
BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate,
DDWaitCourierRushOrderViewDelegate,
DDWaitForCourierViewDelegate,
DDCancelOrderViewDelegate,
DDInterfaceDelegate,
DDRemindToPayViewDelegate,
DDPrepareSendViewDelegate,
DDCourierCompanyViewDelegate,
DDInputAddressControllerDelegate,
LSJPushProtocol, DDHomeAnnotationViewDelegate, DDPayCostDelegat, RESideMenuDelegate, UIAlertViewDelegate>
{
    DDHomeAnnotation *currentSelectedCourierAnnotation; //当前快递员
    DDHomeAnnotation *currentSendExpressAnnotation; //当前发件位置
    
    UIImageView *smallPaoPaoImageView;
    
    UIImageView *downwardArrowImageView;
    
    NSTimer *timer;
    NSInteger currentCircleViewTag;
    
    BOOL regionWillChangeEnable;
    
    DDCourierCoordinate *currentCourier;
    NSInteger currentTag;
    NSTimer *currentTimer;
    
    NSArray *currentCourierArray;
    NSMutableArray *companyArray;
    
    DDHomeAnnotation *currentLocationHomeAnnotation;
    
    BOOL deselectByRemove;
}

/** 自定义导航条 */
@property (nonatomic, weak) UIView *navView;
/** 地图 */
@property (nonatomic, strong) BMKMapView *mapView;
/** 定位 */
@property (nonatomic, strong) BMKLocationService *locService;
/** 用来获取用户位置 */
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;
/** 是否第一次载入 */
@property (assign, nonatomic) BOOL isFirstInit;
/** 带阴影气泡图 */
@property (strong, nonatomic) UIImageView *paopaoImageView;
/** 带阴影气泡图 */
@property (strong, nonatomic) UIView *paopaoBgView;
/** 快递公司选择 */
@property (strong, nonatomic) UIButton *companyLogoBtn;

@property (nonatomic, strong) UIImageView *companyLogoView;

/** 公里显示 */
@property (strong, nonatomic) UILabel *kilometerLabel;
/** 竖线 */
@property (strong, nonatomic) UIView *verticalLineView;
/** 点击寄件 */
@property (strong, nonatomic) UIButton *sentExpressButton;
/** 右箭头图片 */
@property (strong, nonatomic) UIImageView *rightArrow;
/** paopao正在同时快递员等待中 */
@property (strong, nonatomic) UILabel *waitCourierLabel;
/** paopao距离您xxx公里 */
@property (strong, nonatomic) UILabel *distanceUserLabel;
/** 地址显示框 */
//@property (strong, nonatomic) UIButton *addressTextView;
/** 显示框点击跳转输入地址按钮 */
@property (strong, nonatomic) UITextField *textInputAddress;
/** 检索 */
@property (strong, nonatomic) BMKGeoCodeSearch *searcher;
/** 地址栏的背景 */
//@property (strong, nonatomic) UIView *viewAddressBG;

/** 去支付画面View */
@property (nonatomic,strong) DDRemindToPayView * remindToPayView;
/** 取消订单对话框 */
@property (nonatomic,strong) DDCancelOrderView *cancelStyle1View;
/** 取消订单对话框 */
@property (nonatomic,strong) DDCancelOrderView *cancelStyle2View;
/** 等待快递员抢单显示框 */
@property (nonatomic,strong) DDWaitCourierRushOrderView *waitCourierRushOrderView;
/** 等待快递员取件显示框 */
@property (nonatomic,strong) DDWaitForCourierView *waitForCourierGetExpressView;
/** 数据加载页面 */
@property (nonatomic,strong) DDLoadingView *loadingView;

/**<  快递员位置服务器请求  */
@property (nonatomic, strong) DDInterface *locationInterface;
/**<  取消订单服务器请求  */
@property (nonatomic, strong) DDInterface *cancelOrderInterface;
/** 等待快递员抢单通知 */
@property (nonatomic, strong) DDInterface *waitForRushInterface;

@property (nonatomic, strong) DDInterface *shutDownInterface;

@property (nonatomic, strong) DDInterface * bindNeedPayInterface;

/** 预处理订单网络连接 */
@property (nonatomic, strong) DDInterface *pretreatmentInterface;
/** 查询用户个人基本信息 */
@property (nonatomic, strong) DDInterface *interfacePersonal;


@property (nonatomic,strong) DDInterface *InstantLocationInterface;

@property (nonatomic,strong) DDInterface *listenLocationInterface;


/**< 已经跳转到了等待快递员接件的倒计时页面(避免重复弹窗) */
//@property (assign, nonatomic) BOOL isBeginWaitingCourier;
/**< 当计时结束,Controller接收到的讯息 */
@property (nonatomic, assign) BOOL isTimeOver;
/**<  返回我的位置的按钮  */
@property (nonatomic, strong) UIButton *toSelfLocation;
/**<  地图区域是否发生过改变  */
@property (nonatomic, assign) BOOL isMapChanged;

/** 用户选择的快递公司 */
@property (nonatomic, strong) NSMutableArray *companyId;

/** 等待支付列表 */
@property (nonatomic, strong) NSMutableArray *waitPayOrderList;
/** 等待快递员列表 */

@property (nonatomic,strong) NSMutableArray *waitCourierGetOrderList;

/** 等待抢单列表 */
@property (nonatomic, strong) NSMutableArray *waitRusheOrderList;

@property (nonatomic, strong) DDAddressDetail *addressDetail;

@end

@implementation DDHomeController

#pragma mark - View Life Cycle

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    companyArray = [[NSMutableArray alloc] init];
    
    self.homePageStatus = DDHomePageWaitInit;
    
    [self createNavigationView];
    self.isTimeOver = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.sideMenuViewController.delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self disableBackGesture];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locService.delegate = self;
    
    [self.mapView mapForceRefresh];
    
    [self updateSelfLocationStyle];
    
    //不是等待取件页面
    if ([self isLocationEnabled:self.mapView.centerCoordinate] && self.homePageStatus != DDHomePageWaitForGetExpress && self.homePageStatus != DDHomePageWaitForRush) {
        
        CGPoint point = [self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:self.mapView];
        [self createRaydarAnimation:point];
    } else {
        [self removeRaydarAnimation];
    }
    
    [self.toSelfLocation addTarget:self action:@selector(toSelfLocationClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.selectedAddressDetail) {
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.selectedAddressDetail.latitude, self.selectedAddressDetail.longitude);
        self.selectedAddressDetail = nil;
    }
    
    //从其他页跳转回来时,如果本地保存的等待快递员取单信息不为空就重新弹出等待界面
    if ([DDGlobalVariables sharedInstance].backHomeViewNeedToShowCourierDetail) {
        [self popViewWithHomePageStatus:DDHomePageWaitForGetExpress];
        [DDGlobalVariables sharedInstance].backHomeViewNeedToShowCourierDetail = NO;
    }
    
    if (self.homePageStatus == DDHomePageWaitForRush) {
        self.homePageStatus = DDHomePageWaitForRush;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addNotificationObservers]; //添加通知监听
    [self addLocalServerObservers]; //服务端监听
    [LSJPush addJPushListener:self]; //推送监听
    
    if (self.homePageStatus == DDHomePageWaitForRush) {
        //wait for Rush - GetAllExpress
        self.sideMenuViewController.panGestureEnabled = NO;
        
        if ([self isLocationEnabled:[self resetCurrentSendExpressLocation]]) {
          
            [self getCourierLocation:[self resetCurrentSendExpressLocation].latitude longi:[self resetCurrentSendExpressLocation].longitude];
        }
        
    } else if (self.homePageStatus == DDHomePageWaitForGetExpress){
        
        self.sideMenuViewController.panGestureEnabled = NO;
        
        //get courier location
        [self popViewWithHomePageStatus:self.homePageStatus];
    
    } else {
        
        [self setHomePageWaitNoneStatus];
        self.sideMenuViewController.panGestureEnabled = [DDLocalUserInfoUtils userLoggedIn];
        
        [self removeCurrentSelectedCourierAnnotation];
        [self removeAlreadySendExpressRequestAnnotaiton];
    }
    
    if (self.showLoginStart) {
        [self checkWithUserLoginInfo];
        self.showLoginStart = NO;//标示置否
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate = nil;
    
    [self removeRaydarAnimation];
    
    [self removeTimer];
}

- (void)removeTimer
{
    [timer invalidate];
    timer = nil;
    
    [currentTimer invalidate];
    currentTimer = nil;
}

- (void)dealloc {
    if (self.mapView) {
        self.mapView = nil;
    }

    //移除推送监听
    [LSJPush removeJPushListener:self];
}


- (void)setWaitForCourierOrRushStatus
{
    [self.paopaoBgView setHidden:YES];
    [self.paopaoImageView setHidden:YES];
    [smallPaoPaoImageView setHidden:YES];
    [downwardArrowImageView setHidden:YES];
}

- (void)setHomePageWaitNoneStatus
{
    [self.paopaoBgView setHidden:NO];
    [self.paopaoImageView setHidden:NO];
    [smallPaoPaoImageView setHidden:NO];
    [downwardArrowImageView setHidden:NO];
    
//    [self toSelfLocationClick];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self getCourierLocation:self.mapView.centerCoordinate.latitude longi:self.mapView.centerCoordinate.longitude];
}

- (void)setWaitPayStatus
{
    [self.paopaoBgView setHidden:NO];
    [self.paopaoImageView setHidden:NO];
    [smallPaoPaoImageView setHidden:NO];
    [downwardArrowImageView setHidden:NO];
    
    [self toSelfLocationClick];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self getCourierLocation:self.mapView.centerCoordinate.latitude longi:self.mapView.centerCoordinate.longitude];
}

#pragma mark - AddObservers
- (void)addNotificationObservers
{
    DDAddNotification(@selector(pretreatmentOfOrders), KINTERFACE_TYPE_PRE_ORDER_LIST);
    DDAddNotification(@selector(personalDetailWithRequest), KNOTIFICATION_USER_INFORMATION);
}

- (void)addLocalServerObservers
{
    [self addPayCostObserver:YES]; //付款监听
}

- (void)updateSelfLocationStyle
{
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow = NO;
    [self.mapView updateLocationViewWithParam:param];
}


#pragma mark - Service Request
- (void)personalDetailWithRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (!self.interfacePersonal) {
        self.interfacePersonal = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfacePersonal interfaceWithType:INTERFACE_TYPE_SELF_INFORMATION param:param];
}

/**<  获取快递员的位置信息  */
- (void)getCourierLocation:(CGFloat)latitude longi:(CGFloat)longitude
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:@(latitude) forKey:@"lat"];
    [param setObject:@(longitude) forKey:@"lon"];
    
    if ([DDInterfaceTool getLoginSucced]) {
        if ([self.companyId count] > 0) {
            [param setObject:self.companyId forKey:@"corIdList"];
        }
    } else {
        if ([self.companyId count] > 0) {
            [param setObject:self.companyId forKey:@"courId"];
        }
    }
    
    //初始化连接
    DDInterface *locationInterface = [[DDInterface alloc] initWithDelegate:self];
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [locationInterface interfaceWithType:INTERFACE_TYPE_NEAR_COURIER param:param];
    self.locationInterface = locationInterface;
}

/**
 *  监听付款
 */
- (void)addPayCostObserver:(BOOL)open
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithBool:open] forKey:@"on"];
    
    DDInterface *interface = [[DDInterface alloc] initWithDelegate:self];
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [interface interfaceWithType:INTERFACE_TYPE_BIND_PAY param:param];
    self.bindNeedPayInterface = interface;
}

/**
 *  预处理订单
 */
- (void)pretreatmentOfOrders
{
    if ([self homePageIsTheFirstPage]) {
        [self.loadingView setHidden:NO];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.loadingView];
    }
    
    if (!self.pretreatmentInterface) {
        self.pretreatmentInterface = [[DDInterface alloc] initWithDelegate:self];
    }

    [self.pretreatmentInterface interfaceWithType:INTERFACE_TYPE_PRE_ORDER_LIST param:nil];
}

/**
 *  取消订单按钮请求
 */
- (void)cancelOrderRequest:(NSString *)orderId
{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (![CustomStringUtils isBlankString:orderId]) {
        [param setObject:orderId forKey:@"orderId"];
    }

    if (!self.cancelOrderInterface) {
        self.cancelOrderInterface = [[DDInterface alloc] initWithDelegate:self];
    }
    
    [self.cancelOrderInterface interfaceWithType:INTERFACE_TYPE_CANCEL_ORDER param:param];
}

/**
 *  等待快递员抢单 通知 true/开启   flase/关闭
 */
- (void)waitOrderRequest:(BOOL)flag
{
    //传参数字典(无模型)
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:flag],@"on", nil];
    
    //初始化连接
    if (flag) {
        //开启
        if (!self.waitForRushInterface) {
            self.waitForRushInterface = [[DDInterface alloc] initWithDelegate:self];
        }
        [self.waitForRushInterface interfaceWithType:INTERFACE_TYPE_WAIT_COURIER param:param];
    } else {
        //关闭
        if (!self.shutDownInterface) {
            self.shutDownInterface = [[DDInterface alloc] initWithDelegate:self];
        }
        [self.shutDownInterface interfaceWithType:INTERFACE_TYPE_WAIT_COURIER param:param];
    }
    
}

/**
 *  实时请求快递员位置
 */
- (void)instantLocationRequest:(NSString *)courierId andStatus:(NSInteger)status
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //传入快递员Id
    [param setObject:courierId forKey:@"couId"];
    [param setObject:@(status) forKey:@"start"];
    
    //初始化连接
    if (!self.InstantLocationInterface) {
        self.InstantLocationInterface = [[DDInterface alloc] initWithDelegate:self];
    }
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [self.InstantLocationInterface interfaceWithType:INTERFACE_TYPE_NEED_POSITION param:param];
}

/**
 *  开启快递员位置监听
 */
- (void)listenLocationRequest
{
    //初始化连接
    if (!self.listenLocationInterface) {
        self.listenLocationInterface = [[DDInterface alloc] initWithDelegate:self];
    }
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [self.listenLocationInterface interfaceWithType:INTERFACE_TYPE_BIND_POSITION param:nil];
}

#pragma mark -! DDInterface Delegate
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.locationInterface) {
        
        [self removeSmallPaoPaoAnimation];
        
        if (error) {
            if (self.homePageStatus != DDHomePageWaitForGetExpress && self.homePageStatus != DDHomePageWaitForRush) {
                [self updatePaoPaoViewWithCourierActive:NO];
            }
            
            [MBProgressHUD showError:error.domain];
        } else {
            if (!regionWillChangeEnable) {
                [self parseLocationJsonDic:result];
            }
        }
    } else if (interface == self.cancelOrderInterface) {
        //如果有错误，抛出
        if (error) {
            [self showForErrorMsg:error];
        } else {
            
            if (self.waitCourierGetOrderList.count > 0) {
                self.waitedCourierDetail = [self.waitCourierGetOrderList firstObject];
                self.homePageStatus = DDHomePageWaitForGetExpress;
            } else {
                [self getCourierLocation:self.mapView.centerCoordinate.latitude longi:self.mapView.centerCoordinate.longitude];
            }
            
        }
    } else if (interface == self.waitForRushInterface) {
        //如果有错误，抛出
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            //抢单成功 服务器推送
            DDCourierDetail *courierDetail = [DDCourierDetail yy_modelWithDictionary:result];
            self.waitedCourierDetail = courierDetail;
            
            [self.waitCourierGetOrderList addObject:courierDetail];
            
            self.homePageStatus = DDHomePageWaitForGetExpress;
            
        }
    } else if (interface == self.InstantLocationInterface) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            [self removeRaydarAnimation];
            [self removeAnimationWithAnnotations];
            
            CLLocationCoordinate2D courierCoordinate2D = CLLocationCoordinate2DMake([result[@"lat"] doubleValue], [result[@"lon"] doubleValue]);
            CGFloat betweenMeters = [self getMetersWithCourierLocation:courierCoordinate2D];
            
            [self.waitCourierLabel setText:[NSString stringWithFormat:@"距您%.1f公里",MAX(betweenMeters/1000, 0.1)]];
            
            deselectByRemove = YES;
            [self.mapView removeAnnotations:self.mapView.annotations];
            
            // 添加寄件地址 Annotaiton
            [self addAlreadySendExpressRequestAnnotation];
            
            //添加接单快递员位置
            [self addCurrentSelectedCourierAnnotationWithCoordinate:CLLocationCoordinate2DMake([[result objectForKey:@"lat"] doubleValue], [[result objectForKey:@"lon"] doubleValue])];
            
            [self setWaitForCourierOrRushStatus];

            //Add Courier RealTime Location Observer
            [self listenLocationRequest];
        }
    } else if (interface == self.shutDownInterface) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
        }
    } else if (interface == self.bindNeedPayInterface) {
        [self dissMissAllPopUpViews];
        DDPayCostController * payController = [[DDPayCostController alloc] init];
        payController.delegate = self;
        DDOrderDetail * orderDetail  = [DDOrderDetail yy_modelWithDictionary:result];
        payController.orderId = orderDetail.orderId;
        
        [self.navigationController pushViewController:payController animated:YES];
    } else if (interface == self.pretreatmentInterface) {
        
        if (error) {
            [MBProgressHUD showError:error.domain];
        }else {
            NSArray *array = result[@"orderList"];
            
            [self.waitRusheOrderList removeAllObjects];
            [self.waitCourierGetOrderList removeAllObjects];
            [self.waitPayOrderList removeAllObjects];
            
            for (NSDictionary *dict in array) {
                DDPreOrderDetail *preOrder = [DDPreOrderDetail yy_modelWithDictionary:dict];
                NSInteger orderStatus = preOrder.orderStatus;
                if (orderStatus == DDHomePageWaitForRush) {
        
                    [self.waitRusheOrderList addObject:@{preOrder.orderId:preOrder}];
                
                } else if (orderStatus == DDHomePageWaitForGetExpress) {
                    DDCourierDetail *courierDetail = [[DDCourierDetail alloc] init];
                    courierDetail.orderId = preOrder.orderId;
                    courierDetail.courierID = preOrder.courierId;
                    courierDetail.courierHeadIcon = preOrder.courierHeadIcon;
                    courierDetail.courierName = preOrder.courierName;
                    courierDetail.courierPhone = preOrder.courierPhone;
                    courierDetail.companyName = preOrder.companyName;
                    courierDetail.courierStar = preOrder.courierStar;
                    courierDetail.companyId = preOrder.companyId;
                    courierDetail.finishedOrderNumber = [NSString stringWithFormat:@"%ld", (long)preOrder.finishedOrderNumber];
                    courierDetail.latitude = preOrder.lat;
                    courierDetail.longitude = preOrder.lon;

                    [self.waitCourierGetOrderList addObject:courierDetail];
                } else if (orderStatus == DDHomePageWaitForPay) {

                    [self.waitPayOrderList addObject:preOrder.orderId];

                }
            }
            
            if (self.waitPayOrderList.count > 0) {
                
                self.homePageStatus = DDHomePageWaitForPay;
                
            } else if (self.waitRusheOrderList.count > 0) {
                
                NSDictionary *tmpDic = [self.waitRusheOrderList objectAtIndex:0];
                DDPreOrderDetail *preOrder = [tmpDic allValues][0];
                [DDCenterCoordinate setSendExpressInfoWithCoordinate:CLLocationCoordinate2DMake([preOrder.lat doubleValue], [preOrder.lon doubleValue])];
                self.homePageStatus = DDHomePageWaitForRush;
                
                [self setWaitForCourierOrRushStatus];
                
            } else if (self.waitCourierGetOrderList.count > 0) {
                
                self.waitedCourierDetail = self.waitCourierGetOrderList[0];
                [DDCenterCoordinate setSendExpressInfoWithCoordinate:CLLocationCoordinate2DMake([self.waitedCourierDetail.latitude doubleValue], [self.waitedCourierDetail.longitude doubleValue])];
                self.homePageStatus = DDHomePageWaitForGetExpress;
                
                [self removeAlreadySendExpressRequestAnnotaiton];
                [self addAlreadySendExpressRequestAnnotationWithCoordinate:CLLocationCoordinate2DMake([self.waitedCourierDetail.latitude doubleValue], [self.waitedCourierDetail.longitude doubleValue])];
                
                [self setWaitForCourierOrRushStatus];
                
            } else {
                
                self.homePageStatus = DDHomePageWaitNone;
            }
        }
    } else if (interface == self.interfacePersonal) {
       
        if (!error) {
            
            NSString *userPhoneNumber = [DDInterfaceTool getPhoneNumber] ? : @"";
            [DDLocalUserInfoUtils setLocalUserInfo:result];
            [DDLocalUserInfoUtils updateUserId:[NSString stringWithFormat:@"%ld",(long)[DDInterfaceTool getUserID]]];
            
            if ([CustomStringUtils isBlankString:[DDLocalUserInfoUtils getUserPhone]] && ![CustomStringUtils isBlankString:userPhoneNumber]) {
                [DDLocalUserInfoUtils updateUserPhone:userPhoneNumber];
            }
        } else {
            NSLog(@"%@", error);
        }
    } else if (interface == self.listenLocationInterface) {
        
        if (!error) {
            
            if ([[result objectForKey:@"couId"] isEqualToString:currentSelectedCourierAnnotation.courierId]) {
                [currentSelectedCourierAnnotation setCoordinate:CLLocationCoordinate2DMake([[result objectForKey:@"lat"] doubleValue], [[result objectForKey:@"lon"] doubleValue])];
            }
            
        } else {
            NSLog(@"%@", error);
        }
    }
}


- (CGFloat)getMetersWithCourierLocation:(CLLocationCoordinate2D)coordinate2D
{
    BMKMapPoint courierPoint = BMKMapPointForCoordinate(coordinate2D);
    BMKMapPoint clientMapPoint = BMKMapPointForCoordinate(self.locService.userLocation.location.coordinate);
    CGFloat betweenMeters = BMKMetersBetweenMapPoints(clientMapPoint, courierPoint);
    
    return betweenMeters;
}

//CGPoint firstPoint = [self.mapView convertCoordinate:CLLocationCoordinate2DMake([@"30.305071" doubleValue], [@"120.113552" doubleValue]) toPointToView:self.mapView];
//CGPoint middlePosition = [self.mapView convertCoordinate:CLLocationCoordinate2DMake([@"30.304971" doubleValue], [@"120.112962" doubleValue]) toPointToView:self.mapView];
//CGPoint lastPosition = [self.mapView convertCoordinate:CLLocationCoordinate2DMake([@"30.304872" doubleValue], [@"120.113552" doubleValue]) toPointToView:self.mapView];
//
//
//annotation.coordinate = CLLocationCoordinate2DMake([@"30.305071" doubleValue], [@"120.113552" doubleValue]);
//
//[currentTmpArray addObject:[NSValue valueWithCGPoint:firstPoint]];
//[currentTmpArray addObject:[NSValue valueWithCGPoint:middlePosition]];
//[currentTmpArray addObject:[NSValue valueWithCGPoint:lastPosition]];

- (void)parseLocationJsonDic:(NSDictionary *)jsonDic
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSArray *tmpArray = [NSArray array];
    
    tmpArray = [jsonDic objectForKey:@"courierList"];
    
    if ([tmpArray count] == 0) {
      
        for (DDHomeAnnotation *annotation in self.mapView.annotations) {
            if (annotation != currentSendExpressAnnotation) {
                [self.mapView removeAnnotation:annotation];
            }
        }
        
        [self updatePaoPaoViewWithCourierActive:NO];
    } else {
        for (NSDictionary *tmpDic in tmpArray) {
            DDCourierCoordinate *courierCoordinate = [[DDCourierCoordinate alloc] initWithDictionary:tmpDic];
            [tempArray addObject:courierCoordinate];
        }
        
        NSMutableArray *showCourierArray = [[NSMutableArray alloc] init];
        for (DDCourierCoordinate *courier in tempArray) {
            
            DDHomeAnnotation *homeAnnotation = [[DDHomeAnnotation alloc] init];
            
            //        NSArray *firstArray = [courier.positionList objectAtIndex:0];
            //        NSArray *secondArray = [courier.positionList objectAtIndex:1];
            //        NSArray *thirdArray = [courier.positionList objectAtIndex:2];
            
            NSArray *lastArray = [courier.positionList firstObject];
            
            //        CLLocationCoordinate2D firstCoordinate = CLLocationCoordinate2DMake([firstArray[1] doubleValue], [firstArray[0] doubleValue]);
            //
            //        CLLocationCoordinate2D secondCoordinate = CLLocationCoordinate2DMake([secondArray[1] doubleValue], [secondArray[0] doubleValue]);
            //
            //        CLLocationCoordinate2D thirdCoordinate = CLLocationCoordinate2DMake([thirdArray[1] doubleValue], [thirdArray[0] doubleValue]);
            
            CLLocationCoordinate2D lastCoordinate = CLLocationCoordinate2DMake([lastArray[1] doubleValue], [lastArray[0] doubleValue]);
            
            //        NSMutableArray *firstTempArray = [self addTenMiddleLocationFromFirstLocation:firstCoordinate secondCoordinate:secondCoordinate];
            //
            //        NSMutableArray *secondTempArray = [self addTenMiddleLocationFromFirstLocation:secondCoordinate secondCoordinate:thirdCoordinate];
            //
            //        [firstTempArray addObjectsFromArray:secondTempArray];
            
            homeAnnotation.coordinate = lastCoordinate;
            
            //        homeAnnotation.positionArray = firstTempArray;
            homeAnnotation.locationPositionArray = courier.positionList;
            homeAnnotation.companyId = courier.companyID;
            homeAnnotation.companyLogo = courier.companyLogo;
            homeAnnotation.courierId = courier.courierID;
            
            [showCourierArray addObject:homeAnnotation];
        }
        
        for (DDHomeAnnotation *annotation in self.mapView.annotations) {
            if (![annotation isEqual:currentSendExpressAnnotation]) {
                deselectByRemove = YES;
                [self.mapView removeAnnotation:annotation];
            }
        }
        [self.mapView addAnnotations:showCourierArray];
        
        currentCourierArray = showCourierArray;
        //    [self startAnimationWithAnnotations]; //Begin animate Annotations
        
        [self updatePaoPaoViewWithCourierActive:(showCourierArray.count > 0)];
    }
    
    if (self.homePageStatus == DDHomePageWaitForRush) {
        [self setWaitForCourierOrRushStatus];
    }
    
}

- (void)startAnimationWithAnnotations
{
    currentTag = 0;
    
    if (currentTimer) {
        [currentTimer invalidate];
        currentTimer = nil;
    }
    
    currentTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeOldAddNewAnnotation) userInfo:nil repeats:YES];
}

- (void)removeAnimationWithAnnotations
{
    [currentTimer invalidate];
    currentTimer = nil;
    
    currentCourierArray = [[NSMutableArray alloc] init];
}

- (void)removeOldAddNewAnnotation
{
    for (DDHomeAnnotation *annotation in currentCourierArray) {
    
        NSMutableArray *array = [annotation.positionArray mutableCopy];
        
        if (currentTag < array.count) {
            NSDictionary *tempDic = [array objectAtIndex:currentTag];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[tempDic objectForKey:@"latitude"] doubleValue], [[tempDic objectForKey:@"longtitude"] doubleValue]);
            
            
            if (currentTag > 0) {
                deselectByRemove = YES;
                [self.mapView removeAnnotation:annotation];
            }
            
            annotation.coordinate = coordinate;
            [self.mapView addAnnotation:annotation];
        } else {
            [currentTimer invalidate];
            currentTimer = nil;
        }
    }
    
    currentTag ++;
    
}

- (NSMutableArray *)addTenMiddleLocationFromFirstLocation:(CLLocationCoordinate2D)firstCoordinate secondCoordinate:(CLLocationCoordinate2D)secondCoordinate
{
    CGPoint firstPoint = [self.mapView convertCoordinate:firstCoordinate toPointToView:self.mapView];
    CGPoint secondPoint = [self.mapView convertCoordinate:secondCoordinate toPointToView:self.mapView];
    
    CGFloat beginPointX = firstPoint.x;
    CGFloat endPointX = secondPoint.x;
    
    CGFloat beginPointY = firstPoint.y;
    CGFloat endPointY = secondPoint.y;
    
    CGFloat averageX = (endPointX - beginPointX) / 5;
    CGFloat averageY = (endPointY - endPointY) / 5;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:@{@"latitude":@(firstCoordinate.latitude), @"longtitude":@(firstCoordinate.longitude)}];
    
    for (int i = 0; i < 5; i++) {
        
        beginPointX += averageX;
        beginPointY += averageY;
        
        CLLocationCoordinate2D coordinate2D = [self.mapView convertPoint:CGPointMake(beginPointX, beginPointY) toCoordinateFromView:self.mapView];
        [tempArray addObject:@{@"latitude":@(coordinate2D.latitude), @"longtitude":@(coordinate2D.longitude)}];
    }
    
    return tempArray;
}

// GetMetersByNearestCourierLocation
- (NSString *)getMetersByNearestCourierLocation
{
    if ([self.mapView.annotations count] > 0) {
        
        CGFloat minMeters = 0;
        
        DDHomeAnnotation *firstAnnotation = [self.mapView.annotations objectAtIndex:0];
        
        NSArray *aryLocation = [firstAnnotation.locationPositionArray firstObject];
        
        BMKMapPoint courierPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([aryLocation[1] doubleValue], [aryLocation[0] doubleValue]));
        
        BMKMapPoint clientMapPoint = BMKMapPointForCoordinate([self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView]);
        
        CGFloat betweenMeters = BMKMetersBetweenMapPoints(clientMapPoint, courierPoint);
        minMeters = betweenMeters;
        
        DDHomeAnnotation *minHomeAnnotation = firstAnnotation;
        
        for (DDHomeAnnotation *annotation in self.mapView.annotations) {
            NSArray *aryLocation = [annotation.locationPositionArray firstObject];
            BMKMapPoint courierPoint = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([aryLocation[1] doubleValue], [aryLocation[0] doubleValue]));
            CGFloat betweenMeters = BMKMetersBetweenMapPoints(clientMapPoint, courierPoint);
            
            if (betweenMeters < minMeters) {
                minMeters = betweenMeters;
                minHomeAnnotation = annotation;
            }
        }
        
        [self.companyLogoView sd_setImageWithURL:[NSURL URLWithString:minHomeAnnotation.companyLogo] placeholderImage:ImageNamed(KClientIcon48)];
        
        return [NSString stringWithFormat:@"%.1fkm", minMeters/1000.f];
    }
    
    return @"附近暂无快递员";
}

#pragma mark - Handle_PaoPaoView_Service

- (void)updatePaoPaoViewWithCourierActive:(BOOL)courierActive
{
    if (courierActive) {
    
        [self.paopaoImageView setSize:CGSizeMake(185.5, 36.5)];
        [self.paopaoImageView setCenter:CGPointMake(self.mapView.center.x, self.mapView.center.y - USER_LOCATION_RADIUS)];
        
        [self.companyLogoView setHidden:NO];
        [self.companyLogoView setFrame:CGRectMake(10, CGRectGetHeight(_paopaoImageView.bounds) / 2 - 28 / 2, 28, 28)];
        
        CGSize sentBtnSize = [@"我要寄件" boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        CGFloat sentBtnWidth = sentBtnSize.width;
        CGFloat rightSideWidth = sentBtnWidth + 12 + 5 + 14 + 9;
        
        self.kilometerLabel.text = [self getMetersByNearestCourierLocation];
        self.kilometerLabel.textAlignment = NSTextAlignmentLeft;
        
        CGFloat kiloMeterWidth = [CustomSizeUtils customSizeWithStr:self.kilometerLabel.text font:[UIFont systemFontOfSize:14.f] size:CGSizeMake(MAXFLOAT, 14)].width;
        
        [self.kilometerLabel setFrame:CGRectMake(CGRectGetMaxX(self.companyLogoView.frame) + 5, 16, kiloMeterWidth, 15)];
        self.kilometerLabel.center = CGPointMake(CGRectGetMinX(self.kilometerLabel.frame) + CGRectGetWidth(self.kilometerLabel.bounds) / 2, self.companyLogoView.center.y);
        [self.verticalLineView setFrame:CGRectMake(CGRectGetMaxX(self.kilometerLabel.frame) + 5, CGRectGetMinY(self.verticalLineView.frame), 0.5, 36.5)];
        [self.rightArrow setFrame:CGRectMake(CGRectGetWidth(_paopaoImageView.bounds) - 9 - 14, CGRectGetMinY(self.rightArrow.frame), 7, 14)];
        
        self.companyLogoBtn.hidden = NO;
        [self.companyLogoBtn setFrame:CGRectMake(0, CGRectGetMinY(self.companyLogoBtn.frame), CGRectGetMinX(self.verticalLineView.frame), CGRectGetHeight(self.companyLogoBtn.bounds))];
        
        [self.sentExpressButton setFrame:CGRectMake(CGRectGetMaxX(self.verticalLineView.frame), CGRectGetMinY(self.sentExpressButton.frame), rightSideWidth, CGRectGetHeight(self.sentExpressButton.bounds))];
        self.sentExpressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.sentExpressButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        self.sentExpressButton.enabled = YES;
        
        [self.rightArrow setFrame:CGRectMake(CGRectGetMaxX(self.verticalLineView.frame) + rightSideWidth - 9 - 14, CGRectGetMinY(self.rightArrow.frame), CGRectGetWidth(self.rightArrow.bounds), CGRectGetHeight(self.rightArrow.bounds))];

        
        [self.paopaoImageView setSize:CGSizeMake(CGRectGetMaxX(self.verticalLineView.frame) + rightSideWidth, CGRectGetHeight(self.paopaoImageView.bounds))];
        [self.paopaoImageView setCenter:CGPointMake(self.mapView.center.x, self.mapView.center.y - USER_LOCATION_RADIUS)];
        self.paopaoImageView.image = [self.paopaoImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30) resizingMode:UIImageResizingModeStretch];
        
        self.paopaoBgView.frame = self.paopaoImageView.bounds;
        
        [downwardArrowImageView setFrame:CGRectMake(CGRectGetMinX(_paopaoImageView.frame) + CGRectGetWidth(_paopaoImageView.bounds) / 2 - 12.5 / 2, CGRectGetMaxY(_paopaoImageView.frame), 12.5, 8)];
        
    } else {
        
        [self.paopaoImageView setHidden:NO];
        
        [self.companyLogoView setHidden:YES];
        
        CGSize sentBtnSize = [@"我要寄件" boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        CGFloat sentBtnWidth = sentBtnSize.width;
        CGFloat rightSideWidth = sentBtnWidth + 12 + 5 + 14 + 9;
        
        CGSize labelSize = [@"附近暂无快递员" boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        self.kilometerLabel.text = @"附近暂无快递员";
        [self.kilometerLabel setFrame:CGRectMake(20, 10.5, labelSize.width, CGRectGetHeight(self.kilometerLabel.bounds))];
        self.kilometerLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.verticalLineView setFrame:CGRectMake(CGRectGetMaxX(self.kilometerLabel.frame) + 8, CGRectGetMinY(self.verticalLineView.frame), CGRectGetWidth(self.verticalLineView.bounds), CGRectGetHeight(self.verticalLineView.bounds))];
        
        [self.sentExpressButton setFrame:CGRectMake(CGRectGetMaxX(self.verticalLineView.frame), CGRectGetMinY(self.sentExpressButton.frame), rightSideWidth, CGRectGetHeight(self.sentExpressButton.bounds))];
        self.sentExpressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.sentExpressButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [self.rightArrow setFrame:CGRectMake(CGRectGetMaxX(self.verticalLineView.frame) + rightSideWidth - 9 - 14, CGRectGetMinY(self.rightArrow.frame), CGRectGetWidth(self.rightArrow.bounds), CGRectGetHeight(self.rightArrow.bounds))];
        self.companyLogoBtn.hidden = NO;
        
        [self.paopaoImageView setSize:CGSizeMake(CGRectGetMaxX(self.verticalLineView.frame) + rightSideWidth, CGRectGetHeight(self.paopaoImageView.bounds))];
        [self.paopaoImageView setCenter:CGPointMake(self.mapView.center.x, self.mapView.center.y - USER_LOCATION_RADIUS)];
        self.paopaoImageView.image = [self.paopaoImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
        
        self.paopaoBgView.frame = self.paopaoImageView.bounds;
        
        [downwardArrowImageView setFrame:CGRectMake(CGRectGetMinX(_paopaoImageView.frame) + CGRectGetWidth(_paopaoImageView.bounds) / 2 - 12.5 / 2, CGRectGetMaxY(_paopaoImageView.frame), 12.5, 8)];
    }
}

#pragma mark - LSJPush delegate
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //LSScanningController *sc = [[LSScanningController alloc] init];
    //[self.navigationController pushViewController:sc animated:YES];
}

#pragma mark - 初始化导航栏视图
- (void)createNavigationView
{
    //Navigation View
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, KNavHeight)];
    [navigationView setBackgroundColor:DDGreen_Color];
    [self.view addSubview:navigationView];
    
    // Left Button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0 ,navigationView.height - 44.0f, 50.0f, 44.0f)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton setAdjustsImageWhenDisabled:false];
    [leftButton addTarget:self action:@selector(onClickShowPersonalCenter:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:leftButton];
    
    UIImageView *imgLeft = [[UIImageView alloc] init];
    [imgLeft setSize:CGSizeMake(20.0f, 20.0f)];
    [imgLeft setCenter:CGPointMake(leftButton.centerx, leftButton.centery)];
    [imgLeft setImage:[UIImage imageNamed:DDHomePersonalIcon]];
    [imgLeft setBackgroundColor:[UIColor clearColor]];
    [imgLeft setUserInteractionEnabled:false];
    [leftButton addSubview:imgLeft];
    
    NSString *right_title = @"我的包裹";
    CGSize size_right = [right_title sizeWithAttributes:@{NSFontAttributeName:kContentFont}];
    
    // right Button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(navigationView.width - floorf(size_right.width+30.0f), leftButton.top,floorf(size_right.width+30.0f), leftButton.height)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton setTitle:right_title forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:kContentFont];
    [rightButton setAdjustsImageWhenDisabled:false];
    [rightButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:rightButton];
    
    // Title
    UILabel *appTitle = [[UILabel alloc] initWithFrame:CGRectMake(leftButton.right + kMargin, leftButton.top, navigationView.width - leftButton.right*2.0f - kMargin*2.0f, leftButton.height)];
    [appTitle setBackgroundColor:[UIColor clearColor]];
    [appTitle setTextAlignment:NSTextAlignmentCenter];
    [appTitle setFont:kButtonFont];
    [appTitle setTextColor:[UIColor whiteColor]];
    [appTitle setText:DDDispalyName];
    [navigationView addSubview:appTitle];
    
    /** 初始化地址栏 */
    [self createAddressTitleView];
}

/**
 *   初始化地址栏
 */
- (void)createAddressTitleView
{
    if (self.textInputAddress != nil) {
        return;
    }
    UIView *viewAddressBG = [[UIView alloc] initWithFrame:CGRectMake(0, KNavHeight, self.view.frame.size.width, 56)];
    [viewAddressBG setBackgroundColor:DDGreen_Color];
    [self.view addSubview:viewAddressBG];
    
    UIButton *addressTextView = [[UIButton alloc] initWithFrame:CGRectMake(15.0f, 12.0f, viewAddressBG.width-30.0f, 32.0f)];;
    [addressTextView setBackgroundColor:[UIColor clearColor]];
    [addressTextView addTarget:self action:@selector(inputAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAddressBG addSubview:addressTextView];
    
    self.textInputAddress = [[UITextField alloc] initWithFrame:addressTextView.bounds];
    [self.textInputAddress setBackgroundColor:DDRGBAColor(28, 176, 108, 1)];
    [self.textInputAddress.layer setCornerRadius:self.textInputAddress.height/2.0f];
    [self.textInputAddress.layer setMasksToBounds:true];
    [self.textInputAddress setFont:kTitleFont];
    [self.textInputAddress setTextColor:[UIColor whiteColor]];
    [self.textInputAddress setTextAlignment:NSTextAlignmentLeft];
    [self.textInputAddress setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.textInputAddress setUserInteractionEnabled:false];
    [addressTextView addSubview:self.textInputAddress];
    
    
    //输入框左边的图标icon
    UIView *leftView = [[UIView alloc] init];
    [leftView setFrame:CGRectMake(0, 0, 42.0f, self.textInputAddress.height)];
    [leftView setBackgroundColor:[UIColor clearColor]];
    [self.textInputAddress setLeftView:leftView];
    [self.textInputAddress setLeftViewMode:UITextFieldViewModeAlways];
    
    UIImageView *imgIcon = [[UIImageView alloc] init];
    [imgIcon setSize:CGSizeMake(15.0f, 15.0f)];
    [imgIcon setCenter:CGPointMake(leftView.centerx, leftView.centery)];
    [imgIcon setBackgroundColor:[UIColor clearColor]];
    [imgIcon setImage:[UIImage imageNamed:DDHomeSearchMapIcon]];
    [leftView addSubview:imgIcon];
    
    //输入框右边的视图
    UIView *rightView = [[UIView alloc] init];
    [rightView setFrame:CGRectMake(0, 0, 20.0f, self.textInputAddress.height)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    [self.textInputAddress setRightView:rightView];
    [self.textInputAddress setRightViewMode:UITextFieldViewModeAlways];
}

#pragma mark - 对象方法:初始化视图
/**
 *  初始化雷达动画
 */
- (void)createRaydarAnimation:(CGPoint)position
{
    [self removeRaydarAnimation];
    
    DDRadarView *radarView = [self.mapView viewWithTag:12345];
    if (!radarView) {
        radarView = [[DDRadarView alloc] initWithFrame:CGRectMake(position.x - 10, position.y - 10, 20, 20) thumbnail:@"locationCenter"];
        radarView.tag = 12345;
        [self.mapView addSubview:radarView];
    }
}

- (void)removeRaydarAnimation
{
    DDRadarView *radarView = [self.mapView viewWithTag:12345];
    if (radarView) {
        [radarView removeFromSuperview];
    }
}

#pragma mark - 更改大头针泡泡显示
/**
 *  显示气泡标注视图的内容
 */
- (void)showPaoPaoBgViews
{
    self.distanceUserLabel.hidden = YES;
    self.waitCourierLabel.hidden = YES;
    [self.paopaoImageView setImage:[UIImage imageNamed:@"normal"]];
    self.paopaoBgView.hidden = NO;
}

/**
 *   初始化大头针(等待上门取件页面:快递员距离-距您2.5公里)
 */
- (void)showDistancePaoPaoView
{
    self.distanceUserLabel.hidden = NO;
    
    self.waitCourierLabel.hidden = YES;
    self.paopaoBgView.hidden = YES;
}

/** 发起反地理编码搜索 */
- (void)beginReverseGeoCodeSearch
{
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = self.mapView.centerCoordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
}

- (BOOL)homePageIsTheFirstPage
{
    return [[self.navigationController.childViewControllers lastObject] isKindOfClass:[self class]];
}
#pragma mark - BMKMapViewDelegate
/**
 *  设置快递员位置的delegate方法
 *
 *  @param mapView    地图对象
 *  @param annotation 标注图对象
 *
 *  @return 返回一个视图
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    static NSString *identifier = @"DDHomeAnnotationView";
    
    DDHomeAnnotationView *annotationView = (DDHomeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView == nil) {
        annotationView = [[DDHomeAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }

    DDHomeAnnotation *homeAnnotation = (DDHomeAnnotation *)annotation;
    
    
    if ([homeAnnotation isEqual:currentSendExpressAnnotation]) {
        annotationView.image = ImageNamed(@"locationCenter");
    
        if (self.homePageStatus == DDHomePageWaitForGetExpress) {
            homeAnnotation.title = self.waitCourierLabel.text;
            BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:nil];
            annotationView.paopaoView = paopaoView;
            
            [annotationView setSelected:YES animated:YES];
        } else {
            homeAnnotation.title = nil;
        }
    } else {
        annotationView.image = ImageNamed(homeAnnotation.companyId);
    }

    return annotationView;
}

- (UIView *)createCustomPaoPaoViewWithAnnotation:(DDHomeAnnotation *)annotation
{
    
    return nil;
}

/**
 *   当mapView完成加载的时候
 *  @param mapView 地图对象
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    [self.locService startUserLocationService];//启动定位服务
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [DDCenterCoordinate setCenterCoordinate:self.mapView.centerCoordinate];
    
    self.isMapChanged = YES;
    
    if (self.homePageStatus != DDHomePageWaitForGetExpress && self.homePageStatus != DDHomePageWaitForRush) {
        CGPoint point = [self.mapView convertCoordinate:self.mapView.centerCoordinate toPointToView:self.mapView];
        [self createRaydarAnimation:point];
    } else {
        [self removeRaydarAnimation];
    }
    
    if (self.homePageStatus == DDHomePageWaitForRush) {
        
        if (regionWillChangeEnable) {
            regionWillChangeEnable = NO;
        }
        
    } else if (self.homePageStatus == DDHomePageWaitForGetExpress){
        
        if (regionWillChangeEnable) {
            regionWillChangeEnable = NO;
        }
        
    } else {
        
        if (regionWillChangeEnable) {
            
            regionWillChangeEnable = NO;
            
            [self updatePaoPaoBgViewHidden:NO];
            
            [self beginReverseGeoCodeSearch];
            [self getCourierLocation:mapView.centerCoordinate.latitude longi:mapView.centerCoordinate.longitude];
        }
    }

}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self removeRaydarAnimation];
    
    regionWillChangeEnable = YES;
    
    if (self.homePageStatus == DDHomePageWaitForGetExpress){
        
    } else if (self.homePageStatus == DDHomePageWaitForRush){
        
        
    } else {
        [self addSmallPaoPaoAnimation];
        [self updatePaoPaoViewAnimation];
    }
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if ([(DDHomeAnnotationView *)view.annotation isEqual:currentSendExpressAnnotation] && !deselectByRemove) {
        
        [self removeAlreadySendExpressRequestAnnotaiton];
        view.paopaoView = nil;
        
        [self addAlreadySendExpressRequestAnnotation];
        
        if (self.homePageStatus == DDHomePageWaitForGetExpress) {
            [view setSelected:YES animated:YES];
        }
    }
}


- (void)updatePaoPaoViewAnimation
{
    self.paopaoBgView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y);
    [self updatePaoPaoBgViewHidden:YES];
    
    [UIView animateWithDuration:.2 animations:^{
        [self.paopaoImageView setFrame:CGRectMake(CGRectGetMinX(self.paopaoImageView.frame) + CGRectGetWidth(self.paopaoImageView.bounds) / 2, CGRectGetMinY(self.paopaoImageView.frame), 0, CGRectGetHeight(self.paopaoImageView.bounds))];
    }];
}

- (void)updatePaoPaoBgViewHidden:(BOOL)hidden
{
    for (UIView *subView in self.paopaoBgView.subviews) {
        subView.hidden = hidden;
    }
}

- (void)addSmallPaoPaoAnimation
{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(changeCircleViewBounds) userInfo:nil repeats:YES];
        currentCircleViewTag = 100;
        [timer fire];
    }
}

- (void)removeSmallPaoPaoAnimation
{
    [timer invalidate];
    timer = nil;
}

- (void)changeCircleViewBounds
{
    if (currentCircleViewTag == 103) {
        currentCircleViewTag = 100;
    }
    
    for (int i = 100; i < 103; i++) {
        if (currentCircleViewTag == i) {
            UIView *circleView = [smallPaoPaoImageView viewWithTag:i];
            [circleView setBackgroundColor:RGBCOLOR(210, 210, 210)];
        } else {
            UIView *circleView = [smallPaoPaoImageView viewWithTag:i];
            [circleView setBackgroundColor:RGBCOLOR(233, 233, 233)];
        }
        
    }
    
    currentCircleViewTag ++;
}

#pragma mark - BMKGeoCodeSearchDelegate
/** 接收反向地理编码结果 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //检索结果正常返回
    if (error == BMK_SEARCH_NO_ERROR)
    {
        self.addressDetail.phone = [DDInterfaceTool getPhoneNumber];
        self.addressDetail.latitude = result.location.latitude;
        self.addressDetail.longitude = result.location.longitude;
        self.addressDetail.provinceName = result.addressDetail.province;
        self.addressDetail.cityName = result.addressDetail.city;
        self.addressDetail.districtName = result.addressDetail.district;
        if (result.poiList.count > 0) {
            BMKPoiInfo *poiInfo = [result.poiList objectAtIndex:0];
            self.addressDetail.addressName = poiInfo.name;
        } else {
            self.addressDetail.addressName = [NSString stringWithFormat:@"%@%@",result.addressDetail.streetName,result.addressDetail.streetNumber];
        }
        self.addressDetail.localDetailAddress = [NSString stringWithFormat:@"%@%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName,result.addressDetail.streetNumber];
        self.addressDetail.contentAddress = [NSString stringWithFormat:@"%@/%@",self.addressDetail.localDetailAddress,self.addressDetail.addressName];
//        [[DDGlobalVariables sharedInstance] setHomeLocAddressDetail:self.addressDetail];
        
        [self.textInputAddress setText:self.addressDetail.addressName];
        
        
    }
}

#pragma mark - BMKLocationServiceDelegate 定位信息:代理方法
/** 在地图View将要启动定位时，会调用此函数 */
- (void)willStartLocatingUser
{
}

/** 停止定位时触发 */
- (void)didStopLocatingUser
{
}

/** 定位失败时调用 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    if (![self isLocationEnabled:self.locService.userLocation.location.coordinate]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务已关闭" message:@"请到设置>隐私>定位服务中开启［艾特小哥］定位服务，以便您能够正常使用寄件功能。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alertView show];
    }
}

/** 用户位置更新后，会调用此函数 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    
    [DDCenterCoordinate setCenterCoordinate:self.mapView.centerCoordinate];
    [DDCenterCoordinate setUserLocation:userLocation.location.coordinate];
    
    //如果是第一次初始化视图, 那么定位点置中
    if (self.isFirstInit == NO) {
        self.mapView.centerCoordinate = self.locService.userLocation.location.coordinate;
        self.isFirstInit = YES;
        //发起反地理编码,获取当前的详细地址并显示在textfield上
        [self beginReverseGeoCodeSearch];
        
        if (self.locService.userLocation.location.coordinate.latitude > 0 && self.locService.userLocation.location.coordinate.longitude > 0) {
            [self getCourierLocation:self.locService.userLocation.location.coordinate.latitude longi:self.locService.userLocation.location.coordinate.longitude];
        }

    }
}

#pragma mark - Action 按钮点击事件
/**
 左button
 */
- (void)leftAction:(id)sender
{
    /** 判断，用户是否已登录 */
    if ([self checkWithUserLoginInfo]) {
    }
}

/**
 右button
 */
- (void)rightAction:(id)sender
{
    /** 判断，用户是否已登录 */
    if ([self checkWithUserLoginInfo]) {
        DDMyExpressListController *controller = [[DDMyExpressListController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/**
 *   我要寄件按钮
 */
- (void)sentExpressClick
{
    /** 判断，用户是否已登录 */
    if ([self checkWithUserLoginInfo]) {
        
        if (self.waitPayOrderList.count > 0) {
            self.remindToPayView.hidden = NO;
            self.remindToPayView.unPayCount = -1;
            return;
        }
        [self dissMissAllPopUpViews];
        DDPrepareSendViewController *controller = [[DDPrepareSendViewController alloc] init];
        controller.isFromHomePage = YES;
        controller.delegate = self;
        controller.expressCompanyArray = companyArray;
        controller.lastViewFlag = 0;
        controller.homeAddressDetail = self.addressDetail;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
/**
 *   快递公司Logo按钮(点击事件)
 */
- (void)companyChooseClick
{
    /** 判断，用户是否已登录 */
    if ([self checkWithUserLoginInfo]) {
        DDCourierCompanyViewController *controller = [[DDCourierCompanyViewController alloc] init];
        [controller setDelegate:self];
        [controller setIdArray:self.companyId];
        [self.navigationController pushViewController:controller  animated:YES];
    }
}

/**
 *   输入地址(点击事件)
 */
- (void)inputAddressButtonClick
{
    /** 判断，用户是否已登录 */
    if ([self checkWithUserLoginInfo])
    {
        DDInputAddressController *controller = [[DDInputAddressController alloc] init];
        [controller setBackgroundMapImage:[self.mapView takeSnapshot]];
        controller.delegate = self;
        controller.isBackToHome = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/** 判断，用户是否已登录 */
- (BOOL)checkWithUserLoginInfo
{
    if (![DDLocalUserInfoUtils userLoggedIn]) {
        DDRegistController *controller = [[DDRegistController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    return [DDLocalUserInfoUtils userLoggedIn];
}

/**<  gps返回自己的地理位置按钮  */
- (void)toSelfLocationClick
{
    if ([self isLocationEnabled:self.locService.userLocation.location.coordinate]) {
        if (self.isMapChanged == YES) {
            [self.mapView setCenterCoordinate:self.locService.userLocation.location.coordinate animated:YES];
            self.isMapChanged = NO;
        }
    }
}

#pragma mark - Controller Delegate
/**
 *  弹出等待取件
 */
- (void)popWaitForCourierToGetExpressView:(DDCourierDetail *)courierDetail
{
    /** 隐藏等待抢单视图 */
    if (self.waitCourierRushOrderView.y == 0) {
        [self.waitCourierRushOrderView dismissAlert];
        self.isTimeOver = NO;
    }
    
    /** 如果取消订单窗口浮现，同时也隐藏掉 */
    if (self.cancelStyle1View.alpha == 1.0) {
        [self.cancelStyle1View dismissAlert];
    }
    if (self.cancelStyle2View.alpha == 1.0) {
        [self.cancelStyle2View dismissAlert];
    }
    
    //初始化等待取件视图
    self.waitForCourierGetExpressView.courierDetail = courierDetail;
    
    [self.waitForCourierGetExpressView show];
    
    /** 获取快递员和用户之间距离 cour_location(用户), cour_location(快递员) */
    [self instantLocationRequest:courierDetail.courierID andStatus:YES];
    
    //关闭快递员抢单通知
    [self waitOrderRequest:NO];
}

#pragma mark - DDPrepareSendViewController Delegate
- (void)prepareSendView:(DDPrepareSendViewController *)prepareSendViewController popAnimationWithOrderId:(NSString *)orderId andOrderType:(NSInteger)flag
{

    [self.waitRusheOrderList addObject:@{orderId:@""}];
    
    [DDGlobalVariables sharedInstance].backHomeViewNeedToShowCourierDetail = NO;
    
    [self popViewWithHomePageStatus:DDHomePageWaitForRush];

}

- (void)prepareSendView:(DDPrepareSendViewController *)prepareSendViewController popWaitCourierGetWithOrderId:(NSString *)orderId
{
    DDCourierDetail *courierDetail = [[DDCourierDetail alloc] init];
    courierDetail.orderId = self.waitedCourierDetail.orderId;
    courierDetail.courierID = self.waitedCourierDetail.courierID;
    courierDetail.courierHeadIcon = self.waitedCourierDetail.courierHeadIcon;
    courierDetail.courierName = self.waitedCourierDetail.courierName;
    courierDetail.courierPhone = self.waitedCourierDetail.courierPhone;
    courierDetail.companyName = self.waitedCourierDetail.companyName;
    courierDetail.courierStar = self.waitedCourierDetail.courierStar;
    courierDetail.finishedOrderNumber = self.waitedCourierDetail.finishedOrderNumber;
    [self.waitCourierGetOrderList addObject:courierDetail];
    self.waitedCourierDetail.orderId = orderId;
}
/**
 *  开启:等待应答
 */
- (void)popWaitForRushOrderView
{
    //开启快递员抢单通知
    [self waitOrderRequest:YES];
    
    /** 隐藏等待抢单视图 */
    [self.waitForCourierGetExpressView dismissAlert];
    
    //显示等待抢单
    [self.waitCourierRushOrderView reloadCountDownView:NO];
    
    if (self.waitCourierRushOrderView.y < 0) {
        [self.waitCourierRushOrderView show];
    }
    
    if (self.isTimeOver && self.cancelStyle1View.alpha == 0) {
        [self.cancelStyle1View show];
    }
    
    [self setWaitForCourierOrRushStatus]; //设置泡泡状态
    
    /** 如果取消订单窗口浮现，同时也隐藏掉 */
    if (self.cancelStyle2View.alpha == 1.0) {
        [self.cancelStyle2View dismissAlert];
    }
    if (!self.isTimeOver && self.cancelStyle1View.alpha == 1.0) {
        [self.cancelStyle1View dismissAlert];
    }
}

- (void)addCurrentSelectedCourierAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    currentSelectedCourierAnnotation = [[DDHomeAnnotation alloc] init];
    currentSelectedCourierAnnotation.coordinate = coordinate;
    currentSelectedCourierAnnotation.courierLatitude = coordinate.latitude;
    currentSelectedCourierAnnotation.courierLongtitude = coordinate.longitude;
    
    currentSelectedCourierAnnotation.courierId = self.waitedCourierDetail.courierID;
    currentSelectedCourierAnnotation.companyId = self.waitedCourierDetail.companyId;
    
    [self.mapView addAnnotation:currentSelectedCourierAnnotation];
}

- (void)removeCurrentSelectedCourierAnnotation
{
    deselectByRemove = YES;
    [self.mapView removeAnnotation:currentSelectedCourierAnnotation];
}

- (void)addAlreadySendExpressRequestAnnotation
{
    deselectByRemove = NO;
    //添加唯一标注
    currentSendExpressAnnotation = [[DDHomeAnnotation alloc] init];
    currentSendExpressAnnotation.isSendExpressLocation = YES;
    currentSendExpressAnnotation.coordinate = [self resetCurrentSendExpressLocation];
    
    [self.mapView addAnnotation:currentSendExpressAnnotation];
    
    [self.mapView setCenterCoordinate:currentSendExpressAnnotation.coordinate animated:YES];
}

- (void)addAlreadySendExpressRequestAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    //添加唯一标注
    currentSendExpressAnnotation = [[DDHomeAnnotation alloc] init];
    currentSendExpressAnnotation.isSendExpressLocation = YES;
    currentSendExpressAnnotation.coordinate = [self resetCurrentSendExpressLocation];
    [self.mapView addAnnotation:currentSendExpressAnnotation];
    
    [self.mapView setCenterCoordinate:currentSendExpressAnnotation.coordinate animated:YES];
}

- (void)removeAlreadySendExpressRequestAnnotaiton
{
    currentSendExpressAnnotation.title = nil;
    deselectByRemove = YES;
    [self.mapView removeAnnotation:currentSendExpressAnnotation];
}

- (CLLocationCoordinate2D)resetCurrentSendExpressLocation
{
    CLLocationCoordinate2D coordinate2D = [DDCenterCoordinate getSendExpressInfoCoordinate];
    CGFloat meters = [self getMetersWithCourierLocation:coordinate2D];
    if (meters <= SenderDistanceFromMe) {
        CGPoint selfMapPoint = [self.mapView convertCoordinate:self.locService.userLocation.location.coordinate toPointToView:self.mapView];
        CGPoint newPoint = CGPointMake(selfMapPoint.x, selfMapPoint.y - 20);
        CLLocationCoordinate2D newCoordinate = [self.mapView convertPoint:newPoint toCoordinateFromView:self.mapView];
        
        return newCoordinate;
    } else {
        return coordinate2D;
    }
    
}

#pragma mark - InputAddressDelegate
///**
// *  地址回传
// *  输入地址页面的地址回传
// */
- (void)passInputAddress:(DDInputAddressController *)InputAddressController withSuggestionAddress:(DDAddressDetail *)addressDetail
{
    self.selectedAddressDetail = [[DDAddressDetail alloc]init];
    self.selectedAddressDetail = addressDetail;
}

- (void)dissMissAllPopUpViews
{
    //if (self.waitForCourierGetExpressView.isHidden == NO) {
        [self.waitForCourierGetExpressView dismissAlert];
    //}
    
    if (self.waitCourierRushOrderView.y == 0) {
        [self.waitCourierRushOrderView dismissAlert];
        self.isTimeOver = NO;
    }
    
    if (self.cancelStyle1View.alpha == 1.0) {
        [self.cancelStyle1View dismissAlert];
    }
    
    if (self.cancelStyle2View.alpha == 1.0) {
        [self.cancelStyle2View dismissAlert];
    }
    
    if (self.remindToPayView.hidden == NO) {
        self.remindToPayView.hidden = YES;
    }
    
    [self showPaoPaoBgViews];
}

#pragma mark - DDWaitForCourierViewClickDelegate
/**
 * 返回订单列表的代理
 */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickbackToOrderListBtn:(DDCourierDetail *)courierDetail
{
    [self dissMissAllPopUpViews];
    
    DDOrdersListViewController *orderListController = [[DDOrdersListViewController alloc] init];
    [self.navigationController pushViewController:orderListController animated:YES];
}

/**
 *  弹窗(确认取消)
 */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickCancelBtn:(DDCourierDetail *)courierDetail
{
    /** 取消快递员取件弹窗 (取消订单+继续等待) */
    [self.cancelStyle2View show];
}

/**
 *   进入快递员主页
 */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickCourierDetailBtn:(DDCourierDetail *)courierDetail
{
    [self dissMissAllPopUpViews];
    
    DDCourierDetailController *vc = [[DDCourierDetailController alloc] initWithCourierId:courierDetail.courierID];
    
    [DDGlobalVariables sharedInstance].backHomeViewNeedToShowCourierDetail = YES;
    
    [self.navigationController pushViewController:vc  animated:YES];
}

/** 拨打电话 */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickPhoneCallBtn:(DDCourierDetail *)courierDetail
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    if(!callWebView) {
        callWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    NSString *strTel = [NSString stringWithFormat:@"tel:%@",courierDetail.courierPhone];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strTel]]];
    [self.view addSubview:callWebView];
}

/**<  追单(参数传是否为同一个快递员)  */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickSendAgainBtn:(DDCourierDetail *)courierDetail andIsSameCourier:(BOOL)isSame
{
    if (self.waitPayOrderList.count > 0 && !isSame) {
        self.remindToPayView.hidden = NO;
        self.remindToPayView.unPayCount = -1;
        return;
    }
    
    [DDGlobalVariables sharedInstance].backHomeViewNeedToShowCourierDetail = YES;
    
    //取消等待取件视图
    [self dissMissAllPopUpViews];
    
    DDPrepareSendViewController *controller = [[DDPrepareSendViewController alloc] initWithDetailCourier:courierDetail];
    
    controller.delegate = self;
    controller.lastViewFlag = isSame ? 1 : 2;
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark - DDWaitCourierViewDelegate
/** 弹出取消订单界面 */
- (void)waitCourierRushOrderView:(DDWaitCourierRushOrderView *)waitCourierRushOrderView cancelWithTime:(BOOL)timeOver
{
    //判断是否时间结束
    self.isTimeOver = timeOver;
    
    /** 取消快递员取件弹窗 (取消订单+继续等待) */
    if (self.cancelStyle1View.alpha == 0) {
        [self.cancelStyle1View show];
    }
}

#pragma mark - DDCancelOrderViewDelegate
/** 取消订单弹窗的协议事件 */
- (void)cancelOrderView:(DDCancelOrderView *)cancelOrderView withButtonIndex:(DDCancelOrderViewButton)indexButton
{
    if (indexButton == DDCancelOrderViewButtonCancel) {
        /** 取消订单 */
        
        //关闭计时器, 删除等待抢单视图
        if (self.waitCourierRushOrderView.y == 0) {
            [self.waitCourierRushOrderView dismissAlert];
            self.isTimeOver = NO;
        }

        [self setHomePageWaitNoneStatus];
        
        //执行取消订单的服务器请求
        if (self.waitRusheOrderList.count > 0) {
            NSString *orderId = [self.waitRusheOrderList[0] allKeys][0];
            
            [self.waitRusheOrderList removeObjectAtIndex:0];
            
            [self cancelOrderRequest:orderId];
        }
        
        //关闭快递员抢单通知
        [self waitOrderRequest:false];
        
        self.homePageStatus = DDHomePageWaitNone;
        
        self.sideMenuViewController.panGestureEnabled = [DDLocalUserInfoUtils userLoggedIn];
        
        //移除定位Location
        [self removeAlreadySendExpressRequestAnnotaiton];
        
    } else if (indexButton == DDCancelOrderViewButtonContinue) {
        /** 继续等待按钮 */
        //如果时间结束了, 就重新计时
        if (self.isTimeOver == YES) {
            [self.waitCourierRushOrderView reloadCountDownView:YES];
            self.isTimeOver = NO;
        }
    } else {
        //隐藏等待快递员取件页面
        [self.waitForCourierGetExpressView dismissAlert];
        
        //显示气泡标注视图的内容
        [self showPaoPaoBgViews];
        
        //执行取消订单的服务器请求
        if (self.waitedCourierDetail != nil) {
            NSString *orderId = self.waitedCourierDetail.orderId;
            
            [self.waitCourierGetOrderList removeObject:self.waitedCourierDetail];
         
            [self cancelOrderRequest:orderId];
        }
        
        [self setHomePageWaitNoneStatus];
        
        self.homePageStatus = DDHomePageWaitNone;
        
        self.sideMenuViewController.panGestureEnabled = [DDLocalUserInfoUtils userLoggedIn];
        
        [self removeAlreadySendExpressRequestAnnotaiton];
    }
}

#pragma mark - DDRemindToPayView Delegate
/** */
- (void)remindToPayView:(DDRemindToPayView *)remindToPayView didClickPayBtn:(NSInteger)unPayCount
{
    [self dissMissAllPopUpViews];
    
    DDPayCostController * payController = [[DDPayCostController alloc] init];
    payController.delegate = self;
    payController.orderId = [self.waitPayOrderList objectAtIndex:0];
    
    [self.navigationController pushViewController:payController animated:YES];
}

#pragma mark - DDPayCostController Delegate
- (void)payCostView:(DDPayCostController *)payCostView didClickBackConfirmBtnWithOrderId:(NSString *)orderId
{
    [self.waitPayOrderList removeObject:orderId];
//    if (self.waitPayOrderList.count == 0) {
//        if (self.waitRusheOrderList.count > 0) {
//            self.homePageStatus = DDHomePageWaitForRush;
//        } else if (self.waitCourierGetOrderList.count > 0) {
//            [DDGlobalVariables sharedInstance].backHomeViewNeedToShowCourierDetail = YES;
//            self.homePageStatus = DDHomePageWaitForGetExpress;
//        }
//
//    }
    [self pretreatmentOfOrders];
}

#pragma mark - 初始化消息窗视图

- (void)onClickShowPersonalCenter:(id)sender
{
    if ([self checkWithUserLoginInfo]) {
        [self presentLeftMenuViewController:sender];
    }
    
    //    DDHomeAnnotationView *annotationView = (DDHomeAnnotationView *)[self.mapView viewForAnnotation:[self.mapView.annotations objectAtIndex:0]];
    //    [annotationView updateTransformInfoWithAnnotation:[self.mapView.annotations objectAtIndex:0] animate:YES];
}

#pragma mark - DDHomeAnnotationViewDelegate
- (void)DDHAVD_resetAnnotationWithAnnotationView:(DDHomeAnnotationView *)annotationView point:(CGPoint)point
{
   
}

#pragma mark - setter & getter
- (DDAddressDetail *)addressDetail
{
    if (_addressDetail == nil) {
        _addressDetail = [[DDAddressDetail alloc]init];
    }
    return _addressDetail;
}


- (BMKGeoCodeSearch *)searcher
{
    if (_searcher == nil) {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    return _searcher;
}

- (BMKLocationService *)locService
{
    if (_locService == nil) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        //设定定位精度
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locService;
}

- (DDRemindToPayView *)remindToPayView
{
    if (_remindToPayView == nil) {
        _remindToPayView = [[DDRemindToPayView alloc] init];
        _remindToPayView.delegate = self;
        _remindToPayView.frame = DDSCreenBounds;
        //_remindToPayView.unPayCount = self.unPayCount;
        _remindToPayView.hidden = YES;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_remindToPayView];
    }
    return _remindToPayView;
}

- (NSMutableArray *)waitPayOrderList
{
    if (_waitPayOrderList == nil) {
        _waitPayOrderList = [NSMutableArray array];
    }
    return _waitPayOrderList;
}

- (NSMutableArray *)waitCourierGetOrderList
{
    if (_waitCourierGetOrderList == nil) {
        _waitCourierGetOrderList = [NSMutableArray array];
    }
    return _waitCourierGetOrderList;
}

- (NSMutableArray *)waitRusheOrderList
{
    if (_waitRusheOrderList == nil) {
        _waitRusheOrderList = [NSMutableArray array];
    }
    return _waitRusheOrderList;
}

- (BMKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 120, MainScreenWidth, MainScreenHeight - 120)];
        _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
        [_mapView setZoomLevel:19];
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (UIImageView *)paopaoImageView
{
    if (_paopaoImageView == nil && [self isLocationEnabled:self.mapView.centerCoordinate]) {
        
        _paopaoImageView = [[UIImageView alloc] init];
        [_paopaoImageView setSize:CGSizeMake(185.5, 36.5)];
        [_paopaoImageView setCenter:CGPointMake(self.mapView.center.x, self.mapView.center.y - USER_LOCATION_RADIUS)];
        [_paopaoImageView setImage:[UIImage imageNamed:@"normal"]];
        _paopaoImageView.layer.anchorPoint = CGPointMake(0.5, 0);
        _paopaoImageView.userInteractionEnabled = YES;
        [self.view addSubview:_paopaoImageView];
        
        _paopaoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _paopaoImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _paopaoImageView.layer.shadowOpacity = 0.1;
        _paopaoImageView.layer.shadowRadius = 2;
        
        self.paopaoBgView = [[UIView alloc] init];
        self.paopaoBgView.frame = _paopaoImageView.bounds;
        [_paopaoImageView addSubview:self.paopaoBgView];
        
        //3.companyLogoBtn
        self.companyLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(_paopaoImageView.bounds) / 2 - 28 / 2, 28, 28)];
        [self.companyLogoView setImage:[UIImage imageNamed:KClientIcon48]];
        self.companyLogoView.layer.cornerRadius = 14;
        self.companyLogoView.layer.masksToBounds = YES;
        [self.paopaoBgView addSubview:self.companyLogoView];
        
        self.companyLogoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 54)];
        [self.companyLogoBtn addTarget:self action:@selector(companyChooseClick) forControlEvents:UIControlEventTouchUpInside];
        [self.paopaoBgView addSubview:self.companyLogoBtn];
        
        //4.kilometerLabelView
        self.kilometerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.companyLogoView.frame) + 2, 38 - 12, 60, 12)];
        self.kilometerLabel.font = [UIFont systemFontOfSize:14];
        self.kilometerLabel.textColor = DDRGBAColor(102, 102, 102, 1);
        [self.paopaoBgView addSubview:self.kilometerLabel];
        
        self.verticalLineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.kilometerLabel.frame) + 2, 0, 0.5, 36.5)];
        self.verticalLineView.backgroundColor = DDRGBAColor(233, 233, 233, 1);
        [self.paopaoBgView addSubview:self.verticalLineView];
        
        //5.sendExpress
        self.sentExpressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sentExpressButton setFrame:CGRectMake(CGRectGetMaxX(self.verticalLineView.frame) + 2, 0, 70, 36.5)];
        [self.sentExpressButton setTitle:@"我要寄件" forState:UIControlStateNormal];
        [self.sentExpressButton setTitleColor:DDRGBAColor(51, 51, 51, 1) forState:UIControlStateNormal];
        self.sentExpressButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.sentExpressButton addTarget:self action:@selector(sentExpressClick) forControlEvents:UIControlEventTouchUpInside];
        [self.paopaoBgView addSubview:self.sentExpressButton];
        
        //箭头图片
        self.rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(_paopaoImageView.frame.size.width-28, (36.5 - 14) / 2, 7, 14)];
        self.rightArrow.contentMode = UIViewContentModeCenter;
        self.rightArrow.image = [UIImage imageNamed:@"我要寄件"];
        [self.paopaoBgView addSubview:self.rightArrow];
        
        self.distanceUserLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 30)];
        self.distanceUserLabel.textAlignment = NSTextAlignmentCenter;
        self.distanceUserLabel.font = [UIFont systemFontOfSize:12];
        self.distanceUserLabel.layer.borderWidth = 1;
        self.distanceUserLabel.layer.borderColor = [[UIColor blackColor]CGColor];
        self.distanceUserLabel.hidden = YES;
        [_paopaoImageView addSubview:self.distanceUserLabel];
        
        self.waitCourierLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_paopaoImageView.bounds), 36.5)];
        self.waitCourierLabel.font = kTitleFont;
        self.waitCourierLabel.textColor = CONTENT_COLOR;
        self.waitCourierLabel.textAlignment = NSTextAlignmentCenter;
        self.waitCourierLabel.hidden = YES;
        [_paopaoImageView addSubview:self.waitCourierLabel];
        
        smallPaoPaoImageView = [[UIImageView alloc] initWithImage:ImageNamed(@"normal_small")];
        smallPaoPaoImageView.frame = CGRectMake(CGRectGetMinX(_paopaoImageView.frame) + CGRectGetWidth(_paopaoImageView.bounds) / 2 - 30, CGRectGetMinY(_paopaoImageView.frame) + 2.5, 30, 42);
        smallPaoPaoImageView.center = CGPointMake(self.mapView.center.x, smallPaoPaoImageView.center.y);
        [self.view addSubview:smallPaoPaoImageView];
        
        smallPaoPaoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        smallPaoPaoImageView.layer.shadowOffset = CGSizeMake(0, 0);
        smallPaoPaoImageView.layer.shadowOpacity = 0.1;
        smallPaoPaoImageView.layer.shadowRadius = 2;
        
        downwardArrowImageView = [[UIImageView alloc] initWithImage:ImageNamed(@"downwardArrow")];
        [downwardArrowImageView setFrame:CGRectMake(CGRectGetMinX(_paopaoImageView.frame) + CGRectGetWidth(_paopaoImageView.bounds) / 2 - 12.5 / 2, CGRectGetMaxY(_paopaoImageView.frame), 12.5, 8)];
        [self.view addSubview:downwardArrowImageView];
        
        for (int i = 0; i < 3; i++) {

            CGFloat circleViewSpace = 0;
            if (i == 0) {
                circleViewSpace = 3.5;
            } else if (i == 1) {
                circleViewSpace = 12.5;
            } else {
                circleViewSpace = 21.5;
            }

            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(circleViewSpace, 14, 5, 5)];
            circleView.tag = i + 100;
            [circleView setBackgroundColor:RGBCOLOR(233, 233, 233)];
            circleView.layer.cornerRadius = 2.5;
            circleView.layer.masksToBounds = YES;
            [smallPaoPaoImageView addSubview:circleView];
        }
        
        [self.view sendSubviewToBack:smallPaoPaoImageView];
        [self.view sendSubviewToBack:self.mapView];
        
        [self.view bringSubviewToFront:downwardArrowImageView];
        
        _paopaoImageView.hidden = NO;
    }
    return _paopaoImageView;
}

- (DDCancelOrderView *)cancelStyle1View
{
    if (_cancelStyle1View == nil) {
        _cancelStyle1View = [[DDCancelOrderView alloc] initWithDelegate:self withStyle:DDCancelOrderViewStyleWaitCourier];
        _cancelStyle1View.alpha = 0.0f;
    }
    return _cancelStyle1View;
}

- (DDCancelOrderView *)cancelStyle2View
{
    if (_cancelStyle2View == nil) {
        _cancelStyle2View = [[DDCancelOrderView alloc] initWithDelegate:self withStyle:DDCancelOrderViewStyleWaitExpress];
        _cancelStyle2View.alpha = 0.0f;
    }
    return _cancelStyle2View;
}

- (DDWaitCourierRushOrderView *)waitCourierRushOrderView
{
    if (_waitCourierRushOrderView == nil) {
        _waitCourierRushOrderView = [[DDWaitCourierRushOrderView alloc] initWithDelegate:self];
        //_waitCourierRushOrderView.hidden = YES;
    }
    return _waitCourierRushOrderView;
}

- (DDWaitForCourierView *)waitForCourierGetExpressView
{
    if (_waitForCourierGetExpressView == nil) {
        _waitForCourierGetExpressView = [[DDWaitForCourierView alloc] initWithDelegate:self withStyle:DDWaitForCourierViewStyleNone];
        //_waitForCourierGetExpressView.hidden = YES;
    }
    return _waitForCourierGetExpressView;
}

- (DDLoadingView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[DDLoadingView alloc] init];
    }
    return _loadingView;
}

- (void)setHomePageStatus:(DDHomePageStatusEnum)homePageStatus
{
    _homePageStatus = homePageStatus;
    
    if (self.loadingView.hidden == NO) {
        self.loadingView.hidden = YES;
    }
    
    if (self.homePageStatus == DDHomePageWaitForRush) {
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        [self removeAlreadySendExpressRequestAnnotaiton];
        [self addAlreadySendExpressRequestAnnotation];
    }


    if (![self homePageIsTheFirstPage]) {
        return;
    }

    [self popViewWithHomePageStatus:homePageStatus];

}

- (void)popViewWithHomePageStatus:(DDHomePageStatusEnum)homePageStatus
{
    switch (homePageStatus) {
        case DDHomePageWaitForRush:
            _homePageStatus = homePageStatus;
            self.sideMenuViewController.panGestureEnabled = NO;
            [self popWaitForRushOrderView];
            break;
        case DDHomePageWaitForGetExpress:
            if (self.waitedCourierDetail != nil) {
                self.sideMenuViewController.panGestureEnabled = NO;
                [self popWaitForCourierToGetExpressView:self.waitedCourierDetail];
            }
            break;
        case DDHomePageWaitForPay:
            self.sideMenuViewController.panGestureEnabled = NO;
            [self dissMissAllPopUpViews];
            
            [self setWaitPayStatus];
            
            self.remindToPayView.unPayCount = self.waitPayOrderList.count;
            self.remindToPayView.hidden = NO;
            
            break;
        default:
            break;
    }
}

- (UIButton *)toSelfLocation
{
    if (_toSelfLocation == nil) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"gps"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(4, self.mapView.height - 57, 54, 54)];
        btn.contentMode = UIViewContentModeScaleAspectFill;
        [self.mapView addSubview:btn];
        _toSelfLocation = btn;
    }
    return _toSelfLocation;
}

- (NSMutableArray *)companyId
{
    if (_companyId == nil) {
        _companyId = [NSMutableArray array];
    }
    return _companyId;
}

#pragma mark - DDCourierCompanyViewDelegate
- (void)setCouriercompany:(NSMutableArray *)array withLimit:(BOOL)limitFlag
{
    [self.companyId removeAllObjects];
    [companyArray removeAllObjects];
    if (!limitFlag) {
        for (DDCompanyModel *model in array) {
            if (![CustomStringUtils isBlankString:model.companyID]) {
                [self.companyId addObject:model.companyID];
                [companyArray addObject:model];
            }
        }
    }
    
    [self getCourierLocation:self.mapView.centerCoordinate.latitude longi:self.mapView.centerCoordinate.longitude];
}

#pragma mark RESideMenuDelegate
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    if (regionWillChangeEnable) {
        regionWillChangeEnable = NO;
        
        [self removeSmallPaoPaoAnimation];
        
        [self updatePaoPaoBgViewHidden:NO];
        
        [DDCenterCoordinate setCenterCoordinate:self.mapView.centerCoordinate];
        [DDCenterCoordinate setUserLocation:self.locService.userLocation.location.coordinate];
        
        self.isMapChanged = YES;
        [self beginReverseGeoCodeSearch];
        [self getCourierLocation:self.mapView.centerCoordinate.latitude longi:self.mapView.centerCoordinate.longitude];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (BOOL)isLocationEnabled:(CLLocationCoordinate2D)coordinate2D
{
    if (coordinate2D.latitude > 0 && coordinate2D.longitude > 0) {
        return YES;
    } else {
        return NO;
    }
}

@end




