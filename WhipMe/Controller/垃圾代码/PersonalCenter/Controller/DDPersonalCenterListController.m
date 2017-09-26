//
//  DDPersonalCenterListController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDPersonalCenterListController.h"
#import "Constant.h"
#import "DDOrdersListViewController.h"
#import "DDMyWalletController.h"
#import "DDNotificationController.h"
#import "DDNotificationContainerController.h"
#import "DDMarketController.h"
#import "DDRecommendPrizeController.h"
#import "DDSettingController.h"
#import "DDPersonalList.h"
#import "DDPersonalDetailController.h"
#import "DDPersonalListHeadView.h"
//#import "DDPrizeListController.h"
#import "DDWebViewController.h"
#import "DDPersonalListTableViewCell.h"

#import "DDSelfInfomation.h"
#import "YYModel.h"
#import "DDGlobalVariables.h"
#import "RESideMenu.h"
#import "BaseNavController.h"
#import "NSObject+CustomCategory.h"


/** tableView section header的高度 */
#define DDHeightForHeader 10.0f
/** tableViewCell的高度 */
#define DDHeightForRowCell (DDHeightForHeader*2.0f + 30.0f)
/** 图片与Title之间的距离 */
#define  DDCellIconSpaceToTitle 34.0f
/** 图片的宽和高 */
#define DDCellListIconWH 18.0f
/** Icon的X坐标 */
#define DDCellLeftSpace 20.0f

@interface DDPersonalCenterListController () <DDPersonalListHeadDelegate, DDInterfaceDelegate, UITableViewDataSource, UITableViewDelegate>

/** 表格视图 */
@property (nonatomic, strong) UITableView *menuTableView;
/** 个人信息菜单列表 */
@property (nonatomic, strong) NSArray *personalList;
/** 表格headview，显示user信息 */
@property (nonatomic, strong) DDPersonalListHeadView *headerView;
/**<  网络数据  */
@property (nonatomic, strong) DDInterface *interfacePersonal;
@end

@implementation DDPersonalCenterListController
@synthesize menuTableView;

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.headerView updateUserInfo];
}

- (void)createTableView
{
    menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    [menuTableView setBackgroundColor:[UIColor whiteColor]];
    [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [menuTableView setScrollEnabled:NO];
    [menuTableView setDelegate:self];
    [menuTableView setDataSource:self];
    [self.view addSubview:menuTableView];
    
    menuTableView.tableHeaderView = self.headerView;
}

#pragma mark - 对象方法:设置页面
/** 点击联系客服弹出框 */
- (void)serviceAlert
{
    //UIAlertController *serviceAlert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertController *serviceAlert = [[UIAlertController alloc] init];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"客服电话" style:UIAlertActionStyleDestructive handler:nil];
    //UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:nil];
    [serviceAlert addAction:cancelAction];
    [serviceAlert addAction:phoneAction];
    //[serviceAlert addAction:archiveAction];
    
    [self presentViewController:serviceAlert animated:YES completion:nil];
}

#pragma mark - DDPersonalListHeadDelegate
/** 菜单头部代理方法 */
- (void)personalListHeadDidClick
{
    DDPersonalDetailController *controller = [[DDPersonalDetailController alloc] init];
    BaseNavController *nav = (BaseNavController *)self.sideMenuViewController.contentViewController;
    [nav pushViewController:controller animated:YES];
    
    [self.sideMenuViewController hideMenuViewControllerAnimated:NO];
}

#pragma mark - tableView 数据源及代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personalList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DDHeightForRowCell;
}

/** 设置 tableView 的 cell */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"personalListTableViewCell";
    DDPersonalListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DDPersonalListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    DDPersonalList *personList = self.personalList[indexPath.row];
    [cell.textLabel setText:personList.indexName];
    [cell.imageView setImage:[UIImage imageNamed:personList.indexIcon]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DDHeightForHeader + 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, DDHeightForHeader)];
}

/**
 设置 tableView 的 cell点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row % self.personalList.count;
    UIViewController *viewController = nil;
    
    if (index == DDPersonalCenterListOrderList) {//进入我的订单列表页面
        viewController = [[DDOrdersListViewController alloc] init];
    } else if (index == DDPersonalCenterListWalle) { //进入我的钱包页面
        viewController = [[DDMyWalletController alloc] init];
    } else if (index == DDPersonalCenterListNotification) { //进入通知中心页面
        viewController = [[DDNotificationContainerController alloc] init];
    } else if (index == DDPersonalCenterListRecommenPrize) { //进入推荐有奖界面
        viewController = [[DDWebViewController alloc] init];
        NSLog(@"%@", LocalUserInfo);
        ((DDWebViewController *)viewController).URLString = [NSString stringWithFormat:@"%@signature=%@&registerAward.shareuserid=%@", PopularizeHtmlUrlStr, [self getSignatureForMd5],[LocalUserInfo objectForKey:@"userId"]];
        ((DDWebViewController *)viewController).navTitle = @"推荐有奖";
    }  else if (index == DDPersonalCenterListSetting) { //进入设置页面
        viewController = [[DDSettingController alloc] init];
    } else if (index == DDPersonalCenterListServiceAlert) { //弹出联系客服框
        [self callCustomerService:@"4008228089"];
        return;
    }
    
    if (viewController) {
        BaseNavController *nav = (BaseNavController *)self.sideMenuViewController.contentViewController;
        [nav pushViewController:viewController animated:YES];
    }

    [self.sideMenuViewController hideMenuViewControllerAnimated:NO];
}

- (NSString *)getSignatureForMd5
{
    NSString *key = [NSString stringWithFormat:@"%@%@1a@$3321ooobbA#bbbbbbbb2@@@@@@@%%%%%%",[LocalUserInfo objectForKey:@"userId"],[LocalUserInfo objectForKey:@"phone"]];
    return [key MD5];
}

/**
 *  拨打电话
 */
- (void)callCustomerService:(NSString *)phone
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
}

#pragma - mark 懒加载
- (NSArray *)personalList
{
    if (_personalList == nil) {
        NSArray *arrayList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"personalList.plist" ofType:nil]];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in arrayList) {
            [arrayM addObject:[DDPersonalList personalListWithDict:dict]];
        }
        _personalList = arrayM;
    }
    return _personalList;
}

- (DDPersonalListHeadView *)headerView
{
    if (!_headerView) {
        
        CGFloat tableHeaderViewHeight = (MainScreenHeight - DDLeftSliderMenuScale * MainScreenHeight) / 2 + 120 * DDLeftSliderMenuScale;
        _headerView = [[DDPersonalListHeadView alloc] init];
        [_headerView setFrame:CGRectMake(0, 0, MainScreenWidth, tableHeaderViewHeight)];
        [_headerView setBackgroundColor:DDGreen_Color];
        [_headerView setDelegate:self];
    }
    return _headerView;
}

@end
