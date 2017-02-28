//
//  MyWalletViewController.m
//  WhipMe
//
//  Created by anve on 16/11/23.
//  Copyright © 2016年 -. All rights reserved.
//

#import "MyWalletViewController.h"
#import "TopUpViewController.h"
#import "CashViewController.h"
#import "WMFinancialDetailsController.h"

#define kSize_Icon 143.0
#define kButton_h 55.0

@interface MyWalletViewController ()

@property (nonatomic, strong) UIImageView *icon_wallet;
@property (nonatomic, strong) UIButton *btnTopUp, *btnCash;
@property (nonatomic, strong) UILabel *lblTitle, *lblMoney;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的钱包"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setup];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryAccountByWallet];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    DebugLog(@"%@",self.class);
}

- (void)setData {
    UserManager *info = [UserManager shared];
    
    self.lblMoney.text = [NSString stringWithFormat:@"¥%.2f",[info.wallet floatValue]];
}

- (void)setup {
    
    CGFloat originY = 90.0;
    if ([Define screenWidth] == 320.0) {
        originY = ([Define screenHeight] - 64.0 - 160.0 - 100.0 - kSize_Icon)/2.0;
    }
    WEAK_SELF
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(onClickWithRight)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    _icon_wallet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purse"]];
    [_icon_wallet setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.icon_wallet];
    [self.icon_wallet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(143.0, 143.0));
        make.top.equalTo(weakSelf.view).offset(originY);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    _lblTitle = [[UILabel alloc] init];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.textColor = [Define kColorBlack];
    _lblTitle.font = [UIFont systemFontOfSize:20.0];
    _lblTitle.text = @"余额";
    [self.view addSubview:_lblTitle];
    [_lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.icon_wallet.mas_bottom);
        make.width.equalTo(weakSelf.view).offset(-72.0);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(60.0);
    }];
    
    _lblMoney = [[UILabel alloc] init];
    _lblMoney.backgroundColor = [UIColor clearColor];
    _lblMoney.textAlignment = NSTextAlignmentCenter;
    _lblMoney.textColor = _lblTitle.textColor;
    _lblMoney.font = [UIFont systemFontOfSize:35.0];
    _lblMoney.text = @"¥0.00";
    [self.view addSubview:_lblMoney];
    [_lblMoney mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lblTitle.mas_bottom);
        make.width.equalTo(weakSelf.view).offset(-72.0);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(40.0);
    }];
    
    _btnTopUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTopUp setBackgroundColor:[Define kColorBlue]];
    [_btnTopUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnTopUp.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_btnTopUp setTitle:@"充值" forState:UIControlStateNormal];
    [_btnTopUp.layer setCornerRadius:kButton_h/2.0];
    [_btnTopUp.layer setMasksToBounds:YES];
    [_btnTopUp addTarget:self action:@selector(onClickWithTopUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnTopUp];
    [self.btnTopUp mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kButton_h);
        make.width.equalTo(weakSelf.view).offset(-72.0);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.lblMoney.mas_bottom).offset(65.0);
    }];
    
    _btnCash = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCash setBackgroundColor:[Define kColorRed]];
    [_btnCash setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnCash.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_btnCash setTitle:@"提现" forState:UIControlStateNormal];
    [_btnCash.layer setCornerRadius:kButton_h/2.0];
    [_btnCash.layer setMasksToBounds:YES];
    [_btnCash addTarget:self action:@selector(onClickWithCash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnCash];
    [self.btnCash mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kButton_h);
        make.width.equalTo(weakSelf.view).offset(-72.0);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.btnTopUp.mas_bottom).offset(25.0);
    }];
    
}

#pragma mark - Action
- (void)onClickWithRight {
    WMFinancialDetailsController *controller = [WMFinancialDetailsController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickWithTopUp:(id)sender {
    TopUpViewController *controller = [[TopUpViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickWithCash:(id)sender {
    UserManager *info = [UserManager shared];
    if ([info.wallet floatValue] <= 0) {
        [Tool showHUDTipWithTipStr:@"可提现金额为零！"];
        return;
    }
    CashViewController *controller = [[CashViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

/** 获取用户账户余额 */
- (void)queryAccountByWallet {
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"userId":user.userId ?: @""};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"queryAccountById" params:param Success:^(id result) {
        
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            CGFloat float_wallet = [data[@"account"] floatValue];
            UserManager *model = [UserManager shared];
            model.wallet = [NSString stringWithFormat:@"%.2f",float_wallet];
            [weakSelf setData];
            
            NSMutableDictionary *dict_value = [model mj_keyValues];
            [UserManager storeUserWithDict:dict_value];
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        
    }];
}

@end
