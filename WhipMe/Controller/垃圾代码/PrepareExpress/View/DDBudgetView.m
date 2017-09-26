//
//  DDBudgetView.m
//  DDExpressClient
//
//  Created by SongGang on 4/6/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDBudgetView.h"
#import "Constant.h"

@interface DDBudgetView()
@property (nonatomic ,strong)UILabel *firstHeavy;                  /** 首重费 */
@property (nonatomic ,strong)UILabel *nextHeavy;                   /** 续重费 */
@property (nonatomic ,strong)UILabel *tip;                         /** 小费 */
@property (nonatomic ,strong)UILabel *premium;                     /** 保费 */
@property (nonatomic ,strong)UILabel *coupons;                     /** 优惠券折扣 */
@property (nonatomic ,strong)UILabel *budgetMoney;                 /** 预估费用 */
@property (nonatomic ,strong)UILabel *firstHeavyTitle;             /** 首重费标题 */
@property (nonatomic ,strong)UILabel *nextHeavyTitle;              /** 续重费标题 */
@property (nonatomic ,strong)UILabel *tipTitle;                    /** 小费标题 */
@property (nonatomic ,strong)UILabel *premiumTitle;                /** 保费标题 */
@property (nonatomic ,strong)UILabel *couponsTitle;                /** 优惠券折扣标题 */
@property (nonatomic ,strong)UILabel *budgetMoneyTitle;            /** 预估费用标题 */
@property (nonatomic ,strong)UILabel *budgetDetail;                /** 预估费用规则详情 */

@end

@implementation DDBudgetView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [self initWithFrame:self.frame];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    UILabel *firstHeavy = [[UILabel alloc] init];
    [self addSubview:firstHeavy];
    self.firstHeavy = firstHeavy;
    firstHeavy.text = @"9.00-12.00元";
    
    UILabel *nextHeavy = [[UILabel alloc] init];
    [self addSubview:nextHeavy];
    self.nextHeavy = nextHeavy;
    nextHeavy.text = @"2.00-4.00元";

    UILabel *tip = [[UILabel alloc] init];
    [self addSubview:tip];
    self.tip = tip;
    tip.text = @"4.00元";

    UILabel *premium = [[UILabel alloc] init];
    [self addSubview:premium];
    self.premium = premium;
    premium.text = @"0.00元";
    
    UILabel *coupons = [[UILabel alloc] init];
    [self addSubview:coupons];
    self.coupons = coupons;
    coupons.text = @"-5.00元";
    
    UILabel *firstHeavyTitle = [[UILabel alloc] init];
    [self addSubview:firstHeavyTitle];
    self.firstHeavyTitle = firstHeavyTitle;
    firstHeavyTitle.text = @"首重费";
    
    UILabel *nextHeavyTitle = [[UILabel alloc] init];
    [self addSubview:nextHeavyTitle];
    self.nextHeavyTitle = nextHeavyTitle;
    nextHeavyTitle.text = @"续重费";
    
    UILabel *tipTitle = [[UILabel alloc] init];
    [self addSubview:tipTitle];
    self.tipTitle = tipTitle;
    tipTitle.text = @"小费";
    
    UILabel *premiumTitle = [[UILabel alloc] init];
    [self addSubview:premiumTitle];
    self.premiumTitle = premiumTitle;
    premiumTitle.text = @"保费";
    
    UILabel *couponsTitle = [[UILabel alloc] init];
    [self addSubview:couponsTitle];
    self.couponsTitle = couponsTitle;
    couponsTitle.text = @"优惠券抵扣";
    
    UILabel *budgetMoney = [[UILabel alloc] init];
    [self addSubview:budgetMoney];
    self.budgetMoney = budgetMoney;
    budgetMoney.text = @"10-15元";
    budgetMoney.textAlignment = NSTextAlignmentCenter;
    budgetMoney.font = [UIFont systemFontOfSize:34];
    
    UILabel *budgetMoneyTitle = [[UILabel alloc] init];
    [self addSubview:budgetMoneyTitle];
    self.budgetMoneyTitle = budgetMoneyTitle;
    budgetMoneyTitle.text = @"预估详情";
    budgetMoneyTitle.textAlignment = NSTextAlignmentCenter;
    budgetMoneyTitle.font = [UIFont systemFontOfSize:14];
    budgetMoneyTitle.textColor = DDRGBColor(153, 153, 153);
    
    UILabel *budgetDetail = [[UILabel alloc] init];
    [self addSubview:budgetDetail];
    self.budgetDetail = budgetDetail;
    budgetDetail.text = @"预估费用规则详情>";
    budgetDetail.font = [UIFont systemFontOfSize:14];
    budgetDetail.textColor = DDRGBColor(153, 153, 153);
}

- (void)layoutSubviews
{
    self.budgetMoneyTitle.centerx = self.width/2;
    self.budgetMoneyTitle.y = 34;
    self.budgetMoneyTitle.width = 100;
    self.budgetMoneyTitle.height = 14;
    
    UILabel *titleLine1 = [[UILabel alloc] init];
    titleLine1.x = 45;
    titleLine1.y = 41;
    titleLine1.width = 100;
    titleLine1.height = 0.5;
    titleLine1.backgroundColor = DDRGBColor(233, 233, 233);
    [self addSubview:titleLine1];
    
    UILabel *titleLine2 = [[UILabel alloc] init];
    titleLine2.x = self.width -45 -100;
    titleLine2.y = 41;
    titleLine2.width = 100;
    titleLine2.height = 0.5;
    titleLine2.backgroundColor = DDRGBColor(233, 233, 233);
    [self addSubview:titleLine2];
    
    self.budgetMoney.x = 0;
    self.budgetMoney.y = self.budgetMoneyTitle.bottom + 15;
    self.budgetMoney.width = self.width;
    self.budgetMoney.height = 34;
    
    NSArray * titleArray = [[NSArray alloc] initWithObjects:self.firstHeavyTitle,self.nextHeavyTitle,self.tipTitle,self.premiumTitle,self.couponsTitle, nil];
    for (int i = 0; i < titleArray.count ; i++) {
        UILabel *label = [titleArray objectAtIndex:i];
        label.x = 45;
        label.y = 29 * i + self.budgetMoney.bottom + 30;
        label.width = 100;
        label.height = 14;
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = DDRGBColor(153, 153, 153);
        label.font = [UIFont systemFontOfSize:14];
    }
    
    NSArray * contentArray = [[NSArray alloc] initWithObjects:self.firstHeavy,self.nextHeavy,self.tip,self.premium,self.coupons, nil];
    for (int i = 0; i < contentArray.count; i++) {
        UILabel *label = [contentArray objectAtIndex:i];
        label.x = self.width - 45 - 150;
        label.y = 29 * i + self.budgetMoney.bottom + 30;
        label.width = 150;
        label.height = 14;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = DDRGBColor(51, 51, 51);
    }
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.x = self.couponsTitle.x;
    lineLabel.y = self.couponsTitle.bottom + 15;
    lineLabel.width = self.width - 90;
    lineLabel.height = 0.5;
    lineLabel.backgroundColor = DDRGBColor(233, 233, 233);
    [self addSubview:lineLabel];
    
    self.budgetDetail.x = 0;
    self.budgetDetail.y = lineLabel.bottom + 15;
    self.budgetDetail.width = self.width;
    self.budgetDetail.height = 14;
    self.budgetDetail.textAlignment = NSTextAlignmentCenter;
}
@end
