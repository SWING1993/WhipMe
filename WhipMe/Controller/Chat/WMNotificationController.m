//
//  WMNotificationController.m
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMNotificationController.h"
#import "NotificationModel.h"
#import "WMNotificationViewCell.h"

@interface WMNotificationController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray<NotificationModel *> *arrayContent;
@property (nonatomic, strong) UITableView *tableViewWM;

@end

static NSString *identifier_cell = @"notificationViewCell";
@implementation WMNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Define kColorBackGround]];
    
    [self setup];
    
    [self queryByNotification];
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
    _tableViewWM.emptyDataSetSource = self;
    _tableViewWM.emptyDataSetDelegate = self;
    _tableViewWM.tableFooterView = [UIView new];
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(weakSelf.view);
        make.width.mas_equalTo([Define screenWidth]);
        make.height.mas_equalTo([Define screenHeight]-64.0 - 49.0);
    }];
    [self.tableViewWM registerClass:[WMNotificationViewCell class] forCellReuseIdentifier:identifier_cell];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryByNotification];
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

#pragma mark - UITableViewDelegate and Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayContent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    return [WMNotificationViewCell cellHeight:model.content];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WMNotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell];
    
    NotificationModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    [cell setCellModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.arrayContent count] > indexPath.row) {
            NotificationModel *model = [self.arrayContent objectAtIndex:indexPath.row];
            [self deleteNofificaiton:model];
        }
    }
}


#pragma mark - set get
- (NSMutableArray<NotificationModel *> *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
        
//        for (NSInteger i=0; i<20; i++) {
//            NSString *id_str = [NSString stringWithFormat:@"1013101%ld%ld",(long)arc4random()%10,(long)arc4random()%10];
//            NSDictionary *dict = @{@"nid":id_str,@"content":@"前阵子，万众瞩目的《琅琊榜2》放出了大波剧照，黄晓明一身戎装，帅到飞起，令人眼前一亮。",@"createDate":@"2017-01-14 12:30:00"};
//            NotificationModel *model = [NotificationModel mj_objectWithKeyValues:dict];
//            [_arrayContent addObject:model];
//        }
    }
    return _arrayContent;
}
#pragma mark - network
- (void)queryByNotification {
    
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"loginId":user.userId ?: @""};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"queryNotification" params:param Success:^(id result) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
        DebugLog(@"______result:%@",result);
        
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            [weakSelf.arrayContent removeAllObjects];
            for (NSDictionary *obj in data[@"list"]) {
                NotificationModel *model = [NotificationModel mj_objectWithKeyValues:obj];
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

/** 当一次删除多个通知时，以英文逗号作为分隔符，比如 通知编号1,通知编号2 */
- (void)deleteNofificaiton:(NotificationModel *)model {
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",model.nid]]) {
        return;
    }
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"loginId":user.userId ?:@"", @"nid":[NSString stringWithFormat:@"%@",model.nid]};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"removeNotification" params:param Success:^(id result) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
        DebugLog(@"______result:%@",result);
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] integerValue] == 0) {
            [Tool showHUDTipWithTipStr:@"删除成功！"];
            
            [weakSelf.arrayContent removeObject:model];
            [weakSelf.tableViewWM reloadData];
        } else {
            [Tool showHUDTipWithTipStr:data[@"desc"]];
        }
    } Failed:^(NSError *error) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
    }];
}


@end
