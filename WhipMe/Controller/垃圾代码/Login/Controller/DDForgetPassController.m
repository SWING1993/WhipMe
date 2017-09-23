//
//  DDForgetPassController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDForgetPassController.h"
#import "Constant.h"
#import "JJRegexKit.h"
#import "DDNewPassController.h"
#import "MBProgressHUD+MJ.h"
#define FORGETPASSWORD @"忘记密码"

@interface DDForgetPassController ()<UITextFieldDelegate>
//手机号输入框
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
//验证码输入框
@property (strong, nonatomic) IBOutlet UITextField *authCodeTextField;

//点击获取验证码
@property (strong, nonatomic) IBOutlet UIButton *getCodeButton;

//下一步按钮
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

//一分钟倒计时标签
@property (strong, nonatomic) UILabel *timeLabel;
//倒计时总时长
@property (assign, nonatomic) int totalTime;
//计时器
@property (strong, nonatomic) NSTimer *countDownTimer;




//验证手机号正则表达式
@property (strong, nonatomic) NSString *phoneCheckText;
//验证验证码正则表达式
@property (strong, nonatomic) NSString *authCodeCheckText;
@end

@implementation DDForgetPassController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    [self initNavigationController];
    [self createTextFieldView];
    [self createBtnView];
    
    
    self.authCodeTextField.delegate = self;
    self.phoneTextField.delegate = self;
    
    
    
}




#pragma mark - 初始化界面
//初始化textfield
- (void) createTextFieldView
{
    //1.手机号输入框

    self.phoneTextField.backgroundColor = [UIColor whiteColor];
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTextField.returnKeyType = UIReturnKeyNext;
    self.phoneTextField.placeholder = DDMobilePlaceHolder;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    //2.验证码输入框

    self.authCodeTextField.backgroundColor = [UIColor whiteColor];
    self.authCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.authCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.authCodeTextField.returnKeyType = UIReturnKeyDone;
    self.authCodeTextField.placeholder = DDAuthCodePlaceHolder;

}
//初始化button
- (void) createBtnView
{
    //1.获取验证码按钮

    [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.getCodeButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    //[self.getCodeButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
    [self.getCodeButton setTitle:DDAuthCodeBtnTitle forState:UIControlStateNormal];
    //button为不可点击状态
    [self.getCodeButton setUserInteractionEnabled:NO];
    //不显示高亮状态
    self.getCodeButton.adjustsImageWhenHighlighted = NO;
    self.getCodeButton.layer.cornerRadius = 4;
    self.getCodeButton.layer.masksToBounds = YES;
    //添加点击事件
    [self.getCodeButton addTarget:self action:@selector(getCodeClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //2.下一步按钮
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    //[self.nextButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
    [self.nextButton setTitle:DDNextStepBtnTitle forState:UIControlStateNormal];
    //button为不可点击状态
    [self.nextButton setUserInteractionEnabled:NO];
    //不显示高亮状态
    self.nextButton.adjustsImageWhenHighlighted = NO;
    self.nextButton.layer.cornerRadius = 4;
    self.nextButton.layer.masksToBounds = YES;
    //添加点击事件
    [self.nextButton addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
}
//初始化倒计时视图
- (void) createCountDownView
{
    self.timeLabel = [[UILabel alloc]initWithFrame:self.getCodeButton.frame];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.timeLabel];
    
    //设置倒计时总时长
    self.totalTime = 60;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];//启动倒计时后会每秒钟调用一次方法 timeFireMethod
    
    //设置倒计时显示的时间
    self.timeLabel.text=[NSString stringWithFormat:@"%d%@",self.totalTime,DDAfterCountDownText];
}
//设置导航控制器
- (void) initNavigationController
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    //取消半透明
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1.0], NSFontAttributeName : [UIFont systemFontOfSize:24]}];
    self.navigationItem.title = FORGETPASSWORD;
    
    //设置按钮字体颜色
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    //改变系统栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}




#pragma mark - action
//获取验证码点击
- (void)getCodeClick
{
    //验证
    if ([self isPhoneNumberTextTrue]) {
        [self.authCodeTextField becomeFirstResponder];
        self.getCodeButton.hidden = YES;
        [self createCountDownView];
    }
}
//下一步点击事件
- (void)nextStepClick
{

    DDNewPassController *newPassController = [[DDNewPassController alloc]init];
    [self.navigationController pushViewController:newPassController animated:YES];

}
//嘟嘟快递服务协议点击事件
- (void)protocolClick
{
    
}




#pragma mark - delegate
//当点击了return
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    [self.authCodeTextField resignFirstResponder];
    return YES;
}
//监听字符变化
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //一. 判断输入框, 设置两个输入框的最大输入长度
    if (self.phoneTextField == textField) {
        NSString *getPhoneText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //1. 输入的长度到了11位,就停止编写
        if ([getPhoneText length]>11) {
            return NO;
        }
        //2.通过判断输入长度是否符合, 控制login按钮是否可点击(以及是否呈灰色)
        if ([getPhoneText length]==11) {
            
            [self.getCodeButton setUserInteractionEnabled:YES];
            self.getCodeButton.adjustsImageWhenHighlighted = YES;
            [self.getCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.getCodeButton setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
            [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.getCodeButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
            
            
            if ([self.authCodeTextField.text length]==4) {
                [self.nextButton setUserInteractionEnabled:YES];
                self.nextButton.adjustsImageWhenHighlighted = YES;
                [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.nextButton setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.nextButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
                return YES;
            }else{
                [self.nextButton setUserInteractionEnabled:NO];
                self.nextButton.adjustsImageWhenHighlighted = NO;
                [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.nextButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                
            }
        }else{
            [self.nextButton setUserInteractionEnabled:NO];
            self.nextButton.adjustsImageWhenHighlighted = NO;
            [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nextButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            
            [self.getCodeButton setUserInteractionEnabled:NO];
            self.getCodeButton.adjustsImageWhenHighlighted = NO;
            [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.getCodeButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        }
    }else if (self.authCodeTextField == textField){
        NSString *getAuthCode = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if([getAuthCode length]>4)//限制密码输入不能超过4位, 否则不能输入
        {
            [self.authCodeTextField resignFirstResponder];
            return NO;
        }
        NSLog(@"%lu",(unsigned long)[getAuthCode length]);
        if ([getAuthCode length]==4) {
            
            if ([self.phoneTextField.text length]==11) {
                [self.nextButton setUserInteractionEnabled:YES];
                self.nextButton.adjustsImageWhenHighlighted = YES;
                [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.nextButton setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.nextButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
                return YES;
            }else{
                [self.nextButton setUserInteractionEnabled:NO];
                self.nextButton.adjustsImageWhenHighlighted = NO;
                [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.nextButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            }
        }else{
            [self.nextButton setUserInteractionEnabled:NO];
            self.nextButton.adjustsImageWhenHighlighted = NO;
            [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nextButton setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            return YES;
        }
    }
    return YES;
}
//点击View,使textField失去焦点
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




#pragma 计时器方法
//每秒被调用的计时器
- (void)timeFireMethod
{
    //倒计时-1
    self.totalTime--;
    //修改倒计时标签现实内容
    self.timeLabel.text=[NSString stringWithFormat:@"%d秒后重发",self.totalTime];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.totalTime==0){
        [self.countDownTimer invalidate];
        self.getCodeButton.hidden = NO;
        [self.timeLabel removeFromSuperview];
    }
}



#pragma mark - 判断方法
- (BOOL)isPhoneNumberTextTrue
{
    self.phoneCheckText = nil;
    
    //验证是否正确的手机号
    //1.如果手机号有误
    [JJRegexKit stringsSeparatedByText:self.phoneTextField.text pattern:DDMobileCheck TextPart:^(JJTextPart *textPart) {
        self.phoneCheckText = textPart.text;
        
    }];
    if (self.phoneCheckText != nil) {
        [self textExample];
        return NO;
    }else{
        return YES;
    }
    
}




#pragma mark - 弹窗
- (void)textExample
{
    [MBProgressHUD showError:@"手机号不存在, 验证码发送失败，请确认手机号是否正确"];
}




#pragma mark - 视图需要根据键盘上移
- (void)makeViewUp:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y += 100;
    view.frame = frame;
}

@end

