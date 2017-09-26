//
//  DDRegistController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDRegistController.h"
#import "MBProgressHUD+MJ.h"
#import "DDInterface.h"
#import "DDGlobalVariables.h"
#import "DDWebViewController.h"
#import "YYModel.h"
#import "DDSelfInfomation.h"
#import "LSJPush.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "DDLocalUserInfoUtils.h"

@interface DDRegistController ()<UITextFieldDelegate, DDInterfaceDelegate>
/**  背部的滚动视图  */
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *backScrollView;
/**
 *  手机号输入框
 */
@property (strong, nonatomic) UITextField *phoneTextField;
/**
 *  验证码输入框
 */
@property (strong, nonatomic) UITextField *authCodeTextField;
/**
 *  主按钮
 */
@property (strong, nonatomic) UIButton *mainButton;
/**
 计时器
 */
@property (strong, nonatomic) NSTimer *countDownTimer;
/**
 *  倒计时进度条
 */
@property (strong, nonatomic) UIProgressView *countDownProgressView;

/**
 *  快递Logo
 */
@property (strong, nonatomic) UIButton *titleLogo;

/**
 *  背景视图
 */
@property (strong, nonatomic) UIImageView *backImageView;

/**  
 协议文字  
 */
@property (nonatomic, strong) UILabel *protocolLabel;
/**
 *  艾特小哥协议按钮
 */
@property (strong, nonatomic) UIButton *protocolButton;

/**
 *  重新发送按钮
 */
@property (strong, nonatomic) UIButton *sendAgainButton;

/**
 *  验证验证码正则表达式
 */
@property (strong, nonatomic) NSString *authCodeCheckText;
/**  返回按钮  */
@property (nonatomic, strong) UIButton *backButton;
/**
 *  获取验证码服务器数据
 */
@property (nonatomic,strong) DDInterface *getCodeInterFace;
/**
 *  登录服务器数据
 */
@property (nonatomic,strong) DDInterface *loginInterface;
/**  已经获取过验证码了  */
@property (nonatomic, assign) BOOL isHaveBeenGetCode;




@end

@implementation DDRegistController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = DDRGBAColor(253, 253, 253, 1);
    [self initNavigationController];
    [self.view addSubview:self.backScrollView];
    [self.backScrollView addSubview:self.backImageView];
    [self.backScrollView addSubview:self.titleLogo];
    [self.backScrollView addSubview:self.phoneTextField];
    [self.backScrollView addSubview:self.authCodeTextField];
    [self.backScrollView addSubview:self.countDownProgressView];
    [self.backScrollView addSubview:self.protocolLabel];
    [self.backScrollView addSubview:self.protocolButton];
    [self.backScrollView addSubview:self.mainButton];
    [self.backScrollView addSubview:self.sendAgainButton];
    [self.view addSubview:self.backButton];
    
    
    self.authCodeTextField.delegate = self;
    self.phoneTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}




#pragma mark - Click Action
/** 返回 */
- (void)onClickWithBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  艾特小哥服务协议按钮点击事件
 */
- (void)protocolClick
{
    DDWebViewController *vc = [[DDWebViewController alloc]init];
    vc.URLString = XiaogeServiceHtmlUrlStr;
    vc.navTitle = @"服务协议";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  主按钮点击事件
 */
- (void)mainButtonClick
{
    if ([self.mainButton.titleLabel.text isEqualToString:@"获取验证码"]) {
        
        if ([self isValidateMobile:self.phoneTextField.text] == YES) {
            
            [self getAuthCodeRequest];
            
        } else {
            [MBProgressHUD showError:@"手机号码格式输入有误"];
        }
    } else {
        /**验证账号密码是否正确*/
        [self loginRequest];
    }
}

/**
 *  重新发送按纽点击事件
 */
- (void)sendAgainButtonClick
{
    /** 进度条清空,重启计时器 */
    if ([self isValidateMobile:self.phoneTextField.text]) {
        [self createCountDownViewAndBeginToCountDown];
        [self.sendAgainButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
        [self.sendAgainButton setUserInteractionEnabled:NO];
        self.sendAgainButton.adjustsImageWhenHighlighted = NO;
    } else {
        [MBProgressHUD showError:@"手机号码格式输入有误"];
    }
}




#pragma mark - Network Request
- (void)getAuthCodeRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:@"1" forKey:@"type"];
    
    [param setObject:self.phoneTextField.text.length > 0 ? self.phoneTextField.text : @"" forKey:@"phoneNumber"];

    DDInterface *interFace = [[DDInterface alloc] initWithDelegate:self];
    
    self.getCodeInterFace = interFace;
    
    [self.getCodeInterFace interfaceWithType:INTERFACE_TYPE_SEND_CAPTCHA param:param];
}


- (void)loginRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:self.phoneTextField.text.length > 0 ? self.phoneTextField.text : @"" forKey:@"phoneNumber"];
    
    [param setObject:self.authCodeTextField.text.length > 0 ? self.authCodeTextField.text : @"" forKey:@"checkNumber"];
    /**验证账号密码是否正确*/
    DDInterface *interface = [DDInterface interfaceWithDelegate:self];
    
    [interface interfaceWithType:INTERFACE_TYPE_LOGIN param:param];
    
    self.loginInterface = interface;
}



/**
 接口数据返回
 */
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.getCodeInterFace) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            if (self.isHaveBeenGetCode == NO) {
                //改变主按钮
                [self.mainButton setTitle:@"确  定" forState:UIControlStateNormal];
                [self.mainButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
                self.mainButton.layer.borderColor = KPlaceholderColor.CGColor;
                self.isHaveBeenGetCode = YES;
            }
            //启动倒计时
            [self createCountDownViewAndBeginToCountDown];
            //显示重新发送按钮
            [self.sendAgainButton setHidden:NO];
        }
    }
    else if (interface == self.loginInterface)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            [DDLocalUserInfoUtils setLocalUserInfo:result]; // setLocal UserInfo
            [DDLocalUserInfoUtils updateUserAutoLogin:YES];
            
            DDPostNotification(KINTERFACE_TYPE_PRE_ORDER_LIST); //通知预处理订单
            DDPostNotification(KNOTIFICATION_USER_INFORMATION);
            
            [self.navigationController popViewControllerAnimated:YES];
            NSString *alias = [NSString stringWithFormat:@"%@",result[@"userId"]];
            [LSJPush setTags:[NSSet setWithArray:@[@"client"]] alias:alias resBlock:^(BOOL res, NSSet *tags, NSString *alias) {
                if(res){
                    NSLog(@"设置成功：%@,%@",@(res),alias);
                }else{
                    NSLog(@"设置失败");
                }
            }];
        }
    }
}


#pragma mark - Text FieldDelegate
/**
 *  当点击了return
 *
 *  @param textField textfield的对象
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    textTemp = textField;
    return true;
}

/**
 *  限制输入字符长度
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //一. 判断输入框, 设置两个输入框的最大输入长度
    if (self.phoneTextField == textField) {
        NSString *getPhoneText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //输入的长度到了11位,就停止编写
        if ([getPhoneText length] > 11) {
            textField.text = [getPhoneText substringToIndex:11];
            return NO;
        }
    } else if (self.authCodeTextField == textField) {
        NSString *getAuthCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //限制密码输入不能超过6位, 否则不能输入
        if([getAuthCode length] > 6) {
            textField.text = [getAuthCode substringToIndex:6];
            [self.authCodeTextField resignFirstResponder];
            return NO;
        }
    }
    return YES;
}


/**
 *  当手机号输入框的内容发生改变的时候
 *
 *  @param textfield 手机textfield对象
 */
- (void)phoneTextFieldCharacterDidChanged:(UITextField *)textfield
{
    if (self.isHaveBeenGetCode == NO) {
        if (textfield.text.length < 11) {
            [self setMainButtonWithTitle:@"获取验证码" andButtonUserInteractionEnabled:NO];
        }else if (textfield.text.length == 11 && self.authCodeTextField.text.length < 6){
            [self setMainButtonWithTitle:@"获取验证码" andButtonUserInteractionEnabled:YES];
        }else{
            [self setMainButtonWithTitle:@"确 定" andButtonUserInteractionEnabled:YES];
        }
    }else {
        if (textfield.text.length < 11){
            [self setMainButtonWithTitle:@"" andButtonUserInteractionEnabled:NO];
            [self setSendAgainButtonWithUserInteractionEnabled:NO];
        }else if (textfield.text.length == 11 && self.authCodeTextField.text.length < 6){
            if (self.sendAgainButton.userInteractionEnabled == NO) {
                [self setSendAgainButtonWithUserInteractionEnabled:YES];
            }
            [self setMainButtonWithTitle:@"" andButtonUserInteractionEnabled:NO];
        }else{
            [self setMainButtonWithTitle:@"" andButtonUserInteractionEnabled:YES];
            if (self.sendAgainButton.userInteractionEnabled == NO) {
                [self setSendAgainButtonWithUserInteractionEnabled:YES];
            }
        }
    }
}

/**
 *  验证码输入框内容发生改变的时候
 *
 *  @param textfield 验证码textfield对象
 */
- (void)authCodeTextFieldCharacterDidChanged:(UITextField *)textfield
{
    if (self.isHaveBeenGetCode == NO)
    {
        if (self.phoneTextField.text.length < 11) {
            [self setMainButtonWithTitle:@"获取验证码" andButtonUserInteractionEnabled:NO];
        }else if (self.phoneTextField.text.length == 11 && textfield.text.length < 6){
            [self setMainButtonWithTitle:@"获取验证码" andButtonUserInteractionEnabled:YES];
        }else{
            [self setMainButtonWithTitle:@"确 定" andButtonUserInteractionEnabled:YES];
        }
    }else {
        if (self.phoneTextField.text.length < 11){
            [self setMainButtonWithTitle:@"" andButtonUserInteractionEnabled:NO];
            if (self.sendAgainButton.userInteractionEnabled == YES) {
                [self setSendAgainButtonWithUserInteractionEnabled:NO];
            }
        }else if (self.phoneTextField.text.length == 11 && textfield.text.length < 6){
            [self setMainButtonWithTitle:@"" andButtonUserInteractionEnabled:NO];
        }else{
            [self setMainButtonWithTitle:@"" andButtonUserInteractionEnabled:YES];
        }
    }
}

/**
 *  点击View,使textField失去焦点
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Private Method
/** 设置导航控制器*/
- (void) initNavigationController
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.navigationController setNavigationBarHidden:YES];
    //改变系统栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)setMainButtonWithTitle:(NSString *)title andButtonUserInteractionEnabled:(BOOL)isUserInteractionEnabled
{
    if (title.length > 0) {
        [self.mainButton setTitle:title forState:UIControlStateNormal];
    }
    if (isUserInteractionEnabled == NO) {
        [self.mainButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        self.mainButton.layer.borderColor = KPlaceholderColor.CGColor;
        [self.mainButton setUserInteractionEnabled:NO];
        self.mainButton.adjustsImageWhenHighlighted = NO;
    }else{
        [self.mainButton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
        self.mainButton.layer.borderColor = DDGreen_Color.CGColor;
        [self.mainButton setUserInteractionEnabled:YES];
        self.mainButton.adjustsImageWhenHighlighted = YES;
    }
}



- (void)setSendAgainButtonWithUserInteractionEnabled:(BOOL)isUserInteractionEnabled
{
    if (isUserInteractionEnabled == NO) {
        [self.sendAgainButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [self.sendAgainButton setUserInteractionEnabled:NO];
        self.sendAgainButton.adjustsImageWhenHighlighted = NO;
    }else{
        [self.sendAgainButton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
        [self.sendAgainButton setUserInteractionEnabled:YES];
        self.sendAgainButton.adjustsImageWhenHighlighted = YES;
    }
    
}
#pragma mark - progress Count Down Method
/**
 *  初始化倒计时视图
 */
- (void)createCountDownViewAndBeginToCountDown
{
    self.countDownProgressView.progress = 0;
    if (self.countDownTimer != nil) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressRun) userInfo:nil repeats:YES];//启动倒计时后会每秒钟调用一次方法 timeFireMethod
//    self.countDownProgressView.height = 2;
    [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
    
}

/**
 *  每秒被调用的计时器
 */
- (void)progressRun
{
    
    self.countDownProgressView.progress += 0.0166666;
    //当倒计结束
    if(self.countDownProgressView.progress == 1){
        //进度条归零
        self.countDownProgressView.progress = 0;
        //设置重新发送按钮
        [self.sendAgainButton setTitleColor:DDRGBAColor(32, 198, 122, 1) forState:UIControlStateNormal];
        [self.sendAgainButton setUserInteractionEnabled:YES];
        self.sendAgainButton.adjustsImageWhenHighlighted = YES;
        //使定时器无效
        [self.countDownTimer invalidate];
    }
}

//#pragma mark - 判断方法
///**
// *  判断按钮的类型
// *
// *  @return YES---获取验证码按钮   NO---登录按钮
// */
//- (BOOL)checkMainButtonType
//{
//    if ([self.mainButton.titleLabel.text isEqualToString:@"获取验证码"])
//    {
//        NSLog(@"获取验证码按钮!!!!!!");
//        return YES;
//    }else{
//        NSLog(@"登录按钮!!!!!!!!");
//        return NO;
//    }
//}


#pragma mark - Setter && Getter

- (TPKeyboardAvoidingScrollView *)backScrollView
{
    if (_backScrollView == nil) {
        _backScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
        _backScrollView.bounces = NO;
        _backScrollView.contentSize = self.view.size;
    }
    return _backScrollView;
}


- (UIImageView *)backImageView
{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]initWithFrame:self.backScrollView.bounds];
        _backImageView.image = [UIImage imageNamed:@"Login_bc"];
    }
    return _backImageView;
}

- (UIButton *)titleLogo
{
    if (_titleLogo == nil) {
        _titleLogo = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height*204/568)];
        [_titleLogo setImage:[UIImage imageNamed:@"login_logo"] forState:UIControlStateNormal];
        [_titleLogo setImageEdgeInsets:UIEdgeInsetsMake(30, 0, -30, 0)];
        _titleLogo.userInteractionEnabled = NO;
    }
    return _titleLogo;
}

- (UITextField *)phoneTextField
{
    if (_phoneTextField == nil) {
        //1.手机号输入框
        UITextField *phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(85, self.titleLogo.bottom, self.view.width-85-45, 45)];
        phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneTextField.textColor = TITLE_COLOR;
        phoneTextField.font = kTitleFont;
        UIColor *phonePhColor = KPlaceholderColor;
        UIFont *phonePhFont = kTitleFont;
        phoneTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:phonePhColor,NSFontAttributeName:phonePhFont}];
        [phoneTextField addTarget:self action:@selector(phoneTextFieldCharacterDidChanged:) forControlEvents:UIControlEventEditingChanged];
        
        
        UIView *underLineView = [[UIView alloc]initWithFrame:CGRectMake(45, phoneTextField.bottom, self.view.width - 90, 1)];
        underLineView.backgroundColor = DDRGBAColor(233, 233, 233, 1);
        [self.backScrollView addSubview:underLineView];
        
        UIView *leftLineView = [[UIView alloc]initWithFrame:CGRectMake(77, self.titleLogo.bottom + 14, 1, 16)];
        leftLineView.backgroundColor = DDRGBAColor(233, 233, 233, 1);
        [self.backScrollView addSubview:leftLineView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, self.titleLogo.bottom, 27, 45)];
        titleLabel.text = @"+86";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = DDRGBAColor(102, 102, 102, 1);
        [self.backScrollView addSubview:titleLabel];
        
        _phoneTextField = phoneTextField;
    }
    return _phoneTextField;
}


- (UITextField *)authCodeTextField
{
    if (_authCodeTextField == nil) {
        UITextField *authCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(45, self.phoneTextField.bottom, self.view.width - 90, 45)];
        //2.验证码输入框
        authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIColor *authPhColor = KPlaceholderColor;
        UIFont *authPhFont = kTitleFont;
        authCodeTextField.textColor = TITLE_COLOR;
        authCodeTextField.font = kTitleFont;
        authCodeTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:authPhColor,NSFontAttributeName:authPhFont}];
        [authCodeTextField addTarget:self action:@selector(authCodeTextFieldCharacterDidChanged:) forControlEvents:UIControlEventEditingChanged];
        _authCodeTextField = authCodeTextField;
    }
    return _authCodeTextField;
}


- (UILabel *)protocolLabel
{
    if (_protocolLabel == nil) {
        UILabel *protocolLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, self.authCodeTextField.bottom + 20, self.authCodeTextField.width, 20)];
        protocolLabel.textColor = DDRGBColor(102, 102, 102);
        protocolLabel.font = [UIFont systemFontOfSize:12];
        protocolLabel.textAlignment = NSTextAlignmentCenter;
        NSRange rangeSS = [DDRemindLabelText rangeOfString:@"艾特小哥服务协议"];
        NSMutableAttributedString *attRemin = [[NSMutableAttributedString alloc] initWithString:DDRemindLabelText];
        [attRemin addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:1] range:rangeSS];
        [protocolLabel setAttributedText:attRemin];
        _protocolLabel = protocolLabel;
    }
    return _protocolLabel;
}

- (UIButton *)protocolButton
{
    if (_protocolButton == nil) {
        UIButton *protocolButton = [[UIButton alloc]init];
        protocolButton.x = self.protocolLabel.centerX;
        protocolButton.y = self.protocolLabel.y - 12;
        protocolButton.height = 44;
        protocolButton.width = 100;
        protocolButton.backgroundColor = [UIColor clearColor];
        [protocolButton addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
        _protocolButton = protocolButton;
    }
    return _protocolButton;
}

- (UIButton *)mainButton
{
    if (_mainButton == nil) {
        UIButton *mainButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2 - 58, self.protocolLabel.bottom + 30, 116, 30)];
        //1.主按钮
        [mainButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [mainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [mainButton.titleLabel setFont:kTitleFont];
        [mainButton setUserInteractionEnabled:NO];
        [mainButton setAdjustsImageWhenHighlighted:NO];
        mainButton.layer.borderColor = KPlaceholderColor.CGColor;
        mainButton.layer.borderWidth = 1;
        mainButton.layer.cornerRadius = 14;
        mainButton.layer.masksToBounds = YES;
        [mainButton addTarget:self action:@selector(mainButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _mainButton = mainButton;
    }
    return _mainButton;
}


- (UIButton *)sendAgainButton
{
    if (_sendAgainButton == nil) {
        UIButton *sendAgainButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2 - 80, self.mainButton.bottom + 8, 160, 30)];
        [sendAgainButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        [sendAgainButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [sendAgainButton.titleLabel setFont:kTimeFont];
        [sendAgainButton setUserInteractionEnabled:NO];
        [sendAgainButton setAdjustsImageWhenHighlighted:NO];
        [sendAgainButton setHidden:YES];
        [sendAgainButton addTarget:self action:@selector(sendAgainButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _sendAgainButton = sendAgainButton;
    }
    return _sendAgainButton;
}

- (UIProgressView *)countDownProgressView
{
    if (_countDownProgressView == nil) {
        _countDownProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(self.authCodeTextField.x, self.authCodeTextField.bottom, self.authCodeTextField.width, 0.5)];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 0.5f);
        _countDownProgressView.transform = transform;
        _countDownProgressView.progressTintColor = DDGreen_Color;
        _countDownProgressView.trackTintColor = BORDER_COLOR;
        [_countDownProgressView setProgress:0.0 animated:YES];
    }
    return _countDownProgressView;
}


- (UIButton *)backButton
{
    if (_backButton == nil) {
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 44)];
        [_backButton setImage:[UIImage imageNamed:DDBackGreenBarIcon] forState:UIControlStateNormal];
        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_backButton setBackgroundColor:[UIColor clearColor]];
        [_backButton setShowsTouchWhenHighlighted:NO];
        [_backButton addTarget:self action:@selector(onClickWithBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


@end
