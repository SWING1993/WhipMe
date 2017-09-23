//
//  DDMyWalletController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDMyWalletController.h"
#import "Constant.h"
#import "DDWalletCoin.h"
#import "DDCoupons.h"
#import "DDMyCouponsController.h"
#import "DDExchangeCouponController.h"
#import "DDMyBalanceController.h"
#import "YYModel.h"
#import "DDMyWalletCell.h"

@interface DDMyWalletController () <DDInterfaceDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *walletTableView;

@property (nonatomic, strong) NSMutableArray *arrayList;
@property (nonatomic, strong) DDWalletCoin *walletCoin;

/**
 *  网络请求
 */
@property (nonatomic, strong) DDInterface *interMyWallet;

@end

@implementation DDMyWalletController
@synthesize walletTableView;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.walletCoin = [[DDWalletCoin alloc] init];
        
        [self walletWithRequest];
    }
    return self;
}

/** 我的钱包 数据请求 */
- (void)walletWithRequest
{
    if (!self.interMyWallet)
    {
        self.interMyWallet = [[DDInterface alloc] initWithDelegate:self];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [self.interMyWallet interfaceWithType:INTERFACE_TYPE_MY_WALLET param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interMyWallet)
    {
        NSLog(@"_________我的钱包");
        NSLog(@"_________result:%@______error:%@",result, error);
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            DDWalletCoin *wallet = [DDWalletCoin yy_modelWithDictionary:result];
            if (wallet != nil) {
                self.walletCoin = wallet;
            }
            [self.walletTableView reloadData];
            
        }
    }
}

#pragma mark - 懒加载
- (NSArray *)arrayList
{
    if (_arrayList == nil) {
        _arrayList = [NSMutableArray arrayWithObjects:@"余额",@"优惠券", nil];
    }
    return _arrayList;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:KBackground_COLOR];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"钱包" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    walletTableView = [[UITableView alloc] init];
    [walletTableView setFrame:CGRectMake(0, 64, self.view.width, MainScreenHeight - KNavHeight)];
    [walletTableView setBackgroundColor:KBackground_COLOR];
    [walletTableView setDelegate:self];
    [walletTableView setDataSource:self];
    [walletTableView setBounces:false];
    [self.view addSubview:walletTableView];
    
    
    walletTableView.separatorColor = DDRGBAColor(233, 233, 233, 1);
    if ([walletTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [walletTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([walletTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [walletTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    walletTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

#pragma mark -  tableView 数据源及代理方法
/**
    设置 tableView 的 section 数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

/**
    设置 tableView 的 行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

/**
    设置 tableView 的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"walletCell";
    
    DDMyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DDMyWalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.headLabel.text = self.arrayList[indexPath.row];
    if (indexPath.row == 0) {
        cell.isCouponCell = NO;
    }else {
        cell.isCouponCell = YES;
    }
    cell.walletCoin = self.walletCoin?:[[DDWalletCoin alloc]init];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


/**
    设置 tableView 的 cell点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.row == DDMywalletTypeBalance) {
        DDMyBalanceController *balanceController = [[DDMyBalanceController alloc] init];
        balanceController.totalBalance = self.walletCoin.balanceNum;
        [self.navigationController pushViewController:balanceController animated:YES];
    } else if (indexPath.row == DDMywalletTypeCoupon) {
        DDMyCouponsController *couponsController = [[DDMyCouponsController alloc] init];
        [self.navigationController pushViewController:couponsController animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }else {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }

}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
