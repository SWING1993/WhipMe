//
//  WMFansAndFocusController.m
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMFansAndFocusController.h"
#import "WMAddFriendController.h"
#import "FansAndFocusModel.h"

@interface WMFansAndFocusController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) NSMutableArray<FansAndFocusModel *> *arrayContent;
@property (nonatomic, strong) NSIndexPath *selectPath;

@end

static NSString *const identifier_cell = @"fansAndFocusViewCell";
@implementation WMFansAndFocusController

- (instancetype)initWithStyle:(WMFansAndFocusStyle)style
{
    self = [super init];
    if (self) {
        _controlStyle = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Define kColorBackGround];
    if (self.controlStyle == WMFansAndFocusStyleFans) {
        self.navigationItem.title = @"我的粉丝";
    } else {
        self.navigationItem.title = @"我的关注";
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(clickWithRight)];
        rightBarItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:rightBarItem];
        
    }
    
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
    [self.tableViewWM registerClass:[MyFansAndFocusCell class] forCellReuseIdentifier:identifier_cell];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryByFocusList];
    }];
}

#pragma mark - Action
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

#pragma mark - UITableViewDelegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayContent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MyFansAndFocusCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    MyFansAndFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell];
    [cell setPath:indexPath];
    [cell setFansAndFocusCheck:^(NSIndexPath * _Nonnull path) {
        [weakSelf fansAndFocusCheck:path];
    }];
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    if (self.controlStyle == WMFansAndFocusStyleFans) {
        [cell cellWithModel:model style:model.focus];
    } else {
        [cell cellFocusWithModel:model style:model.focus];
    }
    
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

- (void)fansAndFocusCheck:(NSIndexPath *)indexPath {
    _selectPath = indexPath;
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    if ([NSString isBlankString:model.userId]) {
        return;
    }
    
    UserManager *user = [UserManager shared];
    if (model.focus == NO) {
        NSDictionary *param = @{@"me":user.userId ?: @"", @"focus":model.userId};
        [self focusAndCancelByUser:param hostPost:@"focusUser"];
    } else {
        NSDictionary *param = @{@"me":user.userId ?: @"", @"userId":model.userId};
        [self focusAndCancelByUser:param hostPost:@"cancelUser"];
    }
}

#pragma mark - set get
- (NSMutableArray<FansAndFocusModel *> *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

#pragma mark - Network
- (void)queryByFocusList {
    
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"loginId":user.userId ?: @"", @"userId":user.userId};
    
    NSString *host_post = @"queryFocusList";
    if (self.controlStyle == WMFansAndFocusStyleFans) {
        host_post = @"queryFansList";
    }
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:host_post params:param Success:^(id result) {
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
        [weakSelf.tableViewWM.mj_header endRefreshing];
        
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
        [weakSelf.tableViewWM.mj_header endRefreshing];
        DebugLog(@"%@",error);
    }];
}

@end
