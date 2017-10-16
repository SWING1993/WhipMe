//
//  WMSuperviseController.m
//  WhipMe
//
//  Created by youye on 17/2/20.
//  Copyright © 2017年 -. All rights reserved.
//  监督

#import "WMSuperviseController.h"
#import "SuperviseViewCell.h"

@interface WMSuperviseController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrayContent;
@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, assign) NSInteger pageIndex, pageSize;

@end

static NSString *identifier_cell = @"SuperviseViewCell";

@implementation WMSuperviseController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    [self tableViewHeaderRefresh];
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
    
    WEAK_SELF
    _tableViewWM = [UITableView new];
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewWM.separatorColor = [Define kColorLine];
    _tableViewWM.layoutMargins = UIEdgeInsetsZero;
    _tableViewWM.separatorInset = UIEdgeInsetsZero;
    _tableViewWM.backgroundColor = [UIColor clearColor];
    _tableViewWM.delegate = self;
    _tableViewWM.dataSource = self;
    _tableViewWM.tableFooterView = [UIView new];
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(kScreenH-kTabBarHeight);
    }];
    [self.tableViewWM registerClass:[SuperviseViewCell class] forCellReuseIdentifier:identifier_cell];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf tableViewHeaderRefresh];
    }];
    self.tableViewWM.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf tableViewFoorterRefresh];
    }];
    [self.tableViewWM.mj_footer setHidden:YES];
}

- (void)tableViewHeaderRefresh {
    self.pageIndex = 1;
    [self queryByNeedSupervise];
}

- (void)tableViewFoorterRefresh {
    self.pageIndex++;
    [self queryByNeedSupervise];
}

- (void)reloadTableView
{
    if (self.arrayContent.count<self.pageSize*self.pageIndex && self.arrayContent.count>=self.pageSize) {
        [self.tableViewWM.mj_footer setState:MJRefreshStateNoMoreData];
    }
    [self.tableViewWM.mj_footer setHidden:self.arrayContent.count<self.pageSize ? YES : NO];
    
    [self.tableViewWM reloadData];
}

#pragma mark - UITableViewDelegate and Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayContent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SuperviseViewCell *cell = (SuperviseViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier_cell];
    [cell setPath:indexPath];
    [cell setModel:[self.arrayContent objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ManagerIndexDetailController *controller = [ManagerIndexDetailController new];
    controller.hidesBottomBarWhenPushed = true;
    controller.myWhipM = self.arrayContent[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSMutableArray *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

- (NSInteger)pageSize {
    if (_pageSize < 10) {
        _pageSize = 10;
    }
    return _pageSize;
}

- (NSInteger)pageIndex {
    if (_pageIndex < 1) {
        _pageIndex = 1;
    }
    return _pageIndex;
}

#pragma mark - network
- (void)queryByNeedSupervise {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)self.pageIndex] forKey:@"pageIndex"];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)MAX(10, self.pageSize)] forKey:@"pageSize"];
    [dict setObject:[NSString stringWithFormat:@"%@",UserManager.shared.userId] forKey:@"userId"];
    
    WEAKSELF
    [HttpAPIClient APIClientPOST:@"needSuperviseList" params:dict Success:^(id result) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
        [weakSelf.tableViewWM.mj_footer endRefreshing];
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            [weakSelf.arrayContent removeAllObjects];
            for (NSDictionary *obj in data[@"list"]) {
                WhipM *model = [WhipM mj_objectWithKeyValues:obj];
                [weakSelf.arrayContent addObject:model];
            }
            [weakSelf reloadTableView];
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
        [weakSelf.tableViewWM.mj_footer endRefreshing];
        [Tool showHUDTipWithTipStr:@"网络不给力"];
    }];
}

@end
