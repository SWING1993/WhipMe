//
//  DDRecommendPrizeController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDRecommendPrizeController.h"

@interface DDRecommendPrizeController ()

/** 扫码推荐标签 */
@property (nonatomic,strong)IBOutlet UILabel * firstLabel;
/** 微信扫码注册标签 */
@property (nonatomic,strong)IBOutlet UILabel * secondLabel;
/** 分享推荐标签 */
@property (nonatomic,strong)IBOutlet UILabel * thirdLabel;
/** 推送链接注册标签*/
@property (nonatomic,strong)IBOutlet UILabel * forthLabel;
/** 推荐方式view */
@property (nonatomic,strong)IBOutlet UIView * changeView;
/** 分享推荐view */
@property (nonatomic,strong)IBOutlet UIView * firstView;
/** 短信推荐view */
@property (nonatomic,strong)IBOutlet UIView * secondView;

@end

@implementation DDRecommendPrizeController

#pragma mark -- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   [self.navigationController setNavigationBarHidden:YES];
    [self initView];
}

#pragma mark -- 类对象方法
/**
    “推荐用户”和“推荐快递员”两个按钮的触发事件
 */
- (IBAction)recommendAction:(id)sender
{
    UISegmentedControl * segmentedControl = (UISegmentedControl *)sender;
    if([segmentedControl selectedSegmentIndex] == 0)
    {
        [self setFirstView];
            }
    else if([segmentedControl selectedSegmentIndex] == 1)
    {
       [self setSecondView];
            }
    
}

/**
    添加推荐用户的界面
 */
- (void) setFirstView
{
    self.firstLabel.text = @"被推荐用户通过微信扫码您的专属二维码，即可注册";
    self.secondLabel.text = @"分享推荐";
    self.thirdLabel.text = @"被推荐用户通过您推送的链接即可注册";
    self.forthLabel.text = @"...";
    
    for (UIView * view in [_changeView subviews])
    {
        [view removeFromSuperview];
    }
    [_changeView addSubview:_firstView];
}

/**
    添加推荐快递员的界面
 */
- (void) setSecondView
{
    self.firstLabel.text = @"被推荐快递员通过微信扫码您的专属二维码，即可注册";
    self.secondLabel.text = @"短信推荐";
    self.thirdLabel.text = @"被推荐快递员通过您推送的链接即可注册";
    self.forthLabel.text = @"...";
    
    for (UIView * view in [_changeView subviews])
    {
        [view removeFromSuperview];
    }
    [_changeView addSubview:_secondView];
}

/**
    初始化界面
 */
- (void) initView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    _firstView.frame = CGRectMake(0, 0, screen.size.width, CGRectGetHeight(_changeView.frame));
    _secondView.frame = CGRectMake(0, 0,screen.size.width, CGRectGetHeight(_changeView.frame));
    [_changeView addSubview:_firstView];
}

@end
