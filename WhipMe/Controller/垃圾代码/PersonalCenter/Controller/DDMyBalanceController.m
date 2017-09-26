//
//  DDMyBalanceController.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/4/6.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDMyBalanceController.h"
#import "Constant.h"
#import "DDInterface.h"
#import "YYModel.h"
#import "DDMyBalance.h"
#import "DDWebViewController.h"
#import "DDMyBalanceCell.h"

@interface DDMyBalanceController () <UITableViewDelegate, UITableViewDataSource, DDInterfaceDelegate>

/** 余额信息tableView */
@property (nonatomic,strong) UITableView *tableView;

/** 余额信息列表 */
@property (nonatomic,strong) NSMutableArray *balanceList;

/** 网络请求 */
@property (nonatomic, strong) DDInterface *balanceInterface;

@end

@implementation DDMyBalanceController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = KBackground_COLOR;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"余额" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    [self balanceWithRequest];
    
    [self createHeadView];
    
    [self createTableView];
}
#pragma mark - Private Method

- (void)createTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.frame = CGRectMake(0, 178 + 64, MainScreenWidth, MainScreenHeight - 178 - 64);
    [tableView setBackgroundColor:KBackground_COLOR];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    UILabel *detailTitle = [[UILabel alloc] init];
    detailTitle.frame = CGRectMake(0, 178 + 64, self.view.width, 30);
    detailTitle.text = @"余额明细";
    [detailTitle setTextColor:DDRGBColor(188, 188, 188)];
    detailTitle.textAlignment = NSTextAlignmentCenter;
    [detailTitle setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:detailTitle];
}

- (void)createHeadView
{
    UIView *headView = [[UIView alloc] init];
    [headView setFrame:CGRectMake(0, KNavHeight, MainScreenWidth, 178.0f)];
    [headView setBackgroundColor:[UIColor colorWithPatternImage:ImageNamed(@"balanceBg")]];
    [self.view addSubview:headView];
    
    UIButton *ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.frame = CGRectMake(MainScreenWidth - 100, 15, 85, 14);
    ruleBtn.contentMode = UIViewContentModeCenter;
    [ruleBtn setImage:[UIImage imageNamed:@"balanceRule"] forState:UIControlStateNormal];
    [ruleBtn setTitle:@"余额规则" forState:UIControlStateNormal];
    [ruleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    ruleBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [ruleBtn setTitleColor:DDRGBColor(160, 236, 201) forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(ruleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:ruleBtn];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.frame = CGRectMake(0, 40, self.view.width, 60);
    balanceLabel.text = [NSString stringWithFormat:@"%.02f",self.totalBalance];
    [balanceLabel setTextColor:[UIColor whiteColor]];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [balanceLabel setFont:[UIFont systemFontOfSize:48]];
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:balanceLabel.text];
    [attributeString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica Light" size:48]} range:NSMakeRange(0, [balanceLabel.text length])];
    balanceLabel.attributedText = attributeString;
    [headView addSubview:balanceLabel];
    
    UILabel *commentLael = [[UILabel alloc] init];
    commentLael.frame = CGRectMake(0, CGRectGetMaxY(balanceLabel.frame), self.view.width, 18);
    commentLael.text = @"我的余额(元)";
    [commentLael setTextColor:[UIColor whiteColor]];
    commentLael.textAlignment = NSTextAlignmentCenter;
    [commentLael setFont:[UIFont systemFontOfSize:14]];
    [headView addSubview:commentLael];
}

#pragma mark -  TableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.balanceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DDMyBalanceCell";
    DDMyBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DDMyBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    DDMyBalance *balance = self.balanceList[indexPath.row];
    [cell loadMyBalanceCellWithBalance:balance];
    
    return cell;
}
#pragma mark - Event Method

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ruleButtonClick
{
    DDWebViewController *vc = [[DDWebViewController alloc]init];
    vc.URLString = BalanceMoneyRuleHtmlUrlStr;
    vc.navTitle = @"余额规则";
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Network Request
/** 我的余额 数据请求 */
- (void)balanceWithRequest
{
    if (!self.balanceInterface)
        self.balanceInterface = [[DDInterface alloc] initWithDelegate:self];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [self.balanceInterface interfaceWithType:INTERFACE_TYPE_YUE_INFOMSTION param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.balanceInterface)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            NSArray *array = result[@"yueList"];
            for (NSDictionary *dict in array) {
                DDMyBalance *myBalace = [DDMyBalance yy_modelWithDictionary:dict];
                [self.balanceList addObject:myBalace];
            }
            [self.tableView reloadData];
        }
    }
}


#pragma mark - Setter && Getter
- (NSMutableArray *)balanceList
{
    if (_balanceList == nil) {
        _balanceList = [NSMutableArray array];
    }
    return _balanceList;
}

@end
