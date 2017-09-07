//
//  SetingViewController.m
//  WhipMe
//
//  Created by anve on 16/11/24.
//  Copyright © 2016年 -. All rights reserved.
//

#import "SetingViewController.h"
#import "WMUserInfoViewController.h"
#import "WMLoginManagerController.h"
#import "WMExitAlertView.h"
#import "WMBlackListManagerController.h"

static NSString *identifier_cell = @"setingTableViewCell";

@interface SetingViewController () <UITableViewDelegate, UITableViewDataSource, WMExitAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) UserManager *userModel;
@property (nonatomic, assign) BOOL isManager;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Define kColorBackGround];
    self.navigationItem.title = @"设置";
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _userModel = [UserManager shared];
    _isManager = [self.userModel.supervisor integerValue] > 0 ? YES : NO;
//    _isManager = YES;
    [self.tableViewWM reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    _tableViewWM = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableViewWM.backgroundColor = [UIColor clearColor];
    _tableViewWM.delegate = self;
    _tableViewWM.dataSource = self;
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewWM.separatorColor = [Define kColorLine];
    _tableViewWM.separatorInset = UIEdgeInsetsZero;
    _tableViewWM.layoutMargins = UIEdgeInsetsZero;
    _tableViewWM.tableFooterView = [UIView new];
    [self.view addSubview:_tableViewWM];
    [_tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view);
    }];
    
    [_tableViewWM registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:identifier_cell];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isManager ? 7 : 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0.0;
    NSInteger rowManager = self.isManager ? 5 : 4;
    if (indexPath.row == 0) {
        rowHeight = 10.0;
    } else if (indexPath.row == 2 || indexPath.row == rowManager) {
        rowHeight = 12.0;
    } else if (indexPath.row == 1) {
        rowHeight = 75.0;
    } else {
        rowHeight = 48.0;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier_cell];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_cell];
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell.imageLogo setHidden:YES];
    [cell.lblText setHidden:NO];
    cell.lblTitle.textAlignment = NSTextAlignmentLeft;
    cell.lblTitle.textColor = [Define kColorBlack];
    
    CGFloat margin_x = 0.0;
    if (indexPath.row == 1) {
        cell.lblTitle.text = @"编辑个人资料";
        cell.lblText.hidden = true;
        cell.imageLogo.hidden = false;
        cell.imageLogo.backgroundColor = [Define kColorBackGround];
        if ([NSString isBlankString:self.userModel.icon]) {
            cell.imageLogo.image = [Define kDefaultImageHead];
        } else {
            [cell.imageLogo setImageWithURL:[NSURL URLWithString:self.userModel.icon] placeholderImage:[Define kDefaultImageHead]];
        }
    } else if (indexPath.row == 3) {
        cell.lblTitle.text = @"黑名单管理";
        margin_x = 15.0;
    } else if (indexPath.row == 4) {
        if (self.isManager == NO) {
            cell.lblTitle.text = @"";
            cell.backgroundColor = [UIColor clearColor];
        } else {
            cell.lblTitle.text = @"管理员登录";
        }
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        cell.lblTitle.text = @"退出登录";
        cell.lblTitle.textColor = [Define kColorRed];
        cell.lblTitle.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.lblTitle.text = @"";
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.layoutMargins = UIEdgeInsetsMake(0, margin_x, 0, 0);
    cell.separatorInset = UIEdgeInsetsMake(0, margin_x, 0, 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if (indexPath.row == 1) {
        WMUserInfoViewController *controller = [[WMUserInfoViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 3) {
        WMBlackListManagerController *controller = [[WMBlackListManagerController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.row == 4) {
//        WMWebViewController *controller = [[WMWebViewController alloc] initWithWebType:WMWebViewTypeHelpCenter];
//        [self.navigationController pushViewController:controller animated:YES];
//    } else if (indexPath.row == 5) {
//        WMWebViewController *controller = [[WMWebViewController alloc] initWithWebType:WMWebViewTypeLocal];
//        [self.navigationController pushViewController:controller animated:YES];
//    } else if (indexPath.row == 6) {
        if (self.isManager == YES) {
            WMLoginManagerController *controller = [WMLoginManagerController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        WEAK_SELF
        UIAlertController *alertExit = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertExit addAction:[UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf clickWithLogout];
        }]];
        [alertExit addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertExit animated:YES completion:nil];
    }
}

- (void)clickWithLogout {
    [UserManager removeData];
    [JMSGUser logout:^(id resultObject, NSError *error) {
    }];
    [WMUploadFile removeQiniuUpKey];
    
    AppDelegate *appDegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDegate setupMainController];
}

#pragma mark - WMExitAlertViewDelegate
- (void)exitAlertView:(WMExitAlertView *)alertView buttonIndex:(NSInteger)hvState {
    if (hvState == 0) {
        [self clickWithLogout];
    } else if (hvState == 1) {
    
    }
}

@end
