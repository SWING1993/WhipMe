//
//  DDMarketController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDMarketController.h"

#include "DDInterface.h"

/** 广告图片高度 */
#define DDMarketAdvertisingImageHeight 180
/** 嘟币总数标签高度 */
#define DDMarketTotalCoinLabelHeight 50

@interface DDMarketController () <UITableViewDelegate, UITableViewDataSource, DDInterfaceDelegate>


@property (strong, nonatomic) UIImageView *advertisingImage;                                                            /** 广告图片 */
@property (strong, nonatomic) UILabel *totalCoinLabel;                                                                  /** 总嘟币数 */
@property (strong, nonatomic) UITableView *productTableView;                                                            /** 嘟币商城产品列表 */

/**
 *  网络请求
 */
@property (strong, nonatomic) DDInterface *interMarkeet;

@end

@implementation DDMarketController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        /** 嘟嘟商城 网络请求 */
        [self marketWithRequest];
    }
    return self;
}

/** 嘟嘟商城 网络请求 */
- (void)marketWithRequest
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (!self.interMarkeet)
    {
        self.interMarkeet = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interMarkeet interfaceWithType:INTERFACE_TYPE_MARKET_LIST param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interMarkeet)
    {
        NSLog(@"_________艾特商城");
        NSLog(@"_________result:%@______error:%@",result, error);
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            
        }
    }
}

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"艾特商城" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    //设置广告
    [self setAdvertising];
    //设置总嘟币数
    [self setTotalCoin];
    //初始化产品列表
    [self setProduct];
}


#pragma mark - 类的对象方法:设置页面
/**
    设置广告
 */
- (void)setAdvertising
{
    UIImageView *advertisingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123"]];
    advertisingImage.x = 0;
    advertisingImage.y = 0;
    advertisingImage.width = self.view.width;
    advertisingImage.height = DDMarketAdvertisingImageHeight;
    self.advertisingImage = advertisingImage;
    [self.view addSubview:advertisingImage];
}

/**
    设置嘟币数
 */
- (void)setTotalCoin
{
    UILabel *totalCoinLabel = [[UILabel alloc] init];
    
    [totalCoinLabel setBackgroundColor:DDRandColor];
    totalCoinLabel.textAlignment = NSTextAlignmentCenter;
    NSString *strText = [NSString stringWithFormat:@"我的嘟币 %zd",self.totalCoin];
    [totalCoinLabel setText:strText];
    totalCoinLabel.x = 0;
    totalCoinLabel.y = CGRectGetMaxY(self.advertisingImage.frame);
    //totalCoinLabel.y = DDMarketAdvertisingImageHeight;
    totalCoinLabel.width = self.view.width;
    totalCoinLabel.height = DDMarketTotalCoinLabelHeight;
    self.totalCoinLabel = totalCoinLabel;
    [self.view addSubview:totalCoinLabel];
}

/**
    设置产品列表
 */
- (void)setProduct
{
    UITableView *productTableView = [[UITableView alloc] init];
    productTableView.delegate = self;
    productTableView.dataSource = self;
    
    productTableView.x = 0;
    productTableView.y = CGRectGetMaxY(self.totalCoinLabel.frame);
    //productTableView.y = DDMarketAdvertisingImageHeight + DDMarketTotalCoinLabelHeight;
    productTableView.width = self.view.width;
    productTableView.height = self.view.height - productTableView.y;
    self.productTableView = productTableView;
    [self.view addSubview:productTableView];
}

/**
    totalCoin setter方法
 */
- (void)setTotalCoin:(NSInteger )totalCoin
{
    _totalCoin = totalCoin;
    NSString *strText = [NSString stringWithFormat:@"我的嘟币 %zd",self.totalCoin];
    [self.totalCoinLabel setText:strText];
}

#pragma mark - tableView 数据源及代理方法
/**
    设置 tableView 的 section 数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/**
    设置 tableView 的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

/**
    设置 tableView 的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"coinCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"123"];
    cell.textLabel.text = @"嘟嘟快递3元抵用券";
    cell.detailTextLabel.text = @"有效期:兑换日7日内有效";
    
    UIButton *accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [accessoryBtn setTitle:@"30币" forState:UIControlStateNormal];
    [accessoryBtn setBackgroundColor:DDRandColor];
    accessoryBtn.width = 50;
    accessoryBtn.height = cell.height;

    cell.accessoryView = accessoryBtn;
    
    return cell;
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
