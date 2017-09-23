//
//  DDMyCouponsController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDMyCouponsController.h"
#import "DDCouponCell.h"
#import "DDCoupons.h"
#import "Constant.h"
#import "YYModel.h"
#import "DDExchangeCouponController.h"
#import "DDWebViewController.h"
#import "MJRefresh.h"
#import "UITableView+DefaultPage.h"

@interface DDMyCouponsController () <DDInterfaceDelegate, UITableViewDelegate, UITableViewDataSource,DDExchangeCouponDelegate>

/** 我的优惠劵列表 */
@property (nonatomic, strong) UITableView *tableView;
/**网络请求*/
@property (nonatomic, strong) DDInterface *interMyCoupons;
/** 优惠券数据模型列表 */
@property (nonatomic, strong) NSMutableArray *couponsList;
/**  兑换规则按钮  */
@property (nonatomic, strong) UIButton *ruleButton;
/**  下一页  */
@property (nonatomic, assign) NSInteger nextPage;
@end

@implementation DDMyCouponsController

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:KBackground_COLOR];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"我的优惠券" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self adaptFirstRightItemWithTitle:@"兑换"];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.ruleButton];
    
    
    
    self.nextPage = 1;
    /** 我的优惠券 网络请求 */
    [self couponWithRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark -  tableView Delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.couponsList.count > 0 ) {
        self.tableView.scrollEnabled = YES;
    }else {
        self.tableView.scrollEnabled = NO;
    }
    return self.couponsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"couponsCell";
    DDCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [DDCouponCell couponCellWithTableView:tableView];
        cell.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.coupon = self.couponsList[indexPath.row];

    return cell;
}


#pragma mark - Private Method
- (void)unFinishFoorterRefresh
{
    NSInteger lastCellNumber = self.couponsList.count % 20;
    NSInteger currentPage = self.couponsList.count / 20;
    if (self.couponsList.count == 0 || lastCellNumber > 0) {
        return;
    }
    self.nextPage = currentPage + 1;
    [self couponWithRequest];
}

#pragma mark - DDExchangeCouponController Delegate
- (void)reloadDataListByAddExchangeCoupon
{
    self.nextPage = 1;
    [self.couponsList removeAllObjects];
    [self couponWithRequest];
}

#pragma mark - Click Method

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onClickFirstRightItem
{
    DDExchangeCouponController *vc = [[DDExchangeCouponController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) onClickRuleButton
{
    DDWebViewController *vc = [[DDWebViewController alloc]init];
    vc.URLString = CouponRuleHtmlUrlStr;
    vc.navTitle = @"优惠券规则";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Network Request
/** 我的优惠券 网络请求 */
- (void)couponWithRequest
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //页码
    [param setObject:@(self.nextPage) forKey:@"page"];
    
    if (!self.interMyCoupons)
    {
        self.interMyCoupons = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interMyCoupons interfaceWithType:INTERFACE_TYPE_COUPON_LIST param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    [self.tableView.mj_footer endRefreshing];
    if (interface == self.interMyCoupons) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            NSArray *array = result[@"coupList"];
            if (array.count > 0) {
                [self.tableView.mj_footer setHidden:array.count < 20];
                NSMutableArray *arrayM = [NSMutableArray array];
                for (NSDictionary *dict in array) {
                    DDCoupons *coupon = [DDCoupons yy_modelWithDictionary:dict];
                    [arrayM addObject:coupon];
                }
                [self.couponsList addObjectsFromArray:arrayM];
            }else{
                
            }
            [self.tableView.defaultPageView setHidden:self.couponsList.count > 0];
            [self.tableView reloadData];
        }
    }
}



#pragma mark - Setter && Setter
- (NSMutableArray *)couponsList
{
    if (_couponsList == nil) {
        _couponsList = [NSMutableArray array];
    }
    return _couponsList;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setFrame:CGRectMake(0, KNavHeight + 30, self.view.width, self.view.height - KNavHeight - 30)];
        [_tableView setBackgroundColor:KBackground_COLOR];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = NO;
        [_tableView addDefaultPageWithImageName:@"no-ticket" andTitle:@"还没有优惠券" andSubTitle:nil andBtnImage:nil andbtnTitle:nil andBtnAction:nil withTarget:nil];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(unFinishFoorterRefresh)];
    }
    return _tableView;
}


- (UIButton *)ruleButton
{
    if (_ruleButton == nil) {
        NSString *str_rult = @" 优惠券规则";
        CGSize size_rult = [str_rult sizeWithAttributes:@{NSFontAttributeName:kTitleFont}];
        UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ruleBtn setFrame:CGRectMake(self.view.width - floorf(size_rult.width+30), KNavHeight, floorf(size_rult.width+30), 30)];
        [ruleBtn setBackgroundColor:[UIColor clearColor]];
        [ruleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [ruleBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
        [ruleBtn setImage:[UIImage imageNamed:@"couponRule"] forState:UIControlStateNormal];
        [ruleBtn setTitle:str_rult forState:UIControlStateNormal];
        [ruleBtn.titleLabel setFont:kTitleFont];
        [ruleBtn setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [ruleBtn addTarget:self action:@selector(onClickRuleButton) forControlEvents:UIControlEventTouchUpInside];
        _ruleButton = ruleBtn;
    }
    return _ruleButton;
}


@end
