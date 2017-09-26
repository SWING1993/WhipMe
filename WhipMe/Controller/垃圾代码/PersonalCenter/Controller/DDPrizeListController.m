//
//  DDPrizeListController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDPrizeListController.h"
#import "DDRecommendPrize.h"
#import "Constant.h"

#define DDPrizeListCellHeight 184

@interface DDPrizeListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *prizeTableView;
/** 奖励明细数据模型列表 */
@property (nonatomic, strong) NSArray *prizeList;

@end

@implementation DDPrizeListController

#pragma mark - 懒加载
- (NSArray *)prizeList
{
    if (_prizeList == nil) {
        NSArray *arrayList = [NSArray arrayWithContentsOfFile:DDMainBundle(@"recommendPrize.plist")];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (NSDictionary *dict in arrayList) {
            [arrayM addObject:[DDRecommendPrize recommendPrizeWithDict:dict]];
        }
        _prizeList = arrayM;
    }
    return _prizeList;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"奖励明细" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    /** 创建表格 */
    [self ddCreateForTableView];
}

/** 创建表格 */
- (void)ddCreateForTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setFrame:CGRectMake(0, 64, self.view.width, self.view.height - KNavHeight)];
    [tableView setBackgroundColor:KBackground_COLOR];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setAllowsSelection:false];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    self.prizeTableView = tableView;
}

#pragma mark - tableView 数据源及代理方法
/**
    设置 tableView 的 section 数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/**
    设置 tableView 的 cell 数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.prizeList.count;
    
}

/**
    设置 tableView 的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"prizeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    //奖励明细数据模型
//    DDRecommendPrize *prize = self.prizeList[indexPath.row];
//    
//    //设置cell的具体内容
//    cell.textLabel.text = prize.prizeCause;
//    cell.detailTextLabel.text = prize.prizeDate;
//    
//    //设置cell的accessoryView
//    UILabel *valueLabel = [[UILabel alloc] init];
//    valueLabel.width = 150;
//    valueLabel.height = cell.height;
//    valueLabel.textAlignment = NSTextAlignmentRight;
//    valueLabel.text = [NSString stringWithFormat:@"+ %ld 元优惠券",prize.couponValue];
//    cell.accessoryView = valueLabel;
    [cell addSubview:[self createCellView]];
    
    return cell;
}

- (UIView *) createHeadView
{
    UIView * view = [[UIView alloc] init];
    view.x = 0;
    view.y = 0;
    view.width = self.view.width;
    view.height = 189;
    view.backgroundColor = DDRGBColor(255, 255, 255);
    
    UIButton * button = [[UIButton alloc] init];
    button.x = (self.view.width - 105)/2;
    button.y = 42;
    button.width = 105;
    button.height = 105;
    [button.layer setCornerRadius:button.height/2];
    button.backgroundColor = DDRGBColor(32, 198, 122);
    [view addSubview:button];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    UILabel *sumLabel = [[UILabel alloc] init];
    
    moneyLabel.text = @"12.00";
    moneyLabel.textColor = DDRGBColor(255, 255, 255);
    moneyLabel.font = [UIFont systemFontOfSize:29];
    
    sumLabel.text = @"总计";
    sumLabel.textColor = DDRGBColor(255, 255, 255);
    sumLabel.font = [UIFont systemFontOfSize:16];
    
    CGSize moneySize = [self sizeOfString:moneyLabel.text withFont:moneyLabel.font];
    CGSize sumSize = [self sizeOfString:sumLabel.text withFont:sumLabel.font];
    
    moneyLabel.width = moneySize.width;
    moneyLabel.height = moneySize.height;
    sumLabel.width = sumSize.width;
    sumLabel.height = sumSize.height;
    
    moneyLabel . x = (button.width - moneyLabel.width)/2;
    sumLabel . x = (button.width - sumLabel.width)/2;
    moneyLabel.y = (button.height - 9 - moneyLabel.height - sumLabel.height)/2;
    sumLabel.y = moneyLabel.y + moneyLabel.height + 9;
    [button addSubview:moneyLabel];
    [button addSubview:sumLabel];
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.x = 0;
    lineLabel.y = view.height;
    lineLabel.width = view.width;
    lineLabel.height = 0.5f;
    lineLabel.backgroundColor = DDRGBColor(233, 233, 233);
    [view addSubview:lineLabel];
    
    return view;
}

- (UIView *) createCellView
{
    UIView * view = [[UIView alloc] init];
    view.x = 0;
    view.y = 0;
    view.width = self.view.width;
    view.height = 66;
    view.backgroundColor = DDRGBColor(255, 255, 255);
    
    UILabel * contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"成功推荐用户章三";
    contentLabel.textColor = DDRGBColor(51, 51, 51);
    contentLabel.font = [UIFont systemFontOfSize:14];
    UILabel * dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"2014-01-23";
    dateLabel.textColor = DDRGBColor(153, 153, 153);
    dateLabel.font = [UIFont systemFontOfSize:12];
    
    CGSize contentSize = [self sizeOfString:contentLabel.text withFont:contentLabel.font];
    contentLabel.width = contentSize.width;
    contentLabel.height = contentSize.height;
    
    CGSize dateSize = [self sizeOfString:dateLabel.text withFont:dateLabel.font];
    dateLabel.width = dateSize.width;
    dateLabel.height = dateSize.height;
    
    contentLabel . x = 15;
    dateLabel . x = 15;
    contentLabel . y = (view.height - contentLabel.height - dateLabel.height - 12)/2;
    dateLabel . y =  contentLabel.y + contentLabel.height + 12;
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.x = 0;
    lineLabel.y = view.height;
    lineLabel.width = view.width;
    lineLabel.height = 0.5f;
    lineLabel.backgroundColor = DDRGBColor(233, 233, 233);
    
    UILabel * moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"+7";
    moneyLabel.font = [UIFont systemFontOfSize:16];
    moneyLabel.textColor = DDRGBColor(32, 198, 122);
    
    CGSize moneySize = [self sizeOfString:moneyLabel.text withFont:moneyLabel.font];
    moneyLabel.width = moneySize.width;
    moneyLabel.height = moneySize.height;
    moneyLabel.x = view.width - 15 - moneyLabel.width;
    moneyLabel.y = (view.height - moneyLabel.height)/2;
    
    [view addSubview:contentLabel];
    [view addSubview:dateLabel];
    [view addSubview:lineLabel];
    [view addSubview:moneyLabel];
    
    return view;
}
/**
    设置 tableView 的 header
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //设置header内的View
//    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
//    
//    //添加Label到header上,设置label的具体属性
//    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.opaque = NO;
//    
//    //headerLabel.textColor = [UIColor lightGrayColor];
//    headerLabel.highlightedTextColor = [UIColor whiteColor];
//    headerLabel.font = [UIFont systemFontOfSize:12];
//    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
//    
//    //计算总共获取的优惠券数
//    NSInteger totalPrize = 0;
//    for (DDRecommendPrize *prize in self.prizeList) {
//        totalPrize += prize.couponValue;
//    }
//    
//    //对数值进行字体放大
//    NSString *strValue = [NSString stringWithFormat:@"%ld.00",totalPrize];
//    NSString *strTotal = [NSString stringWithFormat:@"您已获得优惠券奖励 %@ 元",strValue];
//    NSRange rangeValue = [strTotal rangeOfString:strValue];
//    NSMutableAttributedString *attHeader = [[NSMutableAttributedString alloc] initWithString:strTotal];
//    [attHeader addAttribute:NSFontAttributeName value:kContentFont range:rangeValue];
//    [headerLabel setAttributedText:attHeader];
//    
//    
//    [customView addSubview:headerLabel];
    
//    return customView;
    return  [self createHeadView];
}

/**
    设置 header 的高度
 */
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DDPrizeListCellHeight + 1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
/**
 计算字符串的size
 */
- (CGSize) sizeOfString : (NSString *) string withFont: (UIFont *) fnt
{
    CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    return size;
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
