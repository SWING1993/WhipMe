//
//  DDBudgetController.m
//  DDExpressClient
//
//  Created by SongGang on 4/6/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDBudgetController.h"
#import "Constant.h"
#import "CustomStringUtils.h"
#import "DDWebViewController.h"

@interface DDBudgetController ()

@property (nonatomic ,strong) UILabel *firstHeavy;                  /** 首重费 */
@property (nonatomic ,strong) UILabel *nextHeavy;                   /** 续重费 */
@property (nonatomic ,strong) UILabel *tip;                         /** 小费 */
@property (nonatomic ,strong) UILabel *premium;                     /** 保费 */

@property (nonatomic ,strong) UILabel *coupons;                     /** 优惠券折扣 */
@property (nonatomic ,strong) UILabel *budgetMoney;                 /** 预估费用 */
@property (nonatomic ,strong) UILabel *firstHeavyTitle;             /** 首重费标题 */
@property (nonatomic ,strong) UILabel *nextHeavyTitle;              /** 续重费标题 */

@property (nonatomic ,strong) UILabel *tipTitle;                    /** 小费标题 */
@property (nonatomic ,strong) UILabel *premiumTitle;                /** 保费标题 */
@property (nonatomic ,strong) UILabel *couponsTitle;                /** 优惠券折扣标题 */
@property (nonatomic ,strong) UILabel *budgetMoneyTitle;            /** 预估费用标题 */
@property (nonatomic ,strong) UIButton *budgetDetail;               /** 预估费用规则详情 */

@end

@implementation DDBudgetController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"预估费用详情" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self ddCreateViewLoad];
}

/** 创建界面控价 */
- (void)ddCreateViewLoad
{
    UIImageView *lineView = [[UIImageView alloc] init];
    [lineView setImage:[UIImage imageNamed:DDCheckCostLine]];
    [self.view addSubview:lineView];
    
    //消息提示（预估详情)
    UILabel *messageLabel = [[UILabel alloc] init];
    [messageLabel setFrame:CGRectMake(45.0f, 30.0f + KNavHeight, self.view.width - 45*2.0f, 20.0f)];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setFont:kTitleFont];
    [messageLabel setTextColor:TIME_COLOR];
    [messageLabel setText:@"预估详情"];
    [self.view addSubview:messageLabel];
    self.budgetMoneyTitle = messageLabel;
    
    CGSize msg_size = [messageLabel.text sizeWithAttributes:@{NSFontAttributeName : messageLabel.font}];
    [messageLabel setSize:CGSizeMake(floorf(msg_size.width) + 30.0f, messageLabel.height)];
    [messageLabel setCenter:CGPointMake( self.view.width/2, 30 + KNavHeight)];
    
    [lineView setSize:CGSizeMake(306.0f, 0.5f)];
    [lineView setCenter:messageLabel.center];
    
    /** 价格总计 */
    UILabel *budgetMoney = [[UILabel alloc] init];
    [budgetMoney setFrame:CGRectMake(lineView.left, messageLabel.bottom + 15.0f, lineView.width, 40.0f)];
    [budgetMoney setBackgroundColor:[UIColor clearColor]];
    [budgetMoney setTextAlignment:NSTextAlignmentCenter];
    [budgetMoney setFont:[UIFont systemFontOfSize:34]];
    [budgetMoney setTextColor:TITLE_COLOR];
    if (![CustomStringUtils isBlankString:self.detailInfo.finalCost]) {
        budgetMoney.text = [self.detailInfo.finalCost stringByAppendingString:@"元"];
    }
    [self.view addSubview:budgetMoney];
    self.budgetMoney = budgetMoney;
    
    /**
     循环创建费用明细标签
     */
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"首重费",@"续重费",@"小费",@"优惠券抵扣", nil];
    
    for (NSInteger i=0; i<arrayTitle.count; i++)
    {
        UILabel *itemLabel = [[UILabel alloc] init];
        [itemLabel setFrame:CGRectMake(45.0f, budgetMoney.bottom + 30.0f + i*28, self.view.width - 45*2.0f, 20.0f)];
        [itemLabel setBackgroundColor:[UIColor clearColor]];
        [itemLabel setTextAlignment:NSTextAlignmentLeft];
        [itemLabel setFont:kTitleFont];
        [itemLabel setTextColor:TIME_COLOR];
        [itemLabel setText:arrayTitle[i]];
        [self.view addSubview:itemLabel];
        
        UILabel *itemPrice = [[UILabel alloc] init];
        [itemPrice setFrame:itemLabel.frame];
        [itemPrice setBackgroundColor:[UIColor clearColor]];
        [itemPrice setTextAlignment:NSTextAlignmentRight];
        [itemPrice setFont:kTitleFont];
        [itemPrice setTextColor:TITLE_COLOR];
        [self.view addSubview:itemPrice];
        
        if (i == 0) {
            self.firstHeavy = itemPrice;
            self.firstHeavyTitle = itemLabel;
            
            if (![CustomStringUtils isBlankString:self.detailInfo.firstWeightCost]) {
                itemPrice.text = [NSString stringWithFormat:@"%@元", self.detailInfo.firstWeightCost];
            } else {
                itemPrice.text = @"0元";
            }
        } else if (i == 1) {
            self.nextHeavy = itemPrice;
            self.nextHeavyTitle = itemLabel;
            if (![CustomStringUtils isBlankString:self.detailInfo.secondWeightCost]) {
                itemPrice.text = [NSString stringWithFormat:@"%@元", self.detailInfo.secondWeightCost];
            } else {
                itemPrice.text = @"0元";
            }
        } else if (i == 2) {
            self.tip = itemPrice;
            self.tipTitle = itemLabel;
            if (![CustomStringUtils isBlankString:self.detailInfo.tipCost]) {
                itemPrice.text = [NSString stringWithFormat:@"%@", self.detailInfo.tipCost];
            } else {
                itemPrice.text = @"0元";
            }
            
        } else if (i == 3) {
            self.coupons = itemPrice;
            self.couponsTitle = itemLabel;
            
            if (![CustomStringUtils isBlankString:self.detailInfo.couponCost]) {
                itemPrice.text = [NSString stringWithFormat:@"%@元", self.detailInfo.couponCost];
            } else {
                itemPrice.text = @"0元";
            }
            
        }
    }
    [self.coupons setTextColor:DDOrange_Color];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    [lineLabel setFrame:CGRectMake(self.couponsTitle.left, self.coupons.bottom + 14.0f , self.couponsTitle.width, 1.0f)];
    [lineLabel setBackgroundColor:BORDER_COLOR];
    [self.view addSubview:lineLabel];
    
    UIButton *budgetDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    [budgetDetail setFrame:CGRectMake(self.couponsTitle.left, lineLabel.bottom + 15.0f , self.couponsTitle.width, 16.0f)];
    [budgetDetail setAdjustsImageWhenHighlighted:false];
    [budgetDetail.titleLabel setFont:kTitleFont];
    [budgetDetail addTarget:self action:@selector(budgetDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:budgetDetail];
    self.budgetDetail = budgetDetail;
    
    NSTextAttachment *budget_Icon = [[NSTextAttachment alloc] init];
    [budget_Icon setImage:[UIImage imageNamed:KDDIconPDArraw]];
    [budget_Icon setBounds:CGRectMake(0, -1, 10.0f, 12.0f)];
    NSAttributedString *budget_str_Icon = [NSAttributedString attributedStringWithAttachment:budget_Icon];
    
    NSString *str_budget = @"预估费用规则详情";
    NSDictionary *attribute_price = @{NSFontAttributeName:kTitleFont, NSForegroundColorAttributeName:TIME_COLOR};
    NSMutableAttributedString *att_str_budget = [[NSMutableAttributedString alloc] initWithString:str_budget attributes:attribute_price];
    [att_str_budget insertAttributedString:budget_str_Icon atIndex:str_budget.length];
    [budgetDetail setAttributedTitle:att_str_budget forState:UIControlStateNormal];
    
}


#pragma mark - Event Method

- (void)budgetDetailButtonClick
{
    DDWebViewController *controller = [[DDWebViewController alloc]init];
    controller.URLString = EstimateMoneyHtmlUrlStr;
    controller.navTitle = @"预估费用规则";
    [self.navigationController pushViewController:controller animated:YES];
}



- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
