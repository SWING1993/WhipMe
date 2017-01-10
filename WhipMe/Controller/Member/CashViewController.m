//
//  CashViewController.m
//  WhipMe
//
//  Created by anve on 16/11/23.
//  Copyright © 2016年 -. All rights reserved.
//  提现

#import "CashViewController.h"
#import "NSString+Common.h"
#import "NSString+Validate.h"
#import "ShareEngine.h"

@interface CashViewController () <UITextFieldDelegate, WXApiEngineDelegate>

@property (nonatomic, strong) UIView *viewCurrent;
@property (nonatomic, strong) UITextField *textMoney;
@property (nonatomic, strong) UILabel *lblMoneyTitle, *lblAllMoney;
@property (nonatomic, strong) UIButton *btnWechat, *btnSubmit, *btnAllMoney;

@property (nonatomic, strong) NSString *weixin_code;
@property (nonatomic, strong) NSString *weixin_appOpenId;
@property (nonatomic, strong) NSString *weixin_unionId;

@end

@implementation CashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
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
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    WEAK_SELF
    _viewCurrent = [UIView new];
    _viewCurrent.backgroundColor = [UIColor whiteColor];
    _viewCurrent.layer.cornerRadius = 4.0;
    _viewCurrent.layer.masksToBounds = true;
    [self.view addSubview:self.viewCurrent];
    [self.viewCurrent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(weakSelf.view).offset(10.0);
        make.right.equalTo(weakSelf.view).offset(-10.0);
        make.height.mas_equalTo(596/2.0);
    }];
    
    _lblMoneyTitle = [UILabel new];
    _lblMoneyTitle.backgroundColor = [UIColor clearColor];
    _lblMoneyTitle.textAlignment = NSTextAlignmentLeft;
    _lblMoneyTitle.textColor = [Define kColorGray];
    _lblMoneyTitle.font = [UIFont systemFontOfSize:16.0];
    _lblMoneyTitle.text = @"提现金额";
    [self.viewCurrent addSubview:self.lblMoneyTitle];
    [self.lblMoneyTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewCurrent).offset(20.0);
        make.height.mas_equalTo(20.0);
        make.width.equalTo(self.viewCurrent).offset(-60.0);
        make.left.equalTo(weakSelf.view).offset(30.0);
    }];
    
    _textMoney = [UITextField new];
    _textMoney.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textMoney.backgroundColor = [UIColor clearColor];
    _textMoney.textAlignment = NSTextAlignmentLeft;
    _textMoney.font = [UIFont systemFontOfSize:22.0];
    _textMoney.keyboardType = UIKeyboardTypeDecimalPad;
    _textMoney.textColor = [Define kColorBlack];
    _textMoney.delegate = self;
    _textMoney.placeholder = @"请输入提现金额";
    //    _textMoney.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:@"请输入充值金额" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName:[Define kColorGray]}];
    [self.viewCurrent addSubview:self.textMoney];
    [self.textMoney mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50.0);
        make.width.equalTo(weakSelf.lblMoneyTitle.mas_width);
        make.left.equalTo(weakSelf.lblMoneyTitle.mas_left);
        make.top.equalTo(weakSelf.lblMoneyTitle.mas_bottom);
    }];
    
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40.0, 50.0)];
    leftView.textAlignment = NSTextAlignmentCenter;
    leftView.textColor = [Define kColorBlack];
    leftView.font = [UIFont systemFontOfSize:22.0];
    leftView.text = @"¥";
    self.textMoney.leftView = leftView;
    self.textMoney.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [Define kColorLine];
    [self.viewCurrent addSubview:lineView];
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(weakSelf.lblMoneyTitle.mas_left);
        make.width.equalTo(weakSelf.viewCurrent).offset(-75.0);
        make.top.equalTo(weakSelf.textMoney.mas_bottom).offset(-0.5);
    }];
    
    _lblAllMoney = [UILabel new];
    _lblAllMoney.backgroundColor = [UIColor clearColor];
    _lblAllMoney.textAlignment = NSTextAlignmentLeft;
    _lblAllMoney.textColor = rgb(160, 160, 160);
    _lblAllMoney.font = [UIFont systemFontOfSize:14.0];
    _lblAllMoney.text = @"金额¥99.46 ,";
    [self.viewCurrent addSubview:self.lblAllMoney];
    
    CGFloat size_all_money = [self.lblAllMoney.text sizeWithAttributes:@{NSFontAttributeName:self.lblAllMoney.font}].width+1.0;
    [self.lblAllMoney mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textMoney.mas_bottom);
        make.left.equalTo(weakSelf.lblMoneyTitle.mas_left);
        make.height.mas_equalTo(43.0);
        make.width.mas_equalTo(floorf(size_all_money));
    }];
    
    _btnAllMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAllMoney.backgroundColor = [UIColor clearColor];
    [_btnAllMoney.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_btnAllMoney setTitleColor:[Define kColorBlue] forState:UIControlStateNormal];
    [_btnAllMoney setAdjustsImageWhenHighlighted:NO];
    [_btnAllMoney setTitle:@"全部提现" forState:UIControlStateNormal];
    [_btnAllMoney addTarget:self action:@selector(clickWithAllMoney:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewCurrent addSubview:self.btnAllMoney];
    
    size_all_money = [[self.btnAllMoney titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName:self.lblAllMoney.font}].width+1.0;
    [self.btnAllMoney mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblAllMoney.mas_right).offset(5.0);
        make.top.equalTo(weakSelf.lblAllMoney.mas_top);
        make.height.equalTo(weakSelf.lblAllMoney.mas_height);
        make.width.mas_equalTo(floorf(size_all_money));
    }];
    
    
    UIView *lineView_2 = [UIView new];
    lineView_2.backgroundColor = [Define kColorLine];
    [self.viewCurrent addSubview:lineView_2];
    [lineView_2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(weakSelf.viewCurrent);
        make.top.equalTo(weakSelf.btnAllMoney.mas_bottom).offset(-0.5);
    }];
    
    _btnWechat = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnWechat.backgroundColor = [UIColor clearColor];
    _btnWechat.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_btnWechat.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_btnWechat setTitleColor:[Define kColorGray] forState:UIControlStateNormal];
    _btnWechat.adjustsImageWhenHighlighted = false;
    _btnWechat.titleEdgeInsets = UIEdgeInsetsMake(0, 18.0, 0, 0);
    [_btnWechat setTitle:@"提现至微信" forState:UIControlStateNormal];
    [_btnWechat setImage:[UIImage imageNamed:@"choose_btn"] forState:UIControlStateNormal];
    [self.viewCurrent addSubview:self.btnWechat];
    [self.btnWechat mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblMoneyTitle.mas_left);
        make.top.equalTo(weakSelf.btnAllMoney.mas_bottom).offset(25.0);
        make.width.equalTo(weakSelf.lblMoneyTitle.mas_width);
        make.height.mas_equalTo(20.0);
    }];
    
    CGRect rect_submit = CGRectMake(0, 0, [Define screenWidth] - 70.0, 44.0);
    _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSubmit setBackgroundImage:[UIImage imageWithDraw:rgb(251, 127, 119) sizeMake:rect_submit] forState:UIControlStateNormal];
    [_btnSubmit setBackgroundImage:[UIImage imageWithDraw:[Define kColorRed] sizeMake:rect_submit] forState:UIControlStateHighlighted];
    [_btnSubmit.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [_btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnSubmit.layer.cornerRadius = 22.0;
    _btnSubmit.layer.masksToBounds = true;
    [_btnSubmit setTitle:@"确认提现" forState:UIControlStateNormal];
    [_btnSubmit addTarget:self action:@selector(clickWithSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewCurrent addSubview:self.btnSubmit];
    [self.btnSubmit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(rect_submit.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(weakSelf.btnWechat.mas_bottom).offset(40.0);
    }];
    
}

#pragma mark - Action
- (void)clickWithAllMoney:(UIButton *)sender {
    
}

- (void)clickWithSubmit:(UIButton *)sender {
    CGFloat money = [self.textMoney.text floatValue];
    if (money <= 0.0) {
        [Tool showHUDTipWithTipStr:@"请输入提现金额!"];
        return;
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textMoney resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *tempText = [NSString stringWithFormat:@"%@%@",textField.text, string];
    tempText = [tempText stringByReplacingCharactersInRange:range withString:@""];
    NSArray *arrayCount = [tempText componentsSeparatedByString:@"."];
    
    if (arrayCount.count > 2) {
        return false;
    } else if ([tempText floatValue] > 50000.0) {
        textField.text = @"50000.0";
        return false;
    } else if ([tempText rangeOfString:@"."].location != NSNotFound) {
        //只能有两位小数
        NSRange tempRange = [tempText rangeOfString:@"."];
        if (tempText.length - tempRange.location - tempRange.length > 2) {
            return false;
        }
    }
    return  YES;
}

#pragma mark - WXApiEngineDelegate
- (void)shareEngineWXApi:(SendAuthResp *)response {
    if (response.errCode == -2) {
        //用户取消
        [Tool showHUDTipWithTipStr:@"您已取消授权！"];
    } else if (response.errCode == -4) {
        //用户拒绝授权
        [Tool showHUDTipWithTipStr:@"您已拒绝授权！"];
    } else {
        // 0(用户同意)
        _weixin_code = response.code;
        [self queryByAppOpenId];
    }
}

- (void)showAlertMessage {
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"如需提现，请先关注微信公众号“鞭挞我”！" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark - Network
- (void)cashMoney {
    UserManager *info = [UserManager shared];
    NSString *str_userId = [NSString stringWithFormat:@"%@",info.userId];
    NSString *str_amount = [NSString stringWithFormat:@"%.2f",[self.textMoney.text floatValue]];
    
    NSDictionary *param = @{@"userId":str_userId,@"amount":str_amount};
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@""];
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"withdraw" params:param Success:^(id result) {
        [SVProgressHUD dismiss];
        DebugLog(@"_______result:%@",result);
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] integerValue] == 0) {
            [Tool showHUDTipWithTipStr:@"提现成功！"];
        } else if ([data[@"ret"] integerValue] == 1) {
            [weakSelf showAlertMessage];
        }  else if ([data[@"ret"] integerValue] == 3) {
            [[WMShareEngine sharedInstance] sendAuthRequest:self];
        } else {
            [Tool showHUDTipWithTipStr:data[@"desc"]];
        }
    } Failed:^(NSError *error) {
        [SVProgressHUD dismiss];
        DebugLog(@"________error:%@",error);
    }];
}
- (void)queryByAppOpenId {
    if ([NSString isBlankString:self.weixin_code]) {
        return;
    }
    WEAK_SELF
    [HttpAPIClient APIWeChatToCode:self.weixin_code Success:^(id result) {
        NSString *errmsg = result[@"errmsg"];
        if (![NSString isBlankString:errmsg]) {
            [Tool showHUDTipWithTipStr:errmsg];
        } else {
            weakSelf.weixin_appOpenId = [NSString stringWithFormat:@"%@",result[@"openid"]];
            weakSelf.weixin_unionId = [NSString stringWithFormat:@"%@",result[@"unionid"]];
            [weakSelf bandWeixin];
        }
    } Failed:^(NSError *error) {
        
    }];
}

- (void)bandWeixin {
    if ([NSString isBlankString:self.weixin_appOpenId] || [NSString isBlankString:self.weixin_unionId]) {
        return;
    }
    UserManager *user = [UserManager shared];
    NSString *user_id = [NSString stringWithFormat:@"%@",user.userId];
    NSString *union_id = [NSString stringWithFormat:@"%@",self.weixin_unionId];
    
    NSDictionary *param = @{@"userId":user_id,@"unionId":union_id,@"appOpenId":self.weixin_appOpenId};
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"bindWeixin" params:param Success:^(id result) {
        DebugLog(@"_______result:%@",result);
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] integerValue] == 0) {
            [weakSelf showAlertMessage];
        } else {
            [Tool showHUDTipWithTipStr:data[@"desc"]];
        }
    } Failed:^(NSError *error) {
        DebugLog(@"________error:%@",error);
    }];
}

@end
