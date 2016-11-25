//
//  TopUpViewController.m
//  WhipMe
//
//  Created by anve on 16/11/23.
//  Copyright © 2016年 -. All rights reserved.
//

#import "TopUpViewController.h"
#import "NSString+Common.h"
#import "NSString+Validate.h"
#import "ShareEngine.h"

@interface TopUpViewController () <UITextFieldDelegate, WXApiEngineDelegate>

@property (nonatomic, strong) UIView *viewCurrent;
@property (nonatomic, strong) UITextField *textMoney;
@property (nonatomic, strong) UILabel *lblMoneyTitle;
@property (nonatomic, strong) UIButton *btnWechat, *btnSubmit;

@property (nonatomic, strong) NSString *weixin_code;
@property (nonatomic, strong) NSString *weixin_appOpenId;
@property (nonatomic, strong) NSString *weixin_unionId;

@end

@implementation TopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    self.view.backgroundColor = [Define kColorBackGround];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    DebugLog(@"%@",self.class);
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
        make.height.mas_equalTo(290.0);
    }];
    
    _lblMoneyTitle = [UILabel new];
    _lblMoneyTitle.backgroundColor = [UIColor clearColor];
    _lblMoneyTitle.textAlignment = NSTextAlignmentLeft;
    _lblMoneyTitle.textColor = [Define kColorGray];
    _lblMoneyTitle.font = [UIFont systemFontOfSize:16.0];
    _lblMoneyTitle.text = @"充值金额";
    [self.viewCurrent addSubview:self.lblMoneyTitle];
    [self.lblMoneyTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40.0);
        make.width.equalTo(self.viewCurrent).offset(-60.0);
        make.left.equalTo(weakSelf.view).offset(30.0);
        make.top.equalTo(self.viewCurrent);
    }];
    
    _textMoney = [UITextField new];
    _textMoney.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textMoney.backgroundColor = [UIColor clearColor];
    _textMoney.textAlignment = NSTextAlignmentLeft;
    _textMoney.font = [UIFont systemFontOfSize:22.0];
    _textMoney.keyboardType = UIKeyboardTypeDecimalPad;
    _textMoney.textColor = [Define kColorBlack];
    _textMoney.delegate = self;
    _textMoney.placeholder = @"请输入充值金额";
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
        make.left.right.equalTo(weakSelf.viewCurrent);
        make.top.equalTo(weakSelf.textMoney.mas_bottom).offset(-0.5);
    }];
    
    _btnWechat = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnWechat.backgroundColor = [UIColor clearColor];
    _btnWechat.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_btnWechat.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_btnWechat setTitleColor:[Define kColorGray] forState:UIControlStateNormal];
    _btnWechat.adjustsImageWhenHighlighted = false;
    _btnWechat.titleEdgeInsets = UIEdgeInsetsMake(0, 18.0, 0, 0);
    [_btnWechat setTitle:@"微信支付" forState:UIControlStateNormal];
    [_btnWechat setImage:[UIImage imageNamed:@"choose_btn"] forState:UIControlStateNormal];
    [self.viewCurrent addSubview:self.btnWechat];
    [self.btnWechat mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.viewCurrent).offset(35.0);
        make.top.equalTo(weakSelf.textMoney.mas_bottom).offset(30.0);
        make.width.equalTo(weakSelf.viewCurrent).offset(-70.0);
        make.height.mas_equalTo(20.0);
    }];
    
    CGRect rect_submit = CGRectMake(0, 0, [Define screenWidth] - 70.0, 44.0);
    _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSubmit setBackgroundImage:[UIImage imageWithDraw:[Define kColorCyanOff] sizeMake:rect_submit] forState:UIControlStateNormal];
    [_btnSubmit setBackgroundImage:[UIImage imageWithDraw:[Define kColorCyanOn] sizeMake:rect_submit] forState:UIControlStateHighlighted];
    [_btnSubmit.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [_btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnSubmit.layer.cornerRadius = 22.0;
    _btnSubmit.layer.masksToBounds = true;
    [_btnSubmit setTitle:@"去充值" forState:UIControlStateNormal];
    [_btnSubmit addTarget:self action:@selector(clickWithSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewCurrent addSubview:self.btnSubmit];
    [self.btnSubmit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(rect_submit.size);
        make.centerX.equalTo(self.view);
        make.top.equalTo(weakSelf.btnWechat.mas_bottom).offset(40.0);
    }];
    
}

- (void)clickWithSubmit:(UIButton *)sender {
    CGFloat money = [self.textMoney.text floatValue];
    if (money <= 0.0) {
        [Tool showHUDTipWithTipStr:@"请输入充值金额!"];
        return;
    }
    [self topUpMoney];
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
    } else if ([tempText floatValue] > 5000.0) {
       textField.text = @"5000.0";
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

- (void)shareEnginePayment:(PayResp *)response {
    if (response.errCode == WXSuccess) {
        self.textMoney.text = @"";
        [Tool showHUDTipWithTipStr:@"充值成功！"];
    } else {
        NSString *strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", response.errCode,response.errStr];
        [Tool showHUDTipWithTipStr:strMsg];
    }
}

#pragma mark - Network
- (void)queryByAppOpenId {
    if ([NSString isBlankString:self.weixin_code]) {
        return;
    }
    WEAK_SELF
    [HttpAPIClient APIWeChatToCode:self.weixin_code Success:^(id result) {
        DebugLog(@"_________resutl:%@",result);
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
    UserManager *user = [UserManager getUser];
    NSString *user_id = [NSString stringWithFormat:@"%@",user.userId];
    NSString *union_id = [NSString stringWithFormat:@"%@",self.weixin_unionId];
    
    NSDictionary *param = @{@"userId":user_id,@"unionId":union_id,@"appOpenId":self.weixin_appOpenId};
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"bindWeixin" params:param Success:^(id result) {
        DebugLog(@"________result:%@",result);
        NSDictionary *data = [result[@"data"] mj_JSONObject][0];
        if ([data[@"ret"] integerValue] == 0) {
            [weakSelf topUpMoney];
        } else {
            [Tool showHUDTipWithTipStr:data[@"desc"]];
        }
    } Failed:^(NSError *error) {
        DebugLog(@"________error:%@",error);
    }];
}

/** 充值金额 */
- (void)topUpMoney {
   
    NSString *str_ip = [NSString getIPAddress];
    UserManager *info = [UserManager getUser];
    NSString *str_userId = [NSString stringWithFormat:@"%@",info.userId];
    NSString *str_amount = [NSString stringWithFormat:@"%.2f",[self.textMoney.text floatValue]];
    
    NSDictionary *param = @{@"userId":str_userId,@"amount":str_amount,@"ip":str_ip};
    
    DebugLog(@"_____________param:%@",param);
    [HttpAPIClient APIClientPOST:@"recharge" params:param Success:^(id result) {
        DebugLog(@"_______result:%@",result);
        NSDictionary *data = [result[@"data"] mj_JSONObject][0];
        if ([data[@"ret"] integerValue] == 1) {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"如需充值，请先绑定微信！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[WMShareEngine sharedInstance] sendAuthRequest:self];
            }]];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertControl animated:YES completion:nil];
        } else if ([data[@"ret"] integerValue] == 0) {
            [[WMShareEngine sharedInstance] sendWeChatPaymentInfo:data[@"info"]];
        } else {
            [Tool showHUDTipWithTipStr:data[@"desc"]];
        }
    } Failed:^(NSError *error) {
        DebugLog(@"________error:%@",error);
    }];
}

@end
