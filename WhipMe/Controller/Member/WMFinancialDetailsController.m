//
//  WMFinancialDetailsController.m
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMFinancialDetailsController.h"
#import "MoneyRecordModel.h"

@interface WMFinancialDetailsController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) NSMutableArray *arrayContent;

@end

static NSString *const identifier_cell = @"financialDetailsCell";
@implementation WMFinancialDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"明细";
    self.view.backgroundColor = [Define kColorBackGround];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    UIView *line_head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Define screenWidth], 10.0)];
    line_head.backgroundColor = [Define kColorBackGround];
    
    UIView *line_foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Define screenWidth], 10.0)];
    line_foot.backgroundColor = [Define kColorBackGround];
    
    WEAK_SELF
    _tableViewWM = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableViewWM.backgroundColor = [UIColor clearColor];
    _tableViewWM.delegate = self;
    _tableViewWM.dataSource = self;
    _tableViewWM.emptyDataSetDelegate = self;
    _tableViewWM.emptyDataSetSource = self;
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewWM.tableFooterView = line_head;
    _tableViewWM.tableHeaderView = line_foot;
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.tableViewWM registerClass:[FinancialDetailsCell class] forCellReuseIdentifier:identifier_cell];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf qureyByMoneyList];
    }];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"nilTouSu"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgb(212.0, 212.0, 212.0)};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:attribute];
    return string;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - UITableViewDelegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FinancialDetailsCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    FinancialDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell];
    
    MoneyRecordModel *model = [self.arrayContent objectAtIndex:indexPath.row];
//    NSDictionary *model = @{@"title":@"充值", @"time":@"2016-11-18 13:56:12",@"money":@"30",@"type":@"1"};
    
    cell.lblTime.text = model.createDate;
    NSString *str = @"";
    if (model.type == 0) {
        str = @"+";
        cell.lblTitle.text = @"充值";
        cell.lblMoney.textColor = [Define kColorBlue];
    } else {
        str = @"-";
        cell.lblTitle.text = @"提现";
        cell.lblMoney.textColor = [Define kColorBlack];
    }
    cell.lblMoney.text = [NSString stringWithFormat:@"%@%.2f",str,[model.amount floatValue]];
    
    if (indexPath.row+1 == [tableView numberOfRowsInSection:indexPath.section]) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - set get
- (NSMutableArray *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

#pragma mark - Network
- (void)qureyByMoneyList {
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"userId":user.userId ?: @""};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"queryMoneyHis" params:param Success:^(id result) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
        DebugLog(@"______result:%@",result);
        
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            [weakSelf.arrayContent removeAllObjects];
            for (NSDictionary *obj in data[@"list"]) {
                MoneyRecordModel *model = [MoneyRecordModel mj_objectWithKeyValues:obj];
                [weakSelf.arrayContent addObject:model];
            }
            [weakSelf.tableViewWM reloadData];
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
        DebugLog(@"%@",error);
    }];
}

@end
