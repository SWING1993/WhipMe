//
//  WMAddFriendController.m
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMAddFriendController.h"
#import "FansAndFocusModel.h"

@interface WMAddFriendController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *viewSearch;
@property (nonatomic, strong) NSMutableArray *arrayContent;
@property (nonatomic, strong) UITableView *tableViewWM;

@property (nonatomic, strong) NSIndexPath *selectPath;

@end

static NSString *identifier_cell = @"addFriendsCell";

@implementation WMAddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加好友";
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
    [self.view endEditing:NO];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    WEAK_SELF
    _viewSearch = [UISearchBar new];
    _viewSearch.backgroundColor = [UIColor whiteColor];
    _viewSearch.barTintColor = [UIColor clearColor];
    _viewSearch.barStyle = UIBarStyleBlackTranslucent;
    _viewSearch.keyboardType = UIKeyboardTypeEmailAddress;
    _viewSearch.delegate = self;
    _viewSearch.layer.cornerRadius = 25.0;
    _viewSearch.layer.masksToBounds = true;
    _viewSearch.placeholder = @"输入你想搜索的好友名称";
    [self.view addSubview:self.viewSearch];
    [self.viewSearch mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(10.0);
        make.width.mas_equalTo([Define screenWidth] - 20.0);
        make.height.mas_equalTo(50.0);
    }];
    
    //清除UISearchBar的子视图背景
    for (UIView *view in self.viewSearch.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
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
    _tableViewWM.tableFooterView = [UIView new];
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.viewSearch.mas_bottom).offset(10.0);
        make.left.mas_equalTo(10.0);
        make.right.and.bottom.mas_equalTo(-10.0);
    }];
    [self.tableViewWM registerClass:[FriendsListViewCell class] forCellReuseIdentifier:identifier_cell];

}

#pragma mark - Action
- (NSString *)nameBySearch:(NSString *)text {
    NSString *textTemp = @"卢萨卡啊开始减肥啦快点减肥啊快点减肥啊立法局卡卡里打飞机啊打飞机啊收到了开发";
    NSInteger rangeSize = 3;
    NSInteger textCount = textTemp.length - rangeSize;
    
    NSString *searchText = [textTemp substringFromIndex:arc4random()%textCount];
    return [NSString stringWithFormat:@"%@%@",text, searchText];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self queryByName:searchBar.text];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *text_str = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    if ([text_str length] > 30) {
        searchBar.text = [text_str substringToIndex:30];
        return NO;
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
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
    WEAK_SELF
    FriendsListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell];
    [cell setPath:indexPath];
    [cell setIndexCellViewPath:^(NSIndexPath * _Nonnull path) {
        [weakSelf didSelectCellIndexPath:path];
    }];

    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    [cell setCellWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelectCellIndexPath:(NSIndexPath *)indexPath {
    _selectPath = indexPath;
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    [self focusByUser:[NSString stringWithFormat:@"%@",model.userId]];
}
//    let controller : FriendsListController = FriendsListController()
//    controller.controlModel = WMFriendsListViewModel.addFriend
//    controller.hidesBottomBarWhenPushed = true
//    self.navigationController?.pushViewController(controller, animated: true)


#pragma mark - set get
- (NSMutableArray *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

#pragma mark - network
- (void)queryByName:(NSString *)userNickanme {
    if ([NSString isBlankString:userNickanme]) {
        return;
    }
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"userId":user.userId ?: @"", @"nickname":userNickanme};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"queryUserByNickname" params:param Success:^(id result) {
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

- (void)focusByUser:(NSString *)userNo {
    if ([NSString isBlankString:userNo]) {
        return;
    }
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"me":user.userId ?: @"", @"focus":userNo};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"focusUser" params:param Success:^(id result) {
        DebugLog(@"______result:%@",result);
        
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            FansAndFocusModel *model = [weakSelf.arrayContent objectAtIndex:weakSelf.selectPath.row];
            model.focus = YES;
            [weakSelf.tableViewWM reloadData];
            
            [Tool showHUDTipWithTipStr:@"关注成功！"];
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
