//
//  DDOrdersListViewController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//



#define KOrdersListItem 7777

#import "DDOrdersListViewController.h"
#import "Constant.h"
#import "DDOrderListCell.h"
#import "DDOrderList.h"
#import "DDOrderDetail.h"
#import "DDOrderDetailController.h"
#import "DDInterface.h"
#import "MJRefresh.h"
#import "DDPayCostController.h"
#import "DDHomeController.h"
#import "YYModel.h"
#import "DDCourierDetail.h"
#import "DDGlobalVariables.h"
#import "UITableView+DefaultPage.h"
#import "DDInterfaceTool.h"


@interface DDOrdersListViewController () <UITableViewDataSource,UITableViewDelegate,DDInterfaceDelegate, DDPayCostDelegat>
{
    /** 页码 */
    NSInteger _pageIndexAll;
    NSInteger _pageIndexWait;
    NSInteger _pageIndexNoPay;
    NSInteger _pageIndexAchieve;
    
    /** 临时的Cell下标 */
    NSIndexPath *_deleteIndexPath;
    /** 存储UIButton对象 */
    NSMutableArray *buttons;
}

/** 用于存储TitleView选择的数组 */
@property (nonatomic, strong) NSMutableArray *arrayNavTitle;
/** TitleView的赋值对象 */
@property (nonatomic, strong) UIButton *btnNavTitle;
/**  背景的滚动视图  */
@property (nonatomic, strong) UIView *tablesBackView;
/** 表视图对象 */
@property (nonatomic, strong) UITableView *tableViewAll;
/** 表视图对象 */
@property (nonatomic, strong) UITableView *tableViewWait;
/** 表视图对象 */
@property (nonatomic, strong) UITableView *tableViewNoPay;
/** 表视图对象 */
@property (nonatomic, strong) UITableView *tableViewAchieve;

/** 按钮条的背景视图 */
@property (nonatomic, strong) UIView *buttonBackView;

@property (nonatomic, strong) NSMutableArray *tableViews;

/** 全部按钮 */
@property (nonatomic, strong) UIButton *allButton;

/** 待取件按钮 */
@property (nonatomic, strong) UIButton *waitButton;

/** 待支付按钮 */
@property (nonatomic, strong) UIButton *noPayButton;

/** 已完成按钮 */
@property (nonatomic, strong) UIButton *achieveButton;

/** 下划线视图 */
@property (nonatomic, strong) UIView *underLineView;

/** 灰线视图 */
@property (nonatomic, strong) UIView *grayLineView;

/**<  订单列表网络请求  */
@property (nonatomic, strong) DDInterface *interfaceOrderListAll;
@property (nonatomic, strong) DDInterface *interfaceOrderListWait;
@property (nonatomic, strong) DDInterface *interfaceOrderListNoPay;
@property (nonatomic, strong) DDInterface *interfaceOrderListAcheive;
/**<  删除订单网络请求  */

@property (nonatomic, strong) DDInterface *interfaceDelete;

/**<  订单详情网络请求  */
@property (nonatomic, strong) DDInterface *interfaceDetail;

@property (nonatomic, strong) UITableView *deletedTableView;


/** 订单模型数据列表*/
@property (nonatomic, strong) NSMutableArray *orderListArrayAll;

@property (nonatomic, strong) NSMutableArray *orderListArrayWait;

@property (nonatomic, strong) NSMutableArray *orderListArrayNoPay;

@property (nonatomic, strong) NSMutableArray *orderListArrayAchieve;




/** 被点击行的订单信息 */
@property (nonatomic,strong) DDOrderList *orderList;


@property (nonatomic,strong) NSIndexPath *didSelectIndexPath;

@property (nonatomic, assign) BOOL isLastPageAll;
@end


@implementation DDOrdersListViewController
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _pageIndexAll = 1;
        _pageIndexWait = 1;
        _pageIndexNoPay = 1;
        _pageIndexAchieve = 1;
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"我的订单" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self disableBackGesture];
    
    [self createButtonSelectBar];
    [self.view addSubview:self.tablesBackView];
    [self createTableView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self orderListWithRequestWithPage:_pageIndexAll andStatus:0];
    [self orderListWithRequestWithPage:_pageIndexWait andStatus:1];
    [self orderListWithRequestWithPage:_pageIndexNoPay andStatus:2];
    [self orderListWithRequestWithPage:_pageIndexAchieve andStatus:3];
}
#pragma mark -TableView Delegate && Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
    if (tableView == self.tableViewAll) {
        number = self.orderListArrayAll.count;
    }else if (tableView == self.tableViewWait) {
        number = self.orderListArrayWait.count;
    }else if (tableView == self.tableViewNoPay) {
        number = self.orderListArrayNoPay.count;
    }else {
        number = self.orderListArrayAchieve.count;
    }
    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DDOrderListCell";
    DDOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DDOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (tableView == self.tableViewAll) {
        cell.orderList = self.orderListArrayAll[indexPath.row];
    } else if (tableView == self.tableViewWait) {
        cell.orderList = self.orderListArrayWait[indexPath.row];
    } else if (tableView == self.tableViewNoPay) {
        cell.orderList = self.orderListArrayNoPay[indexPath.row];
    } else {
        cell.orderList = self.orderListArrayAchieve[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DDOrderList *orderList = [[DDOrderList alloc]init];
    if (tableView == self.tableViewAll) {
        orderList = self.orderListArrayAll[indexPath.row];
    } else if (tableView == self.tableViewWait) {
        orderList = self.orderListArrayWait[indexPath.row];
    } else if (tableView == self.tableViewNoPay) {
        orderList = self.orderListArrayNoPay[indexPath.row];
    } else {
        orderList = self.orderListArrayAchieve[indexPath.row];
    }
    
    self.orderList = orderList;
    self.didSelectIndexPath = indexPath;
    [self orderDetailWithOrderId:orderList.orderId];
    
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return KDDTitleForDelete;
//}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _deleteIndexPath = indexPath;
        DDOrderList *orderList = [[DDOrderList alloc]init];
        self.deletedTableView = tableView;
        if (tableView == self.tableViewAll) {
            orderList = self.orderListArrayAll[indexPath.row];
        } else if (tableView == self.tableViewWait) {
            orderList = self.orderListArrayWait[indexPath.row];
        } else if (tableView == self.tableViewNoPay) {
            orderList = self.orderListArrayNoPay[indexPath.row];
        } else {
            orderList = self.orderListArrayAchieve[indexPath.row];
        }
        
        if (orderList.expressStatus  == 3) {
            [self deleteWithOrderInfo:orderList];
        } else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"您的订单还未完成，无法删除"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewAll) {
        self.tableViewAll.scrollEnabled = NO;
    } else if (tableView == self.tableViewWait) {
        self.tableViewWait.scrollEnabled = NO;
    } else if (tableView == self.tableViewNoPay) {
        self.tableViewNoPay.scrollEnabled = NO;
    } else {
        self.tableViewAchieve.scrollEnabled = NO;
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableViewAll.scrollEnabled = YES;
    if (tableView == self.tableViewAll) {
        self.tableViewAll.scrollEnabled = YES;
    } else if (tableView == self.tableViewWait) {
        self.tableViewWait.scrollEnabled = YES;
    } else if (tableView == self.tableViewNoPay) {
        self.tableViewNoPay.scrollEnabled = YES;
    } else {
        self.tableViewAchieve.scrollEnabled = YES;
    }
}

#pragma mark - Private Method
- (BOOL)reachability
{
    if ([super reachability]) {
        for (UITableView *tbView in self.tableViews) {
            [tbView setDefaultPageWithImageName:@"no-order" andTitle:@"您尚无订单信息" andSubTitle:@"首次下单寄件能省更多哦~" andBtnImage:nil andbtnTitle:nil andBtnAction:nil];
            [self tableHeaderMethodWithTableView:tbView];
        }
    } else {
        for (UITableView *tbView in self.tableViews) {
            [tbView setDefaultPageWithImageName:@"no-network" andTitle:@"网路出问题了！请您查看网络设置" andSubTitle:@"点击屏幕，重新加载" andBtnImage:nil andbtnTitle:nil andBtnAction:nil];;
            [tbView.defaultPageView setHidden:NO];
            if (tbView == self.tableViewAll) {
                _pageIndexAll = 1;
                [self.orderListArrayAll removeAllObjects];
                [self.tableViewAll reloadData];
            } else if (tbView == self.tableViewWait) {
                _pageIndexWait = 1;
                [self.orderListArrayWait removeAllObjects];
                [self.tableViewWait reloadData];
            } else if (tbView == self.tableViewNoPay) {
                _pageIndexNoPay = 1;
                [self.orderListArrayNoPay removeAllObjects];
                [self.tableViewNoPay reloadData];
            } else {
                _pageIndexAchieve = 1;
                [self.orderListArrayAchieve removeAllObjects];
                [self.tableViewAchieve reloadData];
            }
        }
    }
    return [super reachability];
}

/**
 *  初始化button
 */
- (void)createButtonSelectBar
{
    //1背景图
    self.buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44.0f)];
    self.buttonBackView.backgroundColor = DDRGBColor(255, 255, 255);
    [self.view addSubview:self.buttonBackView];
    
    //创建数组，用于存储按钮的对象
    buttons = [[NSMutableArray alloc] initWithCapacity:0];
    
    //循环创建按钮，以Tag值来判断事件的响应
    CGFloat button_w = floorf(self.buttonBackView.width/4.0f);
    self.arrayNavTitle = [NSMutableArray arrayWithObjects:@"全部",@"待取件",@"待付款",@"已完成", nil];
    for (NSInteger i=0; i<self.arrayNavTitle.count; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(button_w*i, 0, button_w, self.buttonBackView.height)];
        [itemButton setBackgroundColor:[UIColor clearColor]];
        [itemButton.titleLabel setFont:kTitleFont];
        [itemButton setTitleColor:CONTENT_COLOR forState:UIControlStateNormal];
        [itemButton setTitleColor:DDGreen_Color forState:UIControlStateSelected];
        [itemButton setTitle:self.arrayNavTitle[i] forState:UIControlStateNormal];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [itemButton setTag:KOrdersListItem+i];
        [itemButton setSelected:i==0 ? true : false];
        [self.buttonBackView addSubview:itemButton];
        [buttons addObject:itemButton];
        switch (i) {
            case 0:
                self.allButton = itemButton ;
                break;
            case 1:
                self.waitButton = itemButton;
                break;
            case 2:
                self.noPayButton = itemButton;
                break;
            case 3:
                self.achieveButton = itemButton;
                break;
            default:
                break;
        }
    }
    
    //设置viewTop底部的分界线
    UIImageView *bottomView = [[UIImageView alloc] init];
    [bottomView setFrame:CGRectMake(0, self.buttonBackView.height - 0.5f, self.buttonBackView.width, 0.5f)];
    [bottomView setBackgroundColor:BORDER_COLOR];
    [self.buttonBackView addSubview:bottomView];
    
    //设置中间的分界线
    self.underLineView = [[UIImageView alloc] init];
    [self.underLineView setFrame:CGRectMake(0, self.buttonBackView.height - 2.0f, self.buttonBackView.width / 4, 2.0f)];
    [self.underLineView setBackgroundColor:DDGreen_Color];
    [self.buttonBackView addSubview:self.underLineView];
    
}

- (void)tableViewRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    for (UITableView *tbView in self.tableViews) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self tableHeaderMethodWithTableView:tbView];
        }];
        [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
        [header setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
        header.stateLabel.font = [UIFont systemFontOfSize:12];
        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
        header.stateLabel.textColor = [UIColor grayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
        tbView.mj_header = header;
        
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self tableFooterMethodWithTableView:tbView];
        }];
        [footer setTitle:@"上拉可以刷新" forState:MJRefreshStateIdle];
        [footer setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        footer.stateLabel.textColor = [UIColor grayColor];
        tbView.mj_footer = footer;
    }
}

- (void)tableHeaderMethodWithTableView:(UITableView *)tableView
{
    if (tableView == self.tableViewAll) {
        _pageIndexAll = 1;
        [self orderListWithRequestWithPage:_pageIndexAll andStatus:0];
    } else if (tableView == self.tableViewWait) {
        _pageIndexWait = 1;
        [self orderListWithRequestWithPage:_pageIndexWait andStatus:1];
    } else if (tableView == self.tableViewNoPay) {
        _pageIndexNoPay = 1;
        [self orderListWithRequestWithPage:_pageIndexNoPay andStatus:2];
    } else {
        _pageIndexAchieve = 1;
        [self orderListWithRequestWithPage:_pageIndexAchieve andStatus:3];
    }
}
- (void)tableFooterMethodWithTableView:(UITableView *)tableView
{
    if (tableView == self.tableViewAll) {
        [self orderListWithRequestWithPage:_pageIndexAll andStatus:0];
    } else if (tableView == self.tableViewWait) {
        [self orderListWithRequestWithPage:_pageIndexWait andStatus:1];
    } else if (tableView == self.tableViewNoPay) {
        [self orderListWithRequestWithPage:_pageIndexNoPay andStatus:2];
    } else {
        [self orderListWithRequestWithPage:_pageIndexAchieve andStatus:3];
    }
}

- (void)setButtonSelectedWithButton:(UIButton *)button
{
    for (UIButton *btn in buttons) {
        if (btn == button) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

- (void)createTableView
{
    for (int i = 0; i < 4; i ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width * i, 0, self.view.width, self.tablesBackView.height)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorColor = BORDER_COLOR;
        tableView.backgroundColor = KBackground_COLOR;
        [tableView addDefaultPageWithImageName:@"no-order" andTitle:@"您尚无订单信息" andSubTitle:@"首次下单寄件能省更多哦~" andBtnImage:nil andbtnTitle:nil andBtnAction:nil];
        [self.tableViews addObject:tableView];
        [self.tablesBackView addSubview:tableView];
        if (i == 0) {
            self.tableViewAll = tableView;
        }else if (i == 1) {
            self.tableViewWait = tableView;
        }else if (i == 2) {
            self.tableViewNoPay = tableView;
        }else {
            self.tableViewAchieve = tableView;
        }
    }
    [self tableViewRefresh];
}

#pragma mark - Event Method
- (void)onClickWithItem:(UIButton *)button
{
    if (button == self.allButton) {
        self.tablesBackView.x = 0;
        [self setButtonSelectedWithButton:self.allButton];
    } else if (button == self.waitButton) {
        self.tablesBackView.x = -self.view.width;
        [self setButtonSelectedWithButton:self.waitButton];
    } else if (button == self.noPayButton) {
        self.tablesBackView.x = -self.view.width * 2;
        [self setButtonSelectedWithButton:self.noPayButton];
    } else {
        self.tablesBackView.x = -self.view.width * 3;
        [self setButtonSelectedWithButton:self.achieveButton];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.underLineView.x = -self.tablesBackView.x/4;
    }];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DDPayCostController Delegate
- (void)payCost:(DDPayCostController *)payCost didClickCallBackConfirmBtnWithIndexPath:(NSIndexPath *)indexPath
{
    [self.orderListArrayNoPay removeObjectAtIndex:indexPath.row];
    [self.tableViewNoPay deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Network Request
- (void) orderDetailWithOrderId:(NSString *)orderId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //订单ID
    [param setObject:orderId  forKey:@"orderId"];
    
    self.interfaceDetail = [[DDInterface alloc] initWithDelegate:self];
    [self.interfaceDetail interfaceWithType:INTERFACE_TYPE_ORDER_DETAIL  param:param];
}

- (void)orderListWithRequestWithPage:(NSInteger)page andStatus:(NSInteger)statu
{
    //传参数字典
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //页码
    [param setObject:@(page) forKey:@"page"];
    
    DDInterface *interface = [[DDInterface alloc] initWithDelegate:self];
    if (statu != 0) {
        [param setObject:@(statu) forKey:@"status"];
    }
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [interface interfaceWithType:INTERFACE_TYPE_ORDER_LIST param:param];
    
    switch (statu) {
        case 0:
            self.interfaceOrderListAll = interface;
            break;
        case 1:
            self.interfaceOrderListWait = interface;
            break;
        case 2:
            self.interfaceOrderListNoPay = interface;
            break;
        case 3:
            self.interfaceOrderListAcheive = interface;
            break;
        default:
            break;
    }
}

/**
 *  更近订单号删除订单
 *
 *  @orderId 订单号
 */
- (void)deleteWithOrderInfo:(DDOrderList *)orderList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //订单 ID
    if ([orderList.orderId length] > 0) {
        [param setObject:orderList.orderId forKey:@"orderId"];
    }
    
    if (!self.interfaceDelete) {
        self.interfaceDelete = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceDelete interfaceWithType:INTERFACE_TYPE_DELETE_ORDER param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceOrderListAll) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.tableViewAll.mj_header endRefreshing];
            [self.tableViewAll.mj_footer endRefreshing];
            if (_pageIndexAll == 1) [self.orderListArrayAll removeAllObjects];
            for (NSDictionary *dict in result[@"orderList"]) {
                DDOrderList *orderList = [DDOrderList yy_modelWithDictionary:dict];
                orderList.companyIcon = [DDInterfaceTool logoWithCompanyId:orderList.companyId];
                [self.orderListArrayAll addObject:orderList];
            }
            if (self.orderListArrayAll.count<20) {
                _pageIndexAll = 1;
            }else {
                _pageIndexAll = self.orderListArrayAll.count / 20 + 1;
                if (self.orderListArrayAll.count % 20 != 0) {
                    [self.tableViewAll.mj_footer setState:MJRefreshStateNoMoreData];
                }
            }
            [self.tableViewAll.mj_footer setHidden:self.orderListArrayAll.count < 20];
//            [self setPageIndexfromOrderArray:self.orderListArrayAll];
            [self.tableViewAll.defaultPageView setHidden:self.orderListArrayAll.count > 0];
            [self.tableViewAll reloadData];
        }
    }else if (interface == self.interfaceOrderListWait) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.tableViewWait.mj_header endRefreshing];
            [self.tableViewWait.mj_footer endRefreshing];
            if (_pageIndexWait == 1) [self.orderListArrayWait removeAllObjects];
            for (NSDictionary *dict in result[@"orderList"]) {
                DDOrderList *orderList = [DDOrderList yy_modelWithDictionary:dict];
                orderList.companyIcon = [DDInterfaceTool logoWithCompanyId:orderList.companyId];
                [self.orderListArrayWait addObject:orderList];
            }
            [self.tableViewWait.mj_footer setHidden:self.orderListArrayWait.count < 20];
            [self setPageIndexfromOrderArray:self.orderListArrayWait];
            [self.tableViewWait.defaultPageView setHidden:self.orderListArrayWait.count > 0];
            [self.tableViewWait reloadData];
        }
    }else if (interface == self.interfaceOrderListNoPay) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.tableViewNoPay.mj_header endRefreshing];
            [self.tableViewNoPay.mj_footer endRefreshing];
            if (_pageIndexNoPay == 1) [self.orderListArrayNoPay removeAllObjects];
            for (NSDictionary *dict in result[@"orderList"]) {
                DDOrderList *orderList = [DDOrderList yy_modelWithDictionary:dict];
                orderList.companyIcon = [DDInterfaceTool logoWithCompanyId:orderList.companyId];
                [self.orderListArrayNoPay addObject:orderList];
            }
            [self.tableViewNoPay.mj_footer setHidden:self.orderListArrayNoPay.count < 20];
            [self setPageIndexfromOrderArray:self.orderListArrayNoPay];
            [self.tableViewNoPay.defaultPageView setHidden:self.orderListArrayNoPay.count > 0];
            [self.tableViewNoPay reloadData];
        }
    }else if (interface == self.interfaceOrderListAcheive) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.tableViewAchieve.mj_header endRefreshing];
            [self.tableViewAchieve.mj_footer endRefreshing];
            if (_pageIndexAchieve == 1) [self.orderListArrayAchieve removeAllObjects];
            for (NSDictionary *dict in result[@"orderList"]) {
                DDOrderList *orderList = [DDOrderList yy_modelWithDictionary:dict];
                orderList.companyIcon = [DDInterfaceTool logoWithCompanyId:orderList.companyId];
                [self.orderListArrayAchieve addObject:orderList];
            }
            [self.tableViewAchieve.mj_footer setHidden:self.orderListArrayAchieve.count < 20];
            [self setPageIndexfromOrderArray:self.orderListArrayAchieve];
            [self.tableViewAchieve.defaultPageView setHidden:self.orderListArrayAchieve.count > 0];
            [self.tableViewAchieve reloadData];
        }
    }else if (interface == self.interfaceDelete) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            if (self.deletedTableView) {
                if (self.deletedTableView == self.tableViewAll) {
                    [self.orderListArrayAll removeObjectAtIndex:_deleteIndexPath.row];
                    [self.tableViewAll.defaultPageView setHidden:self.orderListArrayAll.count > 0];
                }else if (self.deletedTableView == self.tableViewWait) {
                    [self.orderListArrayWait removeObjectAtIndex:_deleteIndexPath.row];
                    [self.tableViewWait.defaultPageView setHidden:self.orderListArrayWait.count > 0];
                }else if (self.deletedTableView == self.tableViewNoPay) {
                    [self.orderListArrayNoPay removeObjectAtIndex:_deleteIndexPath.row];
                    [self.tableViewNoPay.defaultPageView setHidden:self.orderListArrayNoPay.count > 0];
                }else {
                    [self.orderListArrayAchieve removeObjectAtIndex:_deleteIndexPath.row];
                    [self.tableViewAchieve.defaultPageView setHidden:self.orderListArrayAchieve.count > 0];
                }
                [self.deletedTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    else if (interface == self.interfaceDetail)
    {
        DDCourierDetail *courierDetail = [[DDCourierDetail alloc] init];
        courierDetail.courierID = [NSString stringWithFormat:@"%@",result[@"couId"]];
        courierDetail.courierHeadIcon = [NSString stringWithFormat:@"%@",result[@"couIcon"]];
        courierDetail.courierName = [NSString stringWithFormat:@"%@",result[@"couName"]];
        courierDetail.courierPhone = [NSString stringWithFormat:@"%@",result[@"couPhone"]];
        courierDetail.companyName = [NSString stringWithFormat:@"%@",result[@"corName"]];
        courierDetail.companyId = [NSString stringWithFormat:@"%@",result[@"corId"]];
        courierDetail.courierGrade = [NSString stringWithFormat:@"%@",result[@"couStart"]];
        courierDetail.courierIdentityID = [NSString stringWithFormat:@"%@",result[@"couCard"]];
        courierDetail.finishedOrderNumber =  [NSString stringWithFormat:@"%@",result[@"couOrderNum"]];
        courierDetail.courierRank = [NSString stringWithFormat:@"%@",result[@"couRank"]];
        courierDetail.courierStar = [NSString stringWithFormat:@"%@",result[@"couStart"]];
        courierDetail.orderId = self.orderList.orderId;
        
        DDOrderDetail *orderDetail = [DDOrderDetail yy_modelWithDictionary:result];
        orderDetail.orderId = self.orderList.orderId;
        
        if (self.orderList.expressStatus == KDDOrderListWait) {
            NSArray *viewControllers = [self.navigationController childViewControllers];
            for (UIViewController *viewController in viewControllers)
            {
                if ([viewController isKindOfClass:[DDHomeController class]]) {
                    //[[DDGlobalVariables sharedInstance] setCourierDetailForWaitCourierListToHomePage:courierDetail];
                    
                    ((DDHomeController *)viewController).waitedCourierDetail = courierDetail;
                    ((DDHomeController *)viewController).homePageStatus = DDHomePageWaitForGetExpress;
                    [DDGlobalVariables sharedInstance].backHomeViewNeedToShowCourierDetail = YES;
                    [self.navigationController popToViewController:viewController animated:YES];
                    break;
                }
            }
        } else if (self.orderList.expressStatus == KDDOrderListNotPay) {
            
            DDPayCostController * payController = [[DDPayCostController alloc] init];
            payController.delegate = self;
            payController.orderId = orderDetail.orderId;
            payController.indexPath = self.didSelectIndexPath;
            [self.navigationController pushViewController:payController animated:YES];
        } else if (self.orderList.expressStatus == KDDOrderListAchieve) {
            
            DDOrderDetailControlStyle style = (self.orderList.whetherEvaluated == 0) ? DDOrderDetailControlStyleAnonymous : DDOrderDetailControlStyleEvaluationOfComplete;
            DDOrderDetailController * detailController = [[DDOrderDetailController alloc] initWithOrderStyle:style];
            detailController.orderDetail = orderDetail;
            [self.navigationController pushViewController:detailController animated:YES];
        }
    }
}


- (void)setPageIndexfromOrderArray:(NSMutableArray *)orderArray
{
    if (orderArray == self.orderListArrayAll) {

    } else if (orderArray == self.orderListArrayWait) {
        if (orderArray.count<20) {
            _pageIndexWait = 1;
        }else {
            _pageIndexWait = orderArray.count / 20 + 1;
            if (orderArray.count % 20 != 0) {
                [self.tableViewWait.mj_footer setState:MJRefreshStateNoMoreData];
            }
        }
    } else if (orderArray == self.orderListArrayNoPay) {
        if (orderArray.count<20) {
            _pageIndexNoPay = 1;
        }else {
            _pageIndexNoPay = orderArray.count / 20 + 1;
            if (orderArray.count % 20 != 0) {
               [self.tableViewNoPay.mj_footer setState:MJRefreshStateNoMoreData];
            }
        }
    }else {
        if (orderArray.count<20) {
            _pageIndexAchieve = 1;
        }else {
            _pageIndexAchieve = orderArray.count / 20 + 1;
            if (orderArray.count % 20 != 0) {
                [self.tableViewAchieve.mj_footer setState:MJRefreshStateNoMoreData];
            }
        }
    }
}

#pragma mark - Setter && Getter
- (NSMutableArray *)orderListArrayAll
{
    if (_orderListArrayAll == nil) {
        _orderListArrayAll = [NSMutableArray array];
    }
    return _orderListArrayAll;
}
- (NSMutableArray *)orderListArrayWait
{
    if (_orderListArrayWait == nil) {
        _orderListArrayWait = [NSMutableArray array];
    }
    return _orderListArrayWait;
}
- (NSMutableArray *)orderListArrayNoPay
{
    if (_orderListArrayNoPay == nil) {
        _orderListArrayNoPay = [NSMutableArray array];
    }
    return _orderListArrayNoPay;
}
- (NSMutableArray *)orderListArrayAchieve
{
    if (_orderListArrayAchieve == nil) {
        _orderListArrayAchieve = [NSMutableArray array];
    }
    return _orderListArrayAchieve;
}



- (UIView *)tablesBackView
{
    if (_tablesBackView == nil) {
        UIView *scrollView = [[UIView alloc]initWithFrame:CGRectMake(0, KNavHeight + 44, self.view.width*4, self.view.height - KNavHeight - 44)];
//        scrollView.backgroundColor = KBackground_COLOR;
//        scrollView.contentSize = CGSizeMake(self.view.width * 4, self.view.height-64-44);
//        scrollView.alwaysBounceHorizontal = NO;
//        scrollView.alwaysBounceVertical = NO;
//        scrollView.showsHorizontalScrollIndicator = NO;
//        scrollView.showsVerticalScrollIndicator = NO;
//        scrollView.pagingEnabled = YES;
//        scrollView.scrollEnabled = NO;
//        scrollView.contentOffset = CGPointMake(0, 0);
//        scrollView.bounces = NO;
//        scrollView.delegate = self;
        _tablesBackView = scrollView;
    }
    return _tablesBackView;
}

- (NSMutableArray *)tableViews
{
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

@end
