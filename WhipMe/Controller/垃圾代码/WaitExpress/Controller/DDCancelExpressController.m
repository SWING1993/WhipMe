//
//  DDCancelExpressController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDCancelExpressController.h"

NSString *const DDCancelExpressControllerBigTitleText = @"当前可免费取消";
NSString *const DDCancelExpressControllerSmallTitleText = @"快递员还有1公里就到了,耐心等一会儿吧";
NSString *const DDCancelExpressControllerConfirmButtonTitle = @"确定取消";
NSString *const DDCancelExpressControllerNaviTitleText = @"取消订单";



@interface DDCancelExpressController ()
/** 文字标签 */
@property (strong, nonatomic) UILabel *bigLabel;

/** 文字标签 */
@property (strong, nonatomic) UILabel *smallLabel;

/** 取消按钮 */
@property (strong, nonatomic) UIButton *isCancel;
@end

@implementation DDCancelExpressController


#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationInfo];
}

#pragma mark - 类对象方法:初始化页面
/**
    初始化视图
 */
- (void)createView
{
    
    //文字标签
    self.bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x-100, self.view.center.y-80, 200, 30)];
    self.smallLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x-100, self.view.center.y-40, 200, 40)];
    self.bigLabel.text = DDCancelExpressControllerBigTitleText;
    self.smallLabel.text = DDCancelExpressControllerSmallTitleText;
    self.bigLabel.textAlignment = NSTextAlignmentCenter;
    self.smallLabel.textAlignment = NSTextAlignmentCenter;
    self.smallLabel.font = [UIFont systemFontOfSize:13];
    self.bigLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.bigLabel];
    [self.view addSubview: self.smallLabel];
    
    
    //取消按钮
    self.isCancel = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-100, self.view.center.y-10, 200, 40)];
    [self.isCancel setTitle:DDCancelExpressControllerConfirmButtonTitle forState:UIControlStateNormal];
    [self.isCancel setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.isCancel];
    [self.isCancel addTarget:self action:@selector(isCancelClick) forControlEvents:UIControlEventTouchUpInside];
}

/**
    设置导航信息
 */
- (void)setNavigationInfo
{
    self.navigationItem.title = DDCancelExpressControllerNaviTitleText;
//    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - 类对象方法:监听点击事件
/**
    确认取消按钮(点击事件)
 */
- (void)isCancelClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
