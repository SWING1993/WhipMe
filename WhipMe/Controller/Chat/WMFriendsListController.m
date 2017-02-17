//
//  WMFriendsListController.m
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMFriendsListController.h"
#import "WMAddFriendController.h"
#import "JCHATConversationViewController.h"

@interface WMFriendsListController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray *arrayContent;
@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) NSIndexPath *selectPath;

@end

static NSString *identifier_cell = @"addFriendsCell";

@implementation WMFriendsListController

- (instancetype)initWithStyle:(WMFriendsListStyle)style
{
    self = [super init];
    if (self) {
        _controlStyle = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.controlStyle == WMFriendsListStyleAddFriend ? @"添加关注" : @"关注列表";
    self.view.backgroundColor = [Define kColorBackGround];
    
    [self setup];
    
    [self queryByFocusList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:NO];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(clickWithRight)];
    rightBarItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    WEAK_SELF
    _tableViewWM = [UITableView new];
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewWM.separatorColor = [Define kColorLine];
    _tableViewWM.layoutMargins = UIEdgeInsetsZero;
    _tableViewWM.separatorInset = UIEdgeInsetsZero;
    _tableViewWM.backgroundColor = [UIColor whiteColor];
    _tableViewWM.layer.cornerRadius = 4.0;
    _tableViewWM.layer.masksToBounds = true;
    _tableViewWM.delegate = self;
    _tableViewWM.dataSource = self;
    _tableViewWM.emptyDataSetSource = self;
    _tableViewWM.emptyDataSetDelegate = self;
    _tableViewWM.tableFooterView = [UIView new];
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.tableViewWM registerClass:[FriendsListViewCell class] forCellReuseIdentifier:identifier_cell];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryByFocusList];
    }];
}

- (void)clickWithRight {
    WMAddFriendController *controller = [WMAddFriendController new];
    [self.navigationController pushViewController:controller animated:YES];
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

#pragma mark - UITableViewDelegate and Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayContent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WEAK_SELF
    FriendsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell];
//    [cell setPath:indexPath];
//    [cell setIndexCellViewPath:^(NSIndexPath * _Nonnull path) {
//        [weakSelf didSelectCellIndexPath:path];
//    }];
    
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    [cell setCellFriendWithModel:model];
    [cell.btnStatus setHidden:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    if ([NSString isBlankString:model.userId]) {
        return;
    }
    __block JCHATConversationViewController *controller = [[JCHATConversationViewController alloc] init];
    controller.superViewController = self;
    controller.hidesBottomBarWhenPushed = YES;
    
    WEAKSELF
    [JMSGConversation createSingleConversationWithUsername:model.userId completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            controller.conversation = resultObject;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    }];
    
}

- (void)didSelectCellIndexPath:(NSIndexPath *)indexPath {
    _selectPath = indexPath;
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    
    UserManager *user = [UserManager shared];
    if (model.focus == NO) {
        if ([NSString isBlankString:model.userId] || [NSString isBlankString:model.nickname]) {
            return;
        }
        NSDictionary *param = @{@"me":user.userId ?: @"", @"focus":model.userId, @"nickname":model.nickname};
        [self focusAndCancelByUser:param hostPost:@"focusUser"];
    } else {
        if ([NSString isBlankString:model.userId]) {
            return;
        }
        NSDictionary *param = @{@"me":user.userId ?: @"", @"focus":model.userId};
        [self focusAndCancelByUser:param hostPost:@"cancelUser"];
    }
}

#pragma mark - set get
- (NSMutableArray *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

#pragma mark - network
- (void)queryByFocusList {
  
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"loginId":user.userId ?: @"", @"userId":user.userId};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"queryFocusList" params:param Success:^(id result) {
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

- (void)focusAndCancelByUser:(NSDictionary *)param hostPost:(NSString *)host_path {
    if (param == nil || [NSString isBlankString:host_path]) {
        return;
    }
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:host_path params:param Success:^(id result) {
        
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            FansAndFocusModel *model = [weakSelf.arrayContent objectAtIndex:weakSelf.selectPath.row];
            model.focus = !model.focus;
            [weakSelf.tableViewWM reloadData];
            
            [Tool showHUDTipWithTipStr:model.focus?@"关注成功！":@"成功取消关注！"];
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        DebugLog(@"%@",error);
    }];
}

@end
