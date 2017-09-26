//
//  DDNotificationController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDNotificationController.h"
#import "DDNotification.h"
#import "DDNotificationTableViewCell.h"
#include "DDInterface.h"
#import "Constant.h"

#import "DDMyExpressDetailViewController.h"
#import "DDWebViewController.h"
#import "DDMyExpress.h"
#import "MJRefresh.h"

@interface DDNotificationController () <UITableViewDelegate, UITableViewDataSource, DDInterfaceDelegate, DDNotificationCellDelegate>

#pragma mark views

@property (nonatomic, retain)   IBOutlet UIView                                 *backgroundView;                        /**< 背景视图 */
@property (nonatomic, retain)   IBOutlet UITableView                            *tableView;                             /**< 列表视图 */
@property (nonatomic, retain)   IBOutlet UIView                                 *tableFooterView;                       /**< 列表尾视图 */
@property (nonatomic, retain)   IBOutlet UIButton                               *continueButton;                        /**< 继续加载按钮 */

#pragma mark logic

@property (nonatomic, strong)   DDInterface                                     *notiInterface;                         /**< 消息列表接口实例 */
@property (nonatomic, strong)   DDInterface                                     *deleteInterface;                       /**< 删除消息接口实例 */
@property (nonatomic, strong)   NSMutableArray<DDNotification *>                *notifications;                         /**< 通知数组 */
@property (nonatomic, assign)   NSInteger                                        pageNumber;                            /**< 页码 */
@property (nonatomic, strong)   NSIndexPath                                     *deleteIndex;                           /**< 删除的索引 */

@property (nonatomic, strong)   NSMutableArray<NSDictionary *>                  *localNotifactions;                     /**< 本地通知消息数组 */
@property (nonatomic, copy)     NSString                                        *requestTime;                           /**< 请求时间 */
@property (nonatomic, strong)   NSMutableArray<NSDictionary *>                  *requestNotifications;                  /**< 请求到的通知消息数组 */

@property (nonatomic, assign)   BOOL                                             reloaded;                              /**< 是否已经加载过 */

@end

@implementation DDNotificationController

#pragma mark -
#pragma mark Super Methods

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"消息通知" segmentArray:nil];
//    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    self.notiInterface = [[DDInterface alloc] initWithDelegate:self];
    
    self.notifications                  = [NSMutableArray arrayWithCapacity:20];
    self.requestNotifications           = [NSMutableArray arrayWithCapacity:20];
    self.localNotifactions              = [NSMutableArray arrayWithArray:[self getLocalNotificationData]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.reloaded) {
        self.pageNumber         = 1;
        self.tableView.tableFooterView = self.tableFooterView;
        [self.notifications removeAllObjects];
        [self.requestNotifications removeAllObjects];
        [self.tableView reloadData];
        [self requsetNotificationList];
        self.reloaded = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)onClickLeftItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Public Methods

#pragma mark Getters

- (NSString *)requestTime {
    if (1 < _pageNumber) return _requestTime;
    if (1 > self.localNotifactions.count) {
        _requestTime = @"0";
        return _requestTime;
    }
    
    NSDictionary    *notiDic    = self.localNotifactions[0];
    _requestTime                = [notiDic objectForKey:@"date"];
    return _requestTime;
}

#pragma mark -
#pragma mark Private Methods

#pragma mark Actions

/**
 *  继续加载按钮点击
 *
 *  @param sender 按钮对象
 */
- (IBAction)continueButtonClicked:(id)sender {
    [self requsetNotificationList];
    self.continueButton.enabled = NO;
}

#pragma mark Others

/**
 *  请求通知列表
 */
- (void)requsetNotificationList {
    [self.notiInterface interfaceWithType:INTERFACE_TYPE_NOTIFICATION_LIST param:@{@"page":@(self.pageNumber), @"lDate":self.requestTime}];
}

/**
 *  请求通知列表成功
 *
 *  @param result 结果字典
 */
- (void)successRequsetList:(NSDictionary *)result {
    NSArray<NSDictionary *> *resultArray = [result objectForKey:@"msgList"];
    NSArray<NSDictionary *> *changeArray = [self changeArray:resultArray];
    if (0 < changeArray.count) {
        [self.requestNotifications addObjectsFromArray:changeArray];
        [self tableViewAddData:changeArray];
    }
    if (20 > changeArray.count) {
        [self finishRequestList];
    }
    else {
        self.pageNumber++;
        [self requsetNotificationList];
    }
}

/**
 *  列表视图添加数据
 *
 *  @param resultArray 结果数组
 */
- (void)tableViewAddData:(NSArray<NSDictionary *> *)resultArray {
    if (1 > resultArray.count) return;

    NSInteger oldRowCount = self.notifications.count;
    for (NSDictionary *dic in resultArray) {
        DDNotification *notifaction = [[DDNotification alloc] initWithDictionary:dic];
        [self.notifications addObject:notifaction];
    }
    NSInteger newRowCount = self.notifications.count;
    
    NSMutableArray<NSIndexPath *> *indexArray = [NSMutableArray array];
    for (NSInteger i = oldRowCount; i < newRowCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexArray addObject:indexPath];
    }
    
    if (self.pageNumber == 1) [self.tableView reloadData];
    else [self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
}

/**
 *  完成通知列表请求
 */
- (void)finishRequestList {
    self.tableView.tableFooterView  = nil;
    [self tableViewAddData:self.localNotifactions];
    
    if (1 > self.requestNotifications.count) return;
    NSMutableArray<NSDictionary *> *locals = [NSMutableArray arrayWithArray:self.requestNotifications];
    [locals addObjectsFromArray:self.localNotifactions];
    self.localNotifactions = locals;
    [self.requestNotifications removeAllObjects];
    [self saveLocalNotificationData:self.localNotifactions];
}

/**
 *  删除本地的通知信息
 *
 *  @param notification 通知实体
 */
- (void)deleteLocalNotification:(DDNotification *)notification {
    for (NSDictionary *dic in self.requestNotifications) {
        NSString *messageId = [dic objectForKey:@"msgId"];
        if (messageId == notification.messageId) {
            [self.requestNotifications removeObject:dic];
            break;
        }
    }
    
    for (NSDictionary *dic in self.localNotifactions) {
        NSString *messageId = [dic objectForKey:@"msgId"];
        if (messageId == notification.messageId) {
            [self.requestNotifications removeObject:dic];
            [self saveLocalNotificationData:self.localNotifactions];
            break;
        }
    }
}

/**
 *  获取cell信息
 *
 *  @param indexPath 索引
 *
 *  @return cell信息
 */
- (DDNotificationCellInfo *)cellInfoAtIndexPath:(NSIndexPath *)indexPath {
    DDNotification  *notification   = self.notifications[indexPath.row];
    
    NSString    *title      = [self titleWithNotification:notification];
    NSString    *content    = notification.content;
    NSString    *time       = notification.time;
    BOOL         canSelect  = [self canSelectWithNotification:notification];
    DDNotificationCellInfo *cellInfo = [[DDNotificationCellInfo alloc] initWithIndexPath:indexPath title:title content:content time:time canSelect:canSelect];
    
    return cellInfo;
}

/**
 *  根据实体获取标题
 *
 *  @param notification 通知信息实体
 *
 *  @return 标题
 */
- (NSString *)titleWithNotification:(DDNotification *)notification {
    NSString            *title      = @"";
    NOTIFIACION_TYPE     type       = notification.type;
    
    switch (type) {
        case NOTIFIACION_TYPE_EXPRESS:
            title   = @"快递消息";
            break;
            
        case NOTIFIACION_TYPE_SYSTEM:
            title   = @"系统消息";
            break;
            
        case NOTIFIACION_TYPE_ACTIVE:
            title   = @"活动消息";
            break;
            
        default:
            break;
    }
    
    return title;
}

/**
 *  根据实体获得是否可以点击
 *
 *  @param notification 通知消息实体
 *
 *  @return 是否可以点击
 */
- (BOOL)canSelectWithNotification:(DDNotification *)notification {
    BOOL                 canSelect  = NO;
    NOTIFIACION_TYPE     type       = notification.type;
    
    switch (type) {
        case NOTIFIACION_TYPE_EXPRESS:
            canSelect   = YES;
            break;
            
        case NOTIFIACION_TYPE_SYSTEM:
            canSelect   = NO;
            break;
            
        case NOTIFIACION_TYPE_ACTIVE:
            canSelect   = YES;
            break;
            
        default:
            break;
    }
    
    return canSelect;
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NotificantionCellIdentifier";
    DDNotificationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DDNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    
    cell.cellInfo = [self cellInfoAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    
    DDNotification  *notification   = self.notifications[indexPath.row];
    if (NOTIFIACION_TYPE_EXPRESS == notification.type) {//快递消息
        self.deleteIndex     = indexPath;
        self.deleteInterface = [[DDInterface alloc] initWithDelegate:self];
        [self.deleteInterface interfaceWithType:INTERFACE_TYPE_DELETE_NOTIFACTION param:@{@"msgId":notification.messageId}];
    } else {//系统消息
        [self.notifications removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self deleteLocalNotification:notification];
    }
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    DDNotification  *notification   = self.notifications[indexPath.row];
    if (notification.type == NOTIFIACION_TYPE_ACTIVE) return NO;
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KDDTitleForDelete;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.scrollEnabled = NO;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.scrollEnabled = YES;
}

#pragma mark -
#pragma mark DDNotificationCellDelegate

- (void)cell:(UITableViewCell *)cell selectWithIndexPath:(NSIndexPath *)indexPath {
    DDNotification  *notification   = self.notifications[indexPath.row];
    
    if (NOTIFIACION_TYPE_EXPRESS == notification.type) {
        if ([@"" isEqual:notification.expressNum] || [@"" isEqual:notification.companyId]) [MBProgressHUD showError:@"单号和快递公司ID为空"];
        else {
            DDMyExpress *myExpress  = [[DDMyExpress alloc] init];
            myExpress.expressNumber = notification.expressNum;
            myExpress.companyId     = notification.companyId;
            
            DDMyExpressDetailViewController *detailViewController = [[DDMyExpressDetailViewController alloc] initWithModel:myExpress];
            [self.navigationController pushViewController:detailViewController animated:YES];
        }
    }
    
    if (NOTIFIACION_TYPE_ACTIVE == notification.type) {
        if ([@"" isEqualToString:notification.activeUrl]) [MBProgressHUD showError:@"活动URL为空"];
        else {
            DDWebViewController *webViewController = [[DDWebViewController alloc] init];
            webViewController.URLString = notification.activeUrl;
            webViewController.navTitle  = notification.title;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}

#pragma mark -
#pragma mark DDInterfaceDelegate

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error {
    if (interface == self.notiInterface) {
        if (error) {
            [MBProgressHUD showError:error.domain];
            self.continueButton.enabled = YES;
        } else {
            [self.tableView.mj_header endRefreshing];
            [self successRequsetList:result];
        }
    }
    
    if (interface == self.deleteInterface) {
        if (error) [MBProgressHUD showError:error.domain];
        else {
            DDNotification  *notification   = self.notifications[self.deleteIndex.row];
            [self deleteLocalNotification:notification];
            
            [self.notifications removeObjectAtIndex:self.deleteIndex.row];
            [self.tableView deleteRowsAtIndexPaths:@[self.deleteIndex] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark -
#pragma mark Save Read Data

NSString *const DDNotificationDataPlist                   = @"DDNotificationData.plist";                                /**< 存储通知消息文件名 */

/**
 *  获取本地的通知消息数据
 *
 *  @return 本地通知消息数据
 */
- (NSArray<NSDictionary *> *)getLocalNotificationData {
    NSArray<NSDictionary *> *array = [NSArray arrayWithContentsOfFile:DD_DocumentFilePath(DDNotificationDataPlist)];
    
    if (!array) return [[NSMutableArray alloc] init];
    return array;
}

/**
 *  保存本地通知消息数据
 *
 *  @param data 消息数据
 */
- (void)saveLocalNotificationData:(NSArray<NSDictionary *> *)data {
    BOOL success = [data writeToFile:DD_DocumentFilePath(DDNotificationDataPlist) atomically:YES];
    NSLog(@"存通知文件是否成功%i", success);
}

/**
 *  转结果字典
 *
 *  @param array 结果字典
 *
 *  @return 结果字典
 */
- (NSArray<NSDictionary *> *)changeArray:(NSArray<NSDictionary *> *)array {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        NSArray             *keys       = [dic allKeys];
        NSMutableDictionary *newDic     = [NSMutableDictionary dictionary];
        for (NSString *key in keys) {
            NSString *value = [dic objectForKey:key];
            if (!value || [value isKindOfClass:[NSNull class]]) value = @"";
            [newDic setObject:value forKey:key];
        }
        [newArray addObject:newDic];
    }
    
    return newArray;
}


- (void)tableViewRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNumber         = 1;
        self.tableView.tableFooterView = self.tableFooterView;
        [self.notifications removeAllObjects];
        [self.requestNotifications removeAllObjects];
        [self.tableView reloadData];
        [self requsetNotificationList];
        self.reloaded = YES;
    }];
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    self.tableView.mj_header = header;
}


@end
