//
//  WMAddFriendController.m
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMAddFriendController.h"
#import "FansAndFocusModel.h"

//DZNEmptyDataSetDelegate, DZNEmptyDataSetSource
@interface WMAddFriendController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *viewSearch;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) NSMutableArray *arrayContent;
@property (nonatomic, strong) UITableView *tableViewWM;

@property (nonatomic, strong) NSIndexPath *selectPath;

@end

static NSString *identifier_cell = @"addFriendsCell";

@implementation WMAddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加关注";
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
    _viewSearch = [UITextField new];
    _viewSearch.backgroundColor = [UIColor whiteColor];
    _viewSearch.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 50.0)];
    [leftView setBackgroundColor:[UIColor clearColor]];
    [self.viewSearch setLeftView:leftView];
    [self.viewSearch setLeftViewMode:UITextFieldViewModeAlways];
    
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel setFrame:CGRectMake(0, 0, 50.0, 50.0)];
    [_btnCancel setBackgroundColor:[UIColor clearColor]];
    [_btnCancel setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [_btnCancel setAdjustsImageWhenHighlighted:false];
    [_btnCancel addTarget:self action:@selector(clickWithCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.viewSearch setRightView:self.btnCancel];
    [self.viewSearch setRightViewMode:UITextFieldViewModeAlways];
    
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
//    _tableViewWM.emptyDataSetSource = self;
//    _tableViewWM.emptyDataSetDelegate = self;
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

- (void)clickWithCancel {
    [self.viewSearch resignFirstResponder];
    [self queryByName:self.viewSearch.text];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self queryByName:textField.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([text_str length] > 30) {
        textField.text = [text_str substringToIndex:30];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

//#pragma mark - DZNEmptyDataSetSource
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"no_data"];
//}
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgb(212.0, 212.0, 212.0)};
//    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"暂无数据哦！" attributes:attribute];
//    return string;
//}
//
//- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
//    return YES;
//}

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
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    if ([NSString isBlankString:model.userId]) {
        return;
    }
//    QueryUserBlogC *controller = [[QueryUserBlogC alloc] init];
//    [controller.navigationItem setTitle:model.nickname];
//    [controller queryByUserBlogWithUserNo:model.userId];
//    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)didSelectCellIndexPath:(NSIndexPath *)indexPath {
    _selectPath = indexPath;
    FansAndFocusModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    [self focusByUser:[NSString stringWithFormat:@"%@",model.userId]];
}

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
    NSDictionary *param = @{@"me":user.userId ?: @"", @"focus":userNo, @"nickname":user.nickname};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"focusUser" params:param Success:^(id result) {
        
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
