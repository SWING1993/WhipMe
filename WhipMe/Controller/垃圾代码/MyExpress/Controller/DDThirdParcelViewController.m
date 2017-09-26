//
//  ThirdParcelViewController.m
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

typedef enum {
    DDThirdParcelViewStatusAll = 0,           /** 全部  */
    DDThirdParcelViewStatusFinish = 1,        /** 已签收 */
    DDThirdParcelViewStatusShippedBy = 2,     /** 已发货 */
    DDThirdParcelViewStatusSignFor = 3        /** 已揽收 */
} DDThirdParcelViewStatus;                    /** 快递状态（1已揽收 2已发货 3已签收 不传代表全部） */

/**
    导入的第三方的快递列表视图
 */

#define KThirdParcelTag 7777

#define KThirdNotResult_Text (@"还没有您的快递记录")
#define KThird_List (@"array")
#define KThird_Page (@"page")

#import "DDThirdParcelViewController.h" 
#import "DDCQDetailViewController.h"
#import "DDZbarViewController.h"

#import "DDPinwheelTableVeiw.h"
#import "DDMyExpress.h"
#import "DDMoreAlertView.h"
#import "YYModel.h"

@interface DDThirdParcelViewController () <DDPinwheelTableVeiwDelegate, DDMoreAlertViewDelegate, DDInterfaceDelegate>

@property (nonatomic, strong) NSMutableArray *buttons;                                                                  /** 存储UIButton对象 */
@property (nonatomic, strong) UIView *viewTop;                                                                          /** @"全部",@"已签收",@"已发货",@"已揽收",view */
@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) NSMutableArray *moreArrayTitle;                                                           /** 消息选择窗 title */

@property (nonatomic, assign) DDThirdParcelViewStatus expressStatus;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) DDMoreAlertView *moreView;                                                                /** 消息选择窗 */

@property (nonatomic, strong) DDPinwheelTableVeiw *pinwheelTableVeiw;                                                   /** 作为本界面的数据显示表格，用户显示查询出来的所有快递信息 */
@property (nonatomic, assign) DDPinwheelViewStyle pinwheelViewStyle;                                                    /** DDPinwheelTableVeiw视图显示的状态 */
@property (nonatomic, strong) NSMutableDictionary *dictionaryParcel;                                                    /** 作为本界面的表格数据数组 */
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger totalCouont;

@property (nonatomic, strong) DDInterface *interfaceMyExpress;                                                          /** 网络请求 */

@end

@implementation DDThirdParcelViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"快递列表" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
//    [self adaptFirstRightItemWithNormalImage:ImageNamed(DDCourierList_Import) highlightedImage:ImageNamed(DDCourierList_Import)];
    
    [self ddCreateForViewTop];
    
    [self expressListWithRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self disableBackGesture];
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

#pragma mark - 类的对象方法:点击事件监听
/** 创建一个viewTop */
- (void)ddCreateForViewTop
{
    [self.view addSubview:self.viewTop];
    
    //循环创建按钮，以Tag值来判断事件的响应
    CGFloat button_w = floorf(self.viewTop.width/4.0f);
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
        [itemButton setTag:KThirdParcelTag+i];
        [itemButton setSelected:i==0 ? true : false];
        [self.viewTop addSubview:itemButton];
        [self.buttons addObject:itemButton];
    }
    //设置viewTop底部的分界线
    UIImageView *bottomView = [[UIImageView alloc] init];
    [bottomView setFrame:CGRectMake(0, self.viewTop.height - 0.5f, self.viewTop.width, 0.5f)];
    [bottomView setBackgroundColor:BORDER_COLOR];
    [self.viewTop addSubview:bottomView];
    
    //设置中间的分界线
    UIImageView *lineView = [[UIImageView alloc] init];
    [lineView setFrame:CGRectMake(0, self.viewTop.height - 2.0f, floorf(self.viewTop.width/4.0f), 2.0f)];
    [lineView setBackgroundColor:DDGreen_Color];
    [self.viewTop addSubview:lineView];
    self.lineView = lineView;
    
    [self.view addSubview:self.pinwheelTableVeiw];
}

#pragma mark - 类的对象方法:点击事件监听
/** 消息选择窗，比如：@"扫描输入",@"京东订单",@"苏宁易购",@"淘宝订单", */
- (void)onClickFirstRightItem
{
    [self.moreView show];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 快递类型，比如：@"全部",@"已签收",@"已发货",@"已揽收", */
- (void)onClickWithItem:(UIButton *)sender
{
    self.expressStatus = (DDThirdParcelViewStatus)[self.buttons indexOfObject:sender];
    
    if (!sender.selected) {
        [self expressListWithRequest];
        
        [self.pinwheelTableVeiw setContentNumber:self.buttons.count];
        [self.pinwheelTableVeiw setSelectPinwheelView:self.expressStatus];
        
        [self clickWithTopItemButton:sender];
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


#pragma mark - kMoreAlertViewDelegate
- (void)ddMoreAlertView:(DDMoreAlertView *)moreView AtIndex:(NSInteger)index
{
    if (index == 0) {
        DDZbarViewController *controller = [[DDZbarViewController alloc] init];
        [self.navigationController pushViewController:controller animated:true];
    }
}

#pragma mark - DDPinwheelTableVeiwDelegate
/** 回调当前应显示的视图状态 */
- (void)pinwheelTableVeiw:(DDPinwheelTableVeiw *)ddPinwheelTableVeiw withPinwheelIndex:(NSInteger)pinwheelIndex withStyle:(DDPinwheelViewStyle)pinwheelViewStyle withIndexPath:(NSIndexPath *)indexPath
{
    self.pinwheelViewStyle = pinwheelViewStyle;
    if (self.arrayTitle.count > pinwheelIndex)
    {
        /** 获取数组 */
        NSMutableDictionary *itemValue = [self.dictionaryParcel objectForKey:self.arrayTitle[pinwheelIndex]];
        NSArray *arrayList = [itemValue objectForKey:KThird_List];
        
        DDMyExpress *model = [arrayList objectAtIndex:indexPath.row];
        
        //进入快递信息详情界面
        DDCQDetailViewController *detailControl = [[DDCQDetailViewController alloc] initWithModel:model withStyle:DDCQDetailViewStyleList];
        [self.navigationController pushViewController:detailControl animated:true];
    }
}

- (NSArray *)pinwheelTableVeiw:(DDPinwheelTableVeiw *)ddPinwheelTableVeiw withPinwheelIndex:(NSInteger)pinwheelIndex
{
    NSArray *arrayList = [NSArray array];
    if (self.arrayTitle.count > pinwheelIndex) {
        NSMutableDictionary *itemValue = [self.dictionaryParcel objectForKey:self.arrayTitle[pinwheelIndex]];
        arrayList = [itemValue objectForKey:KThird_List];
    }
    return arrayList;
}

- (void)selectPinwheelWithPinwheelIndex:(NSInteger)pinwheelIndex withStyle:(DDPinwheelViewStyle)pinwheelViewStyle
{
    self.pinwheelViewStyle = pinwheelViewStyle;
    if (self.expressStatus != (DDThirdParcelViewStatus)pinwheelIndex) {
        self.expressStatus = (DDThirdParcelViewStatus)pinwheelIndex;
        
        /** 刷新ViewTop选项卡 */
        UIButton *sender = [self.buttons objectAtIndex:pinwheelIndex];
        [self clickWithTopItemButton:sender];
        
        /** 请求网络数据 */
        [self expressListWithRequest];
    }
}

/** 上拉加载 */
- (void)foorterRefreshWithPinwheelTableView
{
    NSMutableDictionary *dictionaryValue = [self.dictionaryParcel objectForKey:self.arrayTitle[self.expressStatus]];
    NSInteger pageIndex = [[dictionaryValue objectForKey:KThird_Page] integerValue];
    pageIndex += 1;
    
    [dictionaryValue setValue:@(pageIndex) forKey:KThird_Page];
    [self.dictionaryParcel setValue:dictionaryValue forKey:self.arrayTitle[self.expressStatus]];
    
    [self expressListWithRequest];
}

/** 下啦刷新 */
-  (void)headerRefreshWithPinwheelTableView
{
    NSMutableDictionary *dictionaryValue = [self.dictionaryParcel objectForKey:self.arrayTitle[self.expressStatus]];
    NSInteger pageIndex = [[dictionaryValue objectForKey:KThird_Page] integerValue];
    NSMutableArray *arrayContent = [[dictionaryValue objectForKey:KThird_List] mutableCopy];
    pageIndex = 1;
    [arrayContent removeAllObjects];
    
    [dictionaryValue setValue:arrayContent forKey:KThird_List];
    [dictionaryValue setValue:@(pageIndex) forKey:KThird_Page];
    [self.dictionaryParcel setValue:dictionaryValue forKey:self.arrayTitle[self.expressStatus]];
    
    [self expressListWithRequest];
}

#pragma mark - Network Request
/** 快递列表数据请求 */
- (void)expressListWithRequest
{
    NSMutableDictionary *itemValue = [self.dictionaryParcel objectForKey:self.arrayTitle[self.expressStatus]];
    self.pageIndex = [[itemValue objectForKey:KThird_Page] integerValue];
    NSMutableArray *arrayContent = [[itemValue objectForKey:KThird_List] mutableCopy];
    
    if (self.pageIndex == 1 && arrayContent.count > 0) {
        [self.pinwheelTableVeiw setSelectPinwheelView:self.expressStatus];
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (self.expressStatus != DDThirdParcelViewStatusAll) {
        [param setValue:@(self.expressStatus) forKey:@"status"];
    }
    [param setValue:@(self.pageIndex) forKey:@"page"];
    
    if (!self.interfaceMyExpress) {
        self.interfaceMyExpress = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceMyExpress interfaceWithType:INTERFACE_TYPE_EXPRESS_LIST param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceMyExpress) {
        [self.pinwheelTableVeiw endRefreshingPinwheel];
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            /** 根据传入的枚举, 获取制定的数据 */
            NSString *obj_key = self.arrayTitle[self.expressStatus];
            NSMutableDictionary *itemValue = [self.dictionaryParcel objectForKey:obj_key];
            /** 获取数组 */
            NSMutableArray *arrayContent = [[itemValue objectForKey:KThird_List] mutableCopy];
            
            if (!arrayContent) {
                arrayContent = [[NSMutableArray alloc] initWithCapacity:0];
            }
            if (self.pageIndex == 1) {
                [arrayContent removeAllObjects];
            }
            
            for (NSDictionary *item in result[@"expList"]) {
                DDMyExpress *model = [DDMyExpress yy_modelWithDictionary:item];
                model.companyLogo = [DDInterfaceTool logoWithCompanyId:model.companyId];
                model.expressStatus = model.expressStatus ?: -1;
                model.expressType   = 0;
                
                [arrayContent addObject:model];
            }
            [itemValue setValue:arrayContent forKey:KThird_List];
            [self.dictionaryParcel setValue:itemValue forKey:obj_key];
            
            [self.pinwheelTableVeiw setSelectPinwheelView:self.expressStatus];
        }
    }
}


#pragma mark - Setter && Getter
- (NSInteger)pageIndex
{
    if (_pageIndex < 1) {
        _pageIndex = 1;
    }
    return _pageIndex;
}

- (NSMutableArray *)buttons
{
    if (_buttons == Nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSMutableDictionary *)dictionaryParcel
{
    if (!_dictionaryParcel) {
        _dictionaryParcel = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (NSString *item in self.arrayTitle) {
            NSMutableDictionary *itemValue = [NSMutableDictionary dictionary];
            [itemValue setValue:[NSMutableArray array] forKey:KThird_List];
            [itemValue setValue:@"1" forKey:KThird_Page];
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

- (NSMutableArray *)moreArrayTitle
{
    if (!_moreArrayTitle) {
        _moreArrayTitle = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSMutableArray *arrayAddTitle = [NSMutableArray arrayWithObjects:@"扫描输入",@"京东订单",@"苏宁易购",@"淘宝订单", nil];
        NSMutableArray *arrayIcon = [NSMutableArray arrayWithObjects:DDCouricerQuery_CodeWhite, DDCourierList_JDIcon, DDCourierList_SuIcon, DDCourierList_Taobao, nil];
        for (NSInteger i=0; i<arrayAddTitle.count; i++)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict setValue:arrayAddTitle[i] forKey:@"title"];
            [dict setValue:arrayIcon[i] forKey:@"imageIcon"];
            [_moreArrayTitle addObject:dict];
        }
    }
    return _moreArrayTitle;
}

- (DDMoreAlertView *)moreView
{
    if (!_moreView) {
        _moreView = [[DDMoreAlertView alloc] initWithImageArray:self.moreArrayTitle delegate:self top:KNavHeight center:5.0f];
    }
    return _moreView;
}

- (UIView *)viewTop
{
    if (_viewTop == nil) {
        UIView *viewTop = [[UIView alloc] init];
        [viewTop setFrame:CGRectMake(0, KNavHeight, self.view.width, 44.0f)];
        [viewTop setBackgroundColor:[UIColor whiteColor]];
        _viewTop = viewTop;
    }
    return _viewTop;
}


- (DDPinwheelTableVeiw *)pinwheelTableVeiw
{
    if (_pinwheelTableVeiw == nil) {
        DDPinwheelTableVeiw *pinwheelTableVeiw = [[DDPinwheelTableVeiw alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.viewTop.frame), self.view.width, MainScreenHeight - CGRectGetMaxY(self.viewTop.frame))];
        [pinwheelTableVeiw setBackgroundColor:KBackground_COLOR];
        [pinwheelTableVeiw setPinwheelDelegate:self];
        [pinwheelTableVeiw setContentNumber:self.buttons.count];
        [pinwheelTableVeiw resultWithImage:DDNoCourierList_Icon withContent:KThirdNotResult_Text withButtonTitle:nil];
        _pinwheelTableVeiw = pinwheelTableVeiw;
    }
    return _pinwheelTableVeiw;
}


@end
