//
//  DDMyExpressListController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

/**
    我的快递列表
 */


typedef enum {
    DDMyExpressListStatusAll = 0,           /** 全部  */
    DDMyExpressListStatusSignFor = 1,       /** 已揽收 */
    DDMyExpressListStatusShippedBy = 2,     /** 已发货 */
    DDMyExpressListStatusFinish = 3,        /** 已签收 */
} DDMyExpressListStatus;                    /** 快递状态（0全部 1已揽收 2已发货 3已签收 不传代表全部） */

#define KMyExpressCheck 7777
#define KMyExpressItem 8888

#define KNotResult_SendText [NSString stringWithFormat:@"您还没%@寄出快递呢\n赶快寄个快递体验下吧！",DDDispalyName]
#define KNotResult_GetText [NSString stringWithFormat:@"你暂时没有待收取的快递\n赶紧号召亲朋们%@给你寄快递吧",DDDispalyName]

#import "DDMyExpressListController.h"
#import "DDMyExpressDetailViewController.h"
#import "DDCourierQueryViewController.h"

#import "DDPinwheelTableVeiw.h"
#import "DDMyExpress.h"
#import "YYModel.h"
#import "MJRefresh.h"
#import "BaseNavController.h"
#import "DDGlobalVariables.h"

#import "DDWebViewController.h"
#import "NSObject+CustomCategory.h"

@interface DDMyExpressListController ()<DDInterfaceDelegate, DDPinwheelTableVeiwDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

/** 存储UIButton对象 */
@property (nonatomic, strong) NSMutableArray *buttonNavs;
@property (nonatomic, strong) NSMutableArray *buttons;

/** 根据BOOL值判断"寄出"和"收取" ,self.parcelStatus＝true／寄出*/
@property (nonatomic, assign) BOOL parcelStatus;
/** @"全部",@"已揽收",@"已发货",@"已签收" */
@property (nonatomic, assign) DDMyExpressListStatus expressStatus;
/** 页码 */
@property (nonatomic,assign) NSInteger pageIndex;
/** 总的条数*/
@property (nonatomic,assign) NSInteger totalCouont;

/** @"全部",@"已签收",@"已发货",@"已揽收",Button对象的父类 */
@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) NSArray *arrayTitle;

/** 顶部分类选择的着重线条 */
@property (nonatomic, strong) UIImageView *lineView;

/** 作为本界面的数据显示表格，用户显示查询出来的所有快递信息 */
@property (nonatomic, strong) DDPinwheelTableVeiw *pinwheelTableVeiw;
/** 表格视图显示的状态 */
@property (nonatomic, assign) DDPinwheelViewStyle pinwheelViewStyle;
/** 作为本界面的数据*/
@property (nonatomic, strong) NSMutableDictionary *dictionaryParcel;

/** TitleView"寄出"和"收取"两个UIButton */
@property (nonatomic, strong) UIButton *btnNavLeft;
@property (nonatomic, strong) UIButton *btnNavRight;

/** 网络请求 */
@property (nonatomic, strong) DDInterface *interfaceMyExpress;

@end

@implementation DDMyExpressListController

#pragma mark - 初始化生成临时数据
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:nil segmentArray:@[@"寄出", @"收取"]];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    [self adaptFirstRightItemWithTitle:@"查快递"];
    
    //创建一个UIView对象－viewTop，并添加按钮
    [self ddCreateForViewTop];
    
    self.pageIndex = 1;
    [self updateSegmentControlWithIndex:0];
    
    [self myParcelsWithRequest];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self disableBackGesture];
    
    if ([DDGlobalVariables sharedInstance].toExpressComment) {
        [DDGlobalVariables sharedInstance].toExpressComment = false;
        //刷新数据
        [self headerRefreshWithPinwheelTableView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self enableBackGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /** 判断列表是否有数据 */
    [self.pinwheelTableVeiw setSelectPinwheelView:self.expressStatus];
}

#pragma mark - 类的对象方法:初始化页面
/** 创建一个UIView对象－viewTop，并添加按钮，作为导航栏下的按钮选项的父视图 */
- (void)ddCreateForViewTop
{
    UIView *viewTop = [[UIView alloc] init];
    [viewTop setFrame:CGRectMake(0, KNavHeight, self.view.width, 44.0f)];
    [viewTop setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewTop];
    self.viewTop = viewTop;
    
    //循环创建按钮，以Tag值来判断事件的响应
    CGFloat button_w = floorf(viewTop.width/4.0f);
    for (NSInteger i=0; i<self.arrayTitle.count; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(button_w*i, 0, MAX(button_w, self.viewTop.width - button_w*3.0f), self.viewTop.height)];
        [itemButton setBackgroundColor:[UIColor clearColor]];
        [itemButton.titleLabel setFont:kTitleFont];
        [itemButton setTitleColor:CONTENT_COLOR forState:UIControlStateNormal];
        [itemButton setTitleColor:DDGreen_Color forState:UIControlStateSelected];
        [itemButton setTitle:self.arrayTitle[i] forState:UIControlStateNormal];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [itemButton setTag:KMyExpressItem+i];
        [itemButton setSelected:i==0 ? true : false];
        [viewTop addSubview:itemButton];
        [self.buttons addObject:itemButton];
    }
    //设置viewTop底部的分界线
    UIImageView *bottomView = [[UIImageView alloc] init];
    [bottomView setFrame:CGRectMake(0, viewTop.height - 0.5f, viewTop.width, 0.5f)];
    [bottomView setBackgroundColor:BORDER_COLOR];
    [viewTop addSubview:bottomView];
    
    //设置中间的分界线
    UIImageView *lineView = [[UIImageView alloc] init];
    [lineView setFrame:CGRectMake(0, viewTop.height - 2.0f, floorf(viewTop.width/4.0f), 2.0f)];
    [lineView setBackgroundColor:DDGreen_Color];
    [viewTop addSubview:lineView];
    self.lineView = lineView;
    
    //创建一个UITableView对象－parcelTableView，作为本界面的数据显示表格，用户显示查询出来的所有快递信息
    [self ddCreateForTableView];
    
}

/**
    创建一个UITableView对象－parcelTableView，作为本界面的数据显示表格，用户显示查询出来的所有快递信息
 */
- (void)ddCreateForTableView
{
    DDPinwheelTableVeiw *pinwheelTableVeiw = [[DDPinwheelTableVeiw alloc] initWithFrame:CGRectMake(0, self.viewTop.bottom, self.view.width, MainScreenHeight - self.viewTop.bottom)];
    [pinwheelTableVeiw setBackgroundColor:[UIColor whiteColor]];
    [pinwheelTableVeiw setPinwheelDelegate:self];
    [self.view addSubview:pinwheelTableVeiw];
    self.pinwheelTableVeiw = pinwheelTableVeiw;
    [self.pinwheelTableVeiw setContentNumber:self.buttons.count];
    
    self.parcelStatus = YES;
    [self ddCreateForNotResultView];
}

//用于没有数据时，对用户进行提示的默认视图
- (void)ddCreateForNotResultView
{
    NSString *imgStatu = self.parcelStatus ? DDMyExpressListBG_Send : DDMyExpressListBG_Change;
    NSString *str_Msg  = self.parcelStatus ? KNotResult_SendText : KNotResult_GetText;
    NSString *strTitle = self.parcelStatus ? @"立即寄件" : @"马上告诉好友" ;
    [self.pinwheelTableVeiw resultWithImage:imgStatu withContent:str_Msg withButtonTitle:strTitle];
}

#pragma mark - 类的对象方法:点击事件监听
/** 包裹列表类型，比如：@"全部",@"已签收",@"已发货",@"已揽收", */
- (void)onClickWithItem:(UIButton *)sender
{
    self.expressStatus = (DDMyExpressListStatus)[self.buttons indexOfObject:sender];
    
    if (!sender.selected) {
        [self.pinwheelTableVeiw setContentNumber:self.buttons.count];
        [self.pinwheelTableVeiw setSelectPinwheelView:self.expressStatus];
        [self clickWithTopItemButton:sender];
        
        [self myParcelsWithRequest];
    }
}

/** 刷新ViewTop选项卡 */
- (void)clickWithTopItemButton:(UIButton *)sender
{
    [UIView animateWithDuration:0.25f animations:^{
        [self.lineView setFrame:CGRectMake(sender.left, self.lineView.top, sender.width, self.lineView.height)];
    }];
    for (UIButton *button in self.buttons) {
        [button setSelected:button.tag==sender.tag ? true : false];
    }
}

- (NSString *)getSignatureForMd5
{
    NSString *key = [NSString stringWithFormat:@"%@%@1a@$3321ooobbA#bbbbbbbb2@@@@@@@%%%%%%",[LocalUserInfo objectForKey:@"userId"],[LocalUserInfo objectForKey:@"phone"]];
    return [key MD5];
}

#pragma mark - DDPinwheelTableVeiwDelegate
/** 回调当前应显示的视图状态 */
- (void)pinwheelTableVeiw:(DDPinwheelTableVeiw *)ddPinwheelTableVeiw withPinwheelIndex:(NSInteger)pinwheelIndex withStyle:(DDPinwheelViewStyle)pinwheelViewStyle withIndexPath:(NSIndexPath *)indexPath
{
    self.pinwheelViewStyle = pinwheelViewStyle;
    if (self.arrayTitle.count > pinwheelIndex) {
        NSMutableDictionary *itemValue = [self getItemValue:pinwheelIndex];
        NSArray *arrayList = [itemValue objectForKey:[self getListKey:self.parcelStatus]];
        
        DDMyExpressDetailViewController *detailControl = [[DDMyExpressDetailViewController alloc] initWithModel:arrayList[indexPath.row]];
        [self.navigationController pushViewController:detailControl animated:true];
    }
}

/** 根据显示到第几项 返回当前表格数组 */
- (NSArray *)pinwheelTableVeiw:(DDPinwheelTableVeiw *)ddPinwheelTableVeiw withPinwheelIndex:(NSInteger)pinwheelIndex
{
    NSArray *arrayList = [NSArray array];
    if (self.arrayTitle.count > pinwheelIndex) {
        NSMutableDictionary *itemValue = [self getItemValue:pinwheelIndex];
        
        arrayList = [itemValue objectForKey:[self getListKey:self.parcelStatus]];
    }
    return arrayList;
}

/** 上拉加载 */
- (void)foorterRefreshWithPinwheelTableView
{
    NSMutableDictionary *dictionaryValue = [self getItemValue:self.expressStatus];
    NSInteger pageIndex = [[dictionaryValue objectForKey:[self getPageKey:self.parcelStatus]] integerValue];
    pageIndex += 1;
    
    [dictionaryValue setValue:@(pageIndex) forKey:[self getPageKey:self.parcelStatus]];
    [self setItemValue:dictionaryValue forKey:self.expressStatus];
    
    [self myParcelsWithRequest];
}

/** 下啦刷新 */
-  (void)headerRefreshWithPinwheelTableView
{
    NSMutableDictionary *dictionaryValue = [self getItemValue:self.expressStatus];
    NSInteger      pageIndex     = [[dictionaryValue objectForKey:[self getPageKey:self.parcelStatus]] integerValue];
    NSMutableArray *arrayContent = [dictionaryValue objectForKey:[self getListKey:self.parcelStatus]];
    pageIndex = 1;
    [arrayContent removeAllObjects];
    
    [dictionaryValue setValue:arrayContent forKey:[self getListKey:self.parcelStatus]];
    [dictionaryValue setValue:@(pageIndex) forKey:[self getPageKey:self.parcelStatus]];
    [self setItemValue:dictionaryValue forKey:self.expressStatus];
    
    [self myParcelsWithRequest];
}

/** 显示到第几项 */
- (void)selectPinwheelWithPinwheelIndex:(NSInteger)pinwheelIndex withStyle:(DDPinwheelViewStyle)pinwheelViewStyle
{
    self.pinwheelViewStyle = pinwheelViewStyle;
    if (self.expressStatus != (DDMyExpressListStatus)pinwheelIndex) {
        self.expressStatus = (DDMyExpressListStatus)pinwheelIndex;
        UIButton *sender = [self.buttons objectAtIndex:pinwheelIndex];
        [self clickWithTopItemButton:sender];

        [self myParcelsWithRequest];
    }
}

/** 数据为空时，提示按钮对应的事件 */
- (void)notResultViewWithPinwheelIndex:(NSInteger)pinwheelIndex withStyle:(DDPinwheelViewStyle)pinwheelViewStyle
{
    //立即寄件
    if (self.parcelStatus) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        //马上告诉好友
        if (!self.parcelStatus) {
            DDWebViewController *viewController = [[DDWebViewController alloc] init];
            viewController.URLString = [NSString stringWithFormat:@"%@signature=%@&registerAward.shareuserid=%@", PopularizeHtmlUrlStr, [self getSignatureForMd5],[LocalUserInfo objectForKey:@"userId"]];
            ((DDWebViewController *)viewController).navTitle = @"推荐有奖";
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - Event Method
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickFirstRightItem
{
    DDCourierQueryViewController *courierQueryControl = [[DDCourierQueryViewController alloc] init];
    [self.navigationController pushViewController:courierQueryControl animated:true];
}

- (void)onClickSegment:(UISegmentedControl *)segmentControl
{
    self.parcelStatus = segmentControl.selectedSegmentIndex == 0 ? YES : NO;
    
    [self ddCreateForNotResultView];
    [self myParcelsWithRequest];
}

/** 没有数据时，下一步操作的按钮对于的响应事件 */
- (void)onClickWithNext
{
    //立即寄件
    if (self.parcelStatus) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        //马上告诉好友
        if (!self.parcelStatus) {
            DDWebViewController *viewController = [[DDWebViewController alloc] init];
            viewController.URLString = [NSString stringWithFormat:@"%@signature=%@&registerAward.shareuserid=%@", PopularizeHtmlUrlStr, [self getSignatureForMd5],[LocalUserInfo objectForKey:@"userId"]];
            ((DDWebViewController *)viewController).navTitle = @"推荐有奖";
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - Setter && Getter
- (NSMutableArray *)buttons
{
    if (_buttons == Nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableArray *)buttonNavs
{
    if (_buttonNavs == Nil) {
        _buttonNavs = [NSMutableArray array];
    }
    return _buttonNavs;
}

- (NSMutableDictionary *)dictionaryParcel
{
    if (!_dictionaryParcel) {
        _dictionaryParcel = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (NSString *item in self.arrayTitle)
        {
            NSMutableDictionary *itemValue = [NSMutableDictionary dictionary];
            
            [itemValue setValue:[NSMutableArray array] forKey:@"arraySend"];
            [itemValue setValue:@"1" forKey:@"pageSend"];
            
            [itemValue setValue:[NSMutableArray array] forKey:@"arrayGet"];
            [itemValue setValue:@"1" forKey:@"pageGet"];
            [_dictionaryParcel setValue:itemValue forKey:item];
        }
    }
    return _dictionaryParcel;
}

- (NSArray *)arrayTitle
{
    if (!_arrayTitle) {
        _arrayTitle = [NSArray arrayWithObjects:@"全部",@"已揽收",@"已发货",@"已签收", nil];
    }
    return _arrayTitle;
}

/** 传入寄出和收取对象，返回指定的 页码 的key */
- (NSString *)getPageKey:(BOOL)statu
{
    return statu ? @"pageSend" : @"pageGet";
}

/** 传入寄出和收取对象，返回指定的 数组 的key */
- (NSString *)getListKey:(BOOL)statu
{
    return statu ? @"arraySend" : @"arrayGet";
}

/** 根据传入的包裹类型枚举@"全部",@"已发货",@"已揽收",@"已签收", 获取制定的数据 */
- (NSMutableDictionary *)getItemValue:(NSInteger)statu
{
    NSString *object_key = [self.arrayTitle objectAtIndex:statu];
    NSMutableDictionary *itemValue = [[self.dictionaryParcel objectForKey:object_key] mutableCopy];
    return itemValue;
}

/** 根据传入的key存储数据 */
- (void)setItemValue:(NSMutableDictionary *)value forKey:(DDMyExpressListStatus)statu
{
    if (!value) {
        return;
    }
    NSString *object_key = [self.arrayTitle objectAtIndex:statu];
    [self.dictionaryParcel setValue:value forKey:object_key];
}

#pragma mark - Network Request
- (void)myParcelsWithRequest
{
    NSMutableDictionary *dictionaryValue = [self getItemValue:self.expressStatus];
    self.pageIndex = [[dictionaryValue objectForKey:[self getPageKey:self.parcelStatus]] integerValue];
    NSMutableArray *arrayContent = [[dictionaryValue objectForKey:[self getListKey:self.parcelStatus]] mutableCopy];
    
    if (self.pageIndex == 1 && arrayContent.count > 0) {
        [self.pinwheelTableVeiw setSelectPinwheelView:self.expressStatus];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.expressStatus != DDMyExpressListStatusAll) {
        [param setValue:@(self.expressStatus) forKey:@"status"];
    }
    [param setValue:self.parcelStatus ? @"1" : @"2" forKey:@"orderType"];
    [param setValue:@(self.pageIndex) forKey:@"page"];
    
    if (!self.interfaceMyExpress) {
        self.interfaceMyExpress = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceMyExpress interfaceWithType:INTERFACE_TYPE_PACKAGE_LIST param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceMyExpress) {
        [self.pinwheelTableVeiw endRefreshingPinwheel];
        if (error || !DDInterfaceSuccess) {
            [MBProgressHUD showError:error.domain];
        } else {
            NSMutableDictionary *itemValue = [self getItemValue:self.expressStatus];
            NSMutableArray *arrayContent = [[itemValue objectForKey:[self getListKey:self.parcelStatus]] mutableCopy];
            
            if (!arrayContent) {
                arrayContent = [[NSMutableArray alloc] initWithCapacity:0];
            }
            if (self.pageIndex == 1) {
                [arrayContent removeAllObjects];
            }
            for (NSDictionary *item in result[@"orderList"]) {
                DDMyExpress *model = [DDMyExpress yy_modelWithDictionary:item];
                
                model.companyLogo = [DDInterfaceTool logoWithCompanyId:model.companyId];
                model.expressStatus = model.expressStatus ?: -1;
                model.expressType = model.expressType ?: (self.parcelStatus ? 1 : 2);
                [arrayContent addObject:model];
            }
            [itemValue setValue:arrayContent forKey:[self getListKey:self.parcelStatus]];
            [itemValue setValue:@(self.pageIndex) forKey:[self getPageKey:self.parcelStatus]];
            [self setItemValue:itemValue forKey:self.expressStatus];
            
            [self.pinwheelTableVeiw setSelectPinwheelView:self.expressStatus];
        }
    }
}

@end
