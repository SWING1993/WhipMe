//
//  SetingViewController.m
//  WhipMe
//
//  Created by anve on 16/11/24.
//  Copyright © 2016年 -. All rights reserved.
//

#import "SetingViewController.h"
#import "WMUserInfoViewController.h"

static NSString *identifier_cell = @"setingTableViewCell";

@interface SetingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) UserManager *userModel;

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0.0;
    if (indexPath.row == 0) {
        rowHeight = 10.0;
    } else if (indexPath.row == 2 || indexPath.row == 6) {
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
        cell.imageLogo.image = [UIImage fullToFilePath:self.userModel.icon];
    } else if (indexPath.row == 3) {
        cell.lblTitle.text = @"帮助中心";
        margin_x = 15.0;
    } else if (indexPath.row == 4) {
        cell.lblTitle.text = @"关于鞭挞我";
        margin_x = 15.0;
    } else if (indexPath.row == 5) {
        cell.lblTitle.text = @"管理员登录";
    } else if (indexPath.row == 7) {
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
        
    } else if (indexPath.row == 4) {
        
        
    } else if (indexPath.row == 5) {
        
    } else if (indexPath.row == 7) {
        UIAlertController *alertExit = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertExit addAction:[UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertExit addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertExit animated:YES completion:nil];
    }
}


@end
