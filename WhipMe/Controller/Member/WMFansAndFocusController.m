//
//  WMFansAndFocusController.m
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMFansAndFocusController.h"
#import "FansAndFocusModel.h"

@interface WMFansAndFocusController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) NSMutableArray *arrayContent;
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
    UIView *line_head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Define screenWidth], 10.0)];
    line_head.backgroundColor = [Define kColorBackGround];
    
    UIView *line_foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Define screenWidth], 10.0)];
    line_foot.backgroundColor = [Define kColorBackGround];
    
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
    _tableViewWM.tableFooterView = line_head;
    _tableViewWM.tableHeaderView = line_foot;
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0);
        make.left.mas_equalTo(10.0);
        make.right.and.bottom.mas_equalTo(-10.0);
    }];
    [self.tableViewWM registerClass:[MyFansAndFocusCell class] forCellReuseIdentifier:identifier_cell];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryByFocusList];
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
    return [MyFansAndFocusCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    MyFansAndFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell];
    [cell setPath:indexPath];
    [cell setFansAndFocusCheck:^(NSIndexPath * _Nonnull path) {
        [weakSelf fansAndFocusCheck:path];
    }];
    NSDictionary *modle = @{@"title":@"小溪漓江", @"describe":@"监督是一种责任"};
    [cell cellModelWithModel:modle style:YES];
    
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
    if (self.controlStyle == WMFansAndFocusStyleFans) {
        [Tool showHUDTipWithTipStr:@"关注成功"];
    } else {
        [Tool showHUDTipWithTipStr:@"已经取消关注！"];
    }
}

#pragma mark - set get
- (NSMutableArray *)arrayContent {
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
        DebugLog(@"______result:%@",result);
        
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
        DebugLog(@"%@",error);
    }];
}

@end
