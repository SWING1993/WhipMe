//
//  DDLoginController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDLoginController.h"
#import "Constant.h"//全局常量类
#import "JJRegexKit.h"//正则表达式类
#import "DDRegistController.h"
#import "DDForgetPassController.h"
#import "DDPersonalCenterListController.h"
#import "DDHomeController.h"


#import "MBProgressHUD+MJ.h"


@interface DDLoginController ()<UITextFieldDelegate>


//手机号
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;

//登录密码
@property (strong, nonatomic) IBOutlet UITextField *passWordField;


//登录按钮
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

//忘记密码按钮
@property (strong, nonatomic) IBOutlet UIButton *forgetBtn;

//logo
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;

//导航栏右侧 注册按钮
@property (nonatomic, strong) UIBarButtonItem *registerBtn;


//用来获取正则表达式错误码
@property (nonatomic, strong) NSString *phoneCheckText;
@property (nonatomic, strong) NSString *passWordCheckText;


@end

@implementation DDLoginController

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DDRandColor;
    
    [self initNavigationController];
    [self createLogo];
    [self createTextField];
    [self createLoginButton];
    [self createForgetButton];
    [self createRegistButton];
    

    //设置代理
    self.phoneNumberField.delegate = self;
    self.passWordField.delegate = self;

}


#pragma mark - 初始化视图
//初始化TextField
- (void)createTextField
{
    //1.初始化手机号的textField

    self.phoneNumberField.backgroundColor = [UIColor whiteColor];
    self.phoneNumberField.borderStyle = UITextBorderStyleRoundedRect;
    //修改键盘类型
    self.phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneNumberField.returnKeyType = UIReturnKeyNext;
    //设置placeholder
    UIColor *placeHolderColor = [UIColor grayColor];
    UIFont *placeHolderFont = [UIFont systemFontOfSize:16];
    self.phoneNumberField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:DDMobilePlaceHolder attributes:@{NSForegroundColorAttributeName:placeHolderColor,NSFontAttributeName:placeHolderFont}];
    //当编辑的时候显示清除按钮
    self.phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //2.初始化密码的textFiled

    self.passWordField.backgroundColor = [UIColor whiteColor];
    self.passWordField.borderStyle = UITextBorderStyleRoundedRect;
    //再次编辑时清空
    self.passWordField.clearsOnBeginEditing = YES;
    self.passWordField.placeholder = DDPassWordPlaceHolder;
    //当编辑的时候显示清除按钮
    self.passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //密码用*显示
    self.passWordField.secureTextEntry = YES;

}
//初始化Logo
- (void)createLogo
{
    self.logoImageView.image = [UIImage imageNamed:@"1"];
    self.logoImageView.layer.cornerRadius = 60;
    self.logoImageView.layer.masksToBounds = YES;
}
//初始化登录按钮
- (void)createLoginButton
{
    //开始时为灰色不能点击状态
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    //button为不可点击状态
    [self.loginBtn setUserInteractionEnabled:NO];
    //不显示高亮状态
    self.loginBtn.adjustsImageWhenHighlighted = NO;
    [self.loginBtn setTitle:DDLoginBtnText forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;

    //添加点击事件
    [self.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
//设置导航控制器
- (void) initNavigationController
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    //取消半透明
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1.0], NSFontAttributeName : [UIFont systemFontOfSize:24]}];
    self.navigationItem.title = DDDispalyName;
    
    //设置push到的ViewController上的返回按钮的样式
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
    
    //改变系统栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
//初始化注册按钮
- (void)createRegistButton
{
    self.registerBtn = [[UIBarButtonItem alloc]initWithTitle:DDRegisterBtnText style:UIBarButtonItemStyleBordered target:self action:@selector(registerBtnClick)];
    
    self.navigationItem.rightBarButtonItem = self.registerBtn;
}
//初始化忘记密码按钮
- (void)createForgetButton
{
    [self.forgetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.forgetBtn setTitle:DDForgetKeyBtnText forState:UIControlStateNormal];

    [self.forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 点击事件
//点击登录
- (void)loginBtnClick
{
    //判断
    if ([self checkOutTextFieldByZZ]) {
        //登陆到主页
        
    }else{

    }
    
}
//点击注册
- (void)registerBtnClick
{
    DDRegistController *registController = [[DDRegistController alloc]init];
    [self.navigationController pushViewController:registController animated:YES];
}
//点击忘记密码
- (void)forgetBtnClick
{
    DDForgetPassController *forgetPassController = [[DDForgetPassController alloc]init];
    [self.navigationController pushViewController:forgetPassController animated:YES];
}




#pragma mark - TextFieldDelegate
//当点击了return
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.phoneNumberField == textField) {
        [self.passWordField becomeFirstResponder];
    }else if(self.passWordField == textField){
        [self.passWordField resignFirstResponder];
        [self loginBtnClick];
    }
    return YES;
}
//监听字符变化
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //一. 判断输入框, 设置两个输入框的最大输入长度
    if (self.phoneNumberField == textField) {
        NSString *getPhoneText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //1. 输入的长度到了11位,就停止编写
        if ([getPhoneText length]>11) {
            
            //[self.passWordField becomeFirstResponder];
            return NO;
        }
        //2.通过判断输入长度是否符合, 控制login按钮是否可点击(以及是否呈灰色)
        [self isButtonCanClick:getPhoneText andIdText:self.passWordField.text];
    }else if (self.passWordField == textField){
        NSString *getPassWord = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if([getPassWord length]>16)//限制密码输入不能超过16位, 否则不能输入
        {
            [self.passWordField resignFirstResponder];
            return NO;
        }
        [self isButtonCanClick:self.phoneNumberField.text andIdText:getPassWord];
    }
    return YES;
}
//点击View,使textField失去焦点
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 验证方法
//正则表达式检验
- (BOOL)checkOutTextFieldByZZ
{
    self.passWordCheckText = nil;
    self.phoneCheckText = nil;
    //验证手机是错误的
    [JJRegexKit stringsSeparatedByText:self.phoneNumberField.text pattern:DDMobileCheck TextPart:^(JJTextPart *textPart) {
        self.phoneCheckText = textPart.text;
    }];
    //通过正则验证密码输入格式
    [JJRegexKit stringsSeparatedByText:self.passWordField.text pattern:DDPassWordCheck TextPart:^(JJTextPart *textPart) {
        self.passWordCheckText = textPart.text;
    }];
    
    if (self.phoneCheckText != nil||self.passWordCheckText != nil) {
        NSLog(@"进来了");
        [self textExample];
        return NO;
    }else{
        return YES;
    }
}
//判断是否符合条件, 提交按钮变的可以点击
- (void)isButtonCanClick:(NSString *)phoneText
               andIdText:(NSString *)passText
{
    if ([phoneText length] == 11 && [passText length]>=6 && [passText length]<=16) {
        
        [self.loginBtn setUserInteractionEnabled:YES];
        self.loginBtn.adjustsImageWhenHighlighted = YES;
        [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
    }else{
        [self.loginBtn setUserInteractionEnabled:NO];
        self.loginBtn.adjustsImageWhenHighlighted = NO;
        [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - 弹窗
- (void)textExample {
    [MBProgressHUD showError:@"手机号或密码输入有误"];
}

#pragma mark - 视图需要根据键盘上移





@end

