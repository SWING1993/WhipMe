//
//  WMFansAndFocusController.m
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMFansAndFocusController.h"
#import "FansAndFocusModel.h"

@interface WMFansAndFocusController () <UITableViewDelegate, UITableViewDataSource>

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
    [self qureyBySupervisor];
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
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewWM.tableFooterView = line_head;
    _tableViewWM.tableHeaderView = line_foot;
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.tableViewWM registerClass:[MyFansAndFocusCell class] forCellReuseIdentifier:identifier_cell];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf qureyBySupervisor];
    }];
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
    
    MyFansAndFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell];
    
//    NSDictionary *modle = @{@"title":@"小溪漓江", @"describe":@"监督是一种责任"};
    
//    cell.cellModel(model: model, style: self.style)
//    cell.delegate = self
    
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


- (void)fansAndFocusCheck {
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
- (void)qureyBySupervisor {
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"userId":user.userId ?: @""};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"querySupervisor" params:param Success:^(id result) {
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
        DebugLog(@"%@",error);
    }];
}

@end
