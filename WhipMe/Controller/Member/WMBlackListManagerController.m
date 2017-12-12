//
//  WMBlackListManagerController.m
//  WhipMe
//
//  Created by youye on 17/4/1.
//  Copyright © 2017年 -. All rights reserved.
//  黑名单管理

#import "WMBlackListManagerController.h"
#import "BlackListManagerViewCell.h"

@interface WMBlackListManagerController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, BlackListManagerViewCellDelegate>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) NSMutableArray<FansAndFocusModel *> *arrayContent;

@end

@implementation WMBlackListManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Define kColorBackGround];
    [self.navigationItem setTitle:@"黑名单管理"];
    
    [self setup];
    [self queryByBlackist];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    
    WEAK_SELF
    _tableViewWM = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableViewWM.backgroundColor = [UIColor clearColor];
    _tableViewWM.delegate = self;
    _tableViewWM.dataSource = self;
    _tableViewWM.emptyDataSetSource = self;
    _tableViewWM.emptyDataSetDelegate = self;
    _tableViewWM.layer.cornerRadius = 4.0;
    _tableViewWM.layer.masksToBounds = true;
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewWM.tableFooterView = [UIView new];
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.tableViewWM registerClass:[BlackListManagerViewCell class] forCellReuseIdentifier:[BlackListManagerViewCell cellReuseIdentifier]];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryByBlackist];
    }];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgb(212.0, 212.0, 212.0)};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"暂无数据哦！" attributes:attribute];
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
    return self.arrayContent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BlackListManagerViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlackListManagerViewCell *cell = (BlackListManagerViewCell *)[tableView dequeueReusableCellWithIdentifier:[BlackListManagerViewCell cellReuseIdentifier]];
    
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    [cell setModel:model];
    [cell setDelegate:self];
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    if ([NSString isBlankString:model.userId]) {
        return;
    }
//    QueryUserBlogC *controller = [[QueryUserBlogC alloc] init];
//    [controller.navigationItem setTitle:model.nickname];
//    [controller queryByUserBlogWithUserNo:model.userId];
//    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - BlackListManagerViewCellDelegate
- (void)blackListManagerViewCellWithCheck:(BlackListManagerViewCell *)cell {
    if (cell == nil) {
        return;
    }
    
    WEAKSELF
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"移除黑名单" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSIndexPath *indexPath = [weakSelf.tableViewWM indexPathForCell:cell];
        [weakSelf removeUserToBlack:indexPath];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)removeUserToBlack:(NSIndexPath *)indexPath {
    WEAKSELF
    FansAndFocusModel *model = [weakSelf.arrayContent objectAtIndex:indexPath.row];
    [JMSGUser delUsersFromBlacklist:[NSArray arrayWithObject:model.userId ?:@""] completionHandler:^(id resultObject, NSError *error) {
    }];
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"loginId":user.userId ?:@"", @"userId":model.userId ?:@""};
    
    [HttpAPIClient APIClientPOST:@"removeBlack" params:param Success:^(id result) {
        
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            [Tool showHUDTipWithTipStr:@"成功移除黑名单！"];
            UITableViewCell *cell = [weakSelf.tableViewWM cellForRowAtIndexPath:indexPath];
            if (cell) {
                [weakSelf.arrayContent removeObjectAtIndex:indexPath.row];
                [weakSelf.tableViewWM deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [weakSelf.tableViewWM reloadData];
            }
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        DebugLog(@"%@",error);
    }];
}

#pragma mark - set get
- (NSMutableArray<FansAndFocusModel *> *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

#pragma mark - network
- (void)queryByBlackist {
    
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"loginId":user.userId ?: @""};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"queryBlackList" params:param Success:^(id result) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
        
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            [weakSelf.arrayContent removeAllObjects];
            for (NSDictionary *obj in data[@"list"]) {
                FansAndFocusModel *model = [FansAndFocusModel mj_objectWithKeyValues:obj];
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
    }];
}

@end
