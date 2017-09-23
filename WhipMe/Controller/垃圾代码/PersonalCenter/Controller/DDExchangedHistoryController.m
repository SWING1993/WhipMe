//
//  DDExchangedHistoryController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDExchangedHistoryController.h"
#import "Constant.h"

@interface DDExchangedHistoryController () <DDInterfaceDelegate, UITableViewDataSource, UITableViewDelegate>

/** 我的优惠劵列表 */
@property (nonatomic, strong) UITableView *historyTableView;
/**
 *  网络请求
 */
@property (nonatomic, strong) DDInterface *interExchangedHistory;

/**  兑换记录数组  */
@property (nonatomic, strong) NSMutableArray *couponHistoryArr;

@end

@implementation DDExchangedHistoryController
@synthesize historyTableView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        /** 兑换记录 网络请求 */
        [self historyWithRequest];
    }
    return self;
}





/** 兑换记录 网络请求 */
- (void)historyWithRequest
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (!self.interExchangedHistory)
    {
        self.interExchangedHistory = [[DDInterface alloc] initWithDelegate:self];
    }
    
    [self.interExchangedHistory interfaceWithType:INTERFACE_TYPE_EXCHANGE_HISTORY param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interExchangedHistory)
    {
        NSLog(@"_________兑换记录");
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
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"兑换记录" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    historyTableView = [[UITableView alloc] init];
    [historyTableView setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
    [historyTableView setBackgroundColor:KBackground_COLOR];
    [historyTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [historyTableView setDelegate:self];
    [historyTableView setDataSource:self];
    [self.view addSubview:historyTableView];
    
}

#pragma mark - Table view 数据源及代理方法
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
    return 2;
}


/**
    设置 tableView 的 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"coinCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell addSubview:[self createCellView]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView *) createCellView
{
    UIView * view = [[UIView alloc] init];
    view.x = 0;
    view.y = 0;
    view.width = self.view.width;
    view.height = 100;
    view.backgroundColor = DDRGBColor(255, 255, 255);
    
    UILabel * titleLabel = [[UILabel alloc] init];
    UILabel * contentLabel = [[UILabel alloc] init];
    UILabel * dateLabel = [[UILabel alloc] init];
    [view addSubview:titleLabel];
    [view addSubview:contentLabel];
    [view addSubview:dateLabel];
    
    titleLabel . text = @"艾特小哥优惠券";
    titleLabel . textColor = DDRGBColor(51 , 51 , 51);
    titleLabel . font = [UIFont systemFontOfSize:16];
    
    contentLabel . text = @"已发送，到“我的优惠券”";
    contentLabel . textColor = DDRGBColor(153 , 153 , 153);
    contentLabel . font = [UIFont systemFontOfSize:14];
    
    dateLabel . text = @"2014-10-29 20:09";
    dateLabel . textColor = DDRGBColor(153 , 153 , 153);
    dateLabel . font = [UIFont systemFontOfSize:12];
    
    CGSize titleSize = [self sizeOfString:titleLabel.text withFont:titleLabel.font];
    CGSize contentSize = [self sizeOfString:contentLabel.text withFont:contentLabel.font];
    CGSize dateSize = [self sizeOfString:dateLabel.text withFont:dateLabel.font];
    
    titleLabel.width = titleSize.width;
    titleLabel.height = titleSize.height;
    
    contentLabel.width = contentSize.width;
    contentLabel.height = contentSize.height;
    
    dateLabel.width = dateSize.width;
    dateLabel.height = dateSize.height;
    
    titleLabel . x = 15;
    titleLabel . y = (view.height - 16 - 8 - titleLabel.height - contentLabel.height - dateLabel.height)/2;
    
    contentLabel.x =15;
    contentLabel.y = titleLabel.y + titleLabel.height + 16;
    
    dateLabel.x = 15;
    dateLabel.y = contentLabel.y + contentLabel.height + 8;
    
    
    UILabel * moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"+17";
    moneyLabel.font = [UIFont systemFontOfSize:24];
    moneyLabel.textColor = DDRGBColor(32, 198, 138);
    CGSize moneySize = [self sizeOfString:moneyLabel.text withFont:moneyLabel.font];
    moneyLabel.width = moneySize.width;
    moneyLabel.height = moneySize.height;
    moneyLabel . x = view.width - 15 - moneyLabel.width;
    moneyLabel . y = (view.height - moneyLabel.height)/2;
    [view addSubview:moneyLabel];
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel . x = 0;
    lineLabel . y = view.height - 0.5;
    lineLabel . width = view.width;
    lineLabel . height = 0.5;
    lineLabel.backgroundColor = DDRGBColor(233, 233, 233);
    [view addSubview:lineLabel];
    
    return view;
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


- (NSMutableArray *)couponHistoryArr
{
    if (_couponHistoryArr == nil) {
        _couponHistoryArr = [[NSMutableArray alloc]init];
    }
    return _couponHistoryArr;
}

@end
