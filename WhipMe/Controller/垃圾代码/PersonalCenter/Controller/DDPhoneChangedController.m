//
//  DDPhoneChangedController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
#define KTextTag 7777

#import "DDPhoneChangedController.h"
#import "DDPersonalDetailController.h"
#import "DDGlobalVariables.h"
#import "DDSelfInfomation.h"

#import "DDLocalUserInfoUtils.h"
#import "CustomStringUtils.h"

/** 输入框的高度 */
#define DDPhoneChangeTextHeight 45
/** 更改手机号按钮的高度 */
#define DDPhoneChangeButtonHeight 40

@interface DDPhoneChangedController () <UITextFieldDelegate, DDInterfaceDelegate>

/** 电话号码输入框 */
@property (nonatomic, strong) UITextField *textTelephone;
/** 短信验证码输入框 */
@property (nonatomic, strong) UITextField *textCodePwd;
/** 短信验证码按钮 */
@property (nonatomic, strong) UIButton *btnCodePwd;
/** 下一步操作按钮 */
@property (nonatomic, strong) UIButton *btnNext;

/**<  修改个人信息  */
@property (nonatomic,strong) DDInterface *interfacePhone;
/**<  发送验证吗  */
@property (nonatomic,strong) DDInterface *interfaceCode;


@end

@implementation DDPhoneChangedController
@synthesize textTelephone;
@synthesize textCodePwd;

@synthesize btnCodePwd;
@synthesize btnNext;

#pragma mark - Network Request
/**
 *  更换手机号 网络请求
 *
 *  @param textPhone 手机号码
 *  @param textCode  验证码
 */
- (void)updateWithPhone:(NSString *)textPhone withCode:(NSString *)textCode
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //新手机号
    [param setObject:textPhone forKey:@"phone"];
    //验证码
    [param setObject:textCode forKey:@"captcha"];
    
    //初始化连接
    if (!self.interfacePhone) {
        self.interfacePhone = [[DDInterface alloc] initWithDelegate:self];
    }
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [self.interfacePhone interfaceWithType:INTERFACE_TYPE_CHANGE_PHONE param:param];
}

/** 发送验证码 */
- (void)sendCodeWithPhone:(NSString *)textPhone
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //新手机号
    if ([textPhone length] > 0) {
        [param setObject:textPhone forKey:@"phoneNumber"];
    }
    //验证码类型,绑定手机
    [param setObject:@5 forKey:@"type"];
    
    //初始化连接
    if (!self.interfaceCode) {
        self.interfaceCode = [[DDInterface alloc] initWithDelegate:self];
    }
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [self.interfaceCode interfaceWithType:INTERFACE_TYPE_SEND_CAPTCHA param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfacePhone)
    {
        [btnNext setUserInteractionEnabled:true];
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self displayForErrorMsg:@"绑定成功"];
            
            NSString *textPhone = [textTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ([CustomStringUtils isBlankString:[DDLocalUserInfoUtils getUserPhone]] && ![CustomStringUtils isBlankString:textPhone]) {
                [DDLocalUserInfoUtils updateUserPhone:textPhone];
            }
            DDPostNotification(DDRefreshCourierUserView);
            
            for (UIViewController *control in self.navigationController.viewControllers) {
                if ([control isKindOfClass:[DDPersonalDetailController class]]) {
                    [self.navigationController popToViewController:control animated:true];
                    break;
                }
            }
        }
    }
    else if (interface == self.interfaceCode)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }
    }
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:WHITE_COLOR];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"更换手机号" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    //根据短信验证码按钮的Frame，创建"请输入手机号"和"请输入验证码"输入框，短信验证码按钮
    [self ddShowForTextField];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [btnNext setUserInteractionEnabled:true];
}

#pragma mark - 对象方法:初始化界面
/**
    根据短信验证码按钮的Frame，创建"请输入手机号"和"请输入验证码"输入框
 */
- (void)ddShowForTextField
{
    NSString *codePwdTitle = @"发送验证码";
    CGSize szieCodePwd = [codePwdTitle sizeWithAttributes:@{NSFontAttributeName : kTitleFont}];
    //创建短信验证码按钮
    btnCodePwd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCodePwd setSize:CGSizeMake(floorf(szieCodePwd.width + 20) , DDPhoneChangeTextHeight)];
    [btnCodePwd setCenter:CGPointMake(self.view.width - btnCodePwd.centerx - 15.0f ,DDPhoneChangeTextHeight/2 + KNavHeight)];
    [btnCodePwd.layer setCornerRadius:2.0f];
    [btnCodePwd.layer setMasksToBounds:true];
    [btnCodePwd.titleLabel setFont:kTitleFont];
    [btnCodePwd setTitle:codePwdTitle forState:UIControlStateNormal];
    [btnCodePwd setTitleColor:DDGreen_Color forState:UIControlStateNormal];
    [btnCodePwd addTarget:self action:@selector(onClickWithCodePwd:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btnCodePwd];
    
    UILabel *lblLine = [[UILabel alloc] init];
    [lblLine setSize:CGSizeMake(0.5f, 14.0f)];
    [lblLine setCenter:CGPointMake(self.view.width - 15.0f - btnCodePwd.width - 10, DDPhoneChangeTextHeight/2)];
    [lblLine setBackgroundColor:KBackground_COLOR];
    [self.view addSubview:lblLine];

    
    //循环创建输入框，根据下标判断“手机号”和“验证码”
    NSArray *arrayTitles = [NSArray arrayWithObjects:@"请输入手机号",@"请输入验证码", nil];
    for (int i=0; i<arrayTitles.count; i++)
    {
        //初始化输入框
        UITextField *textItem = [[UITextField alloc] init];
        [textItem setFrame:CGRectMake( 15.0f, KNavHeight + i*DDPhoneChangeTextHeight, btnCodePwd.left - 30, DDPhoneChangeTextHeight)];
        [textItem setBackgroundColor:[UIColor whiteColor]];
        [textItem.layer setCornerRadius:2.0f];
        [textItem.layer setMasksToBounds:true];
        
        [textItem setTextAlignment:NSTextAlignmentLeft];
        [textItem setTextColor:TITLE_COLOR];
        [textItem setDelegate:self];
        [textItem setTag:KTextTag + i];
        [textItem setFont:kTitleFont];
        [textItem setKeyboardType:UIKeyboardTypeNumberPad];
        [textItem setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textItem setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textItem setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:arrayTitles[i] attributes:@{NSForegroundColorAttributeName:KPlaceholderColor}]];
        [self.view addSubview:textItem];
        
        UILabel *lblLine = [[UILabel alloc] init];
        [lblLine setFrame:CGRectMake(15.0f, textItem.bottom - 0.5f, self.view.width-15.0f, 0.5f)];
        [lblLine setBackgroundColor:BORDER_COLOR];
        [self.view addSubview:lblLine];
        
        if (i == 0) {
            //设置数字键盘
            textTelephone = textItem;
        } else {
            //设置普通键盘
            textCodePwd = textItem;
        }
    }
    
    [self ddCreateForButton];
}

/** 创建"确认更换"按钮 */
- (void)ddCreateForButton
{
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext setFrame:CGRectMake( 15.0f, textCodePwd.bottom + 30.0f, self.view.width - 30.0f, DDPhoneChangeButtonHeight)];
    [btnNext.layer setCornerRadius:DDPhoneChangeButtonHeight/2];
    [btnNext.layer setMasksToBounds:true];
    [btnNext setBackgroundColor:DDGreen_Color];
    [btnNext.titleLabel setFont:kButtonFont];
    [btnNext setTitle:@"更改手机号" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(onClickWithNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
    
    [self ddCreateForLabel];
}

/** 创建提示标签 */
 - (void)ddCreateForLabel
{
    UIButton * remindButton = [[UIButton alloc] init];
    [remindButton setFrame:CGRectMake(0, btnNext.bottom + 10.0f, self.view.width, 40.0f)];
    [remindButton setTitle:@"3个月内只可更换一次手机号" forState:UIControlStateNormal];
    [remindButton.titleLabel setFont:kTimeFont];
    [remindButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
    remindButton.contentEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    remindButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);
    [remindButton setImage:[UIImage imageNamed:@"remind"] forState:UIControlStateNormal];
    [remindButton setUserInteractionEnabled:NO];
    [self.view addSubview:remindButton];
}



#pragma mark - Delegate
/**
    对文本进行约束
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //等到当前文本框操作的所有字符
    NSString *text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    text_str = [text_str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //根据tag值判断返回事件，是否可以继续编辑
    if (textField.tag == KTextTag)
    {
        //输入的长度到了11位,就停止编写
        if ([text_str length] > 11) {
            textField.text = [text_str substringToIndex:11];
            return false;
        }
        return true;
    } else {
        //如果是验证码，最多可以输入6位字符
        if ([text_str length] > 6) {
            textField.text = [text_str substringToIndex:6];
            return false;
        }
        return true;
    }
}

/**
 发送验证码事件
 */
- (void)onClickWithCodePwd:(id)sender
{
    NSString *textPhone = [textTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([textPhone length] == 0) {
        return;
    }
    if (![self isValidateMobile:textPhone])
    {
        [self displayForErrorMsg:@"手机号码输入格式有误"];
        return;
    }
    
    NSString *userPhoneNumber = [DDInterfaceTool getPhoneNumber];
    if ([textPhone isEqualToString:userPhoneNumber]) {
        [self displayForErrorMsg:@"不能是本帐号相同的手机号码"];
        return;
    }
    
    
    [self sendCodeWithPhone:textPhone];
    
    UIButton * _l_timeButton = (UIButton *)sender;
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [_l_timeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                
                [_l_timeButton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
                _l_timeButton.userInteractionEnabled = YES;
            });
        }else{
            
            [_l_timeButton setTitleColor:DDRGBColor(153, 153, 153) forState:UIControlStateNormal];
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_l_timeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _l_timeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 确认更换响应事件
 */
- (void)onClickWithNext:(UIButton *)sender
{
    NSString *str_Phone = [textTelephone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str_CodeP = [textCodePwd.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str_Phone length] == 0 || [str_CodeP length] == 0)
    {
        return;
    }
    if (![self isValidateMobile:str_Phone])
    {
        [self displayForErrorMsg:@"手机号码输入格式有误"];
        return;
    }
    if (![self isValidateNumber:str_CodeP] || [str_CodeP length] != 6)
    {
        [self displayForErrorMsg:@"验证码输入格式有误"];
        return;
    }
    //绑定手机号过程中，禁止按钮使用
    [sender setUserInteractionEnabled:false];
    
    [self updateWithPhone:str_Phone withCode:str_CodeP];
    
}

#pragma mark - Event Method
/**
 手机屏幕开始触摸事件
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //取消键盘编辑
    [self.view endEditing:false];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Setter && Getter

@end
