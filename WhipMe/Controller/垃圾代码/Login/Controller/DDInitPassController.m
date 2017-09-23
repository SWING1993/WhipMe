//
//  DDInitPassController.m
//  DDExpressClient
//
//  Created by Jadyn on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDInitPassController.h"
#import "Constant.h"
#import "JJRegexKit.h"
#import "MBProgressHUD+MJ.h"

#define INITPASSWORD @"输入密码"

@interface DDInitPassController ()<UITextFieldDelegate>
//第一次输入密码
@property (strong, nonatomic) IBOutlet UITextField *firstPassWordField;
//第二次输入密码
@property (strong, nonatomic) IBOutlet UITextField *secondPassWordField;
//完成按钮
@property (strong, nonatomic) IBOutlet UIButton *achieveBtn;


//密码正则表达式验证码
@property (strong, nonatomic) NSString *passWordCheckText;
@end

@implementation DDInitPassController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    [self initNavigationController];
    [self createTextField];
    [self createButton];
    
    self.firstPassWordField.delegate = self;
    self.secondPassWordField.delegate = self;
}




#pragma mark - 初始化视图
//设置导航控制器
- (void) initNavigationController
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    //取消半透明
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1.0], NSFontAttributeName : [UIFont systemFontOfSize:24]}];
    self.navigationItem.title = INITPASSWORD;
    
    //设置按钮字体颜色
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    //改变系统栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
//初始化密码输入框
- (void)createTextField
{
    //1.第一次输入密码
    self.firstPassWordField.backgroundColor = [UIColor whiteColor];
    self.firstPassWordField.borderStyle = UITextBorderStyleRoundedRect;
    //再次编辑时清空*************
    self.firstPassWordField.clearsOnBeginEditing = NO;
    self.firstPassWordField.placeholder = @"请输入密码 (6-16位字符)";
    //当编辑的时候显示清除按钮
    self.firstPassWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.firstPassWordField.returnKeyType = UIReturnKeyNext;
    //密码用*显示
    self.firstPassWordField.secureTextEntry = YES;
    
    
    //第二次输入密码
    self.secondPassWordField.backgroundColor = [UIColor whiteColor];
    self.secondPassWordField.borderStyle = UITextBorderStyleRoundedRect;
    //再次编辑时清空*************
    self.secondPassWordField.clearsOnBeginEditing = NO;
    self.secondPassWordField.placeholder = @"请确认密码";
    //当编辑的时候显示清除按钮
    self.secondPassWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.secondPassWordField.returnKeyType = UIReturnKeyDone;
    //密码用*显示
    self.secondPassWordField.secureTextEntry = YES;
}
//初始化按钮
- (void)createButton
{
    //处于灰色状态
    [self.achieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    //button为不可点击状态
    [self.achieveBtn setUserInteractionEnabled:NO];
    //不显示高亮状态
    self.achieveBtn.adjustsImageWhenHighlighted = NO;
    [self.achieveBtn setTitle:@"完成" forState:UIControlStateNormal];
    //添加点击事件
    [self.achieveBtn addTarget:self action:@selector(achieveBtnClick) forControlEvents:UIControlEventTouchUpInside];
}





#pragma mark - click 事件
//完成按钮点击
- (void)achieveBtnClick
{
    //判断密码
    if ([self checkOutTextFieldByZZ]) {
        NSLog(@"密码输入格式没有错误");
    }
}




#pragma mark - delegate
//监听字符变化
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //一. 判断输入框, 设置两个输入框的最大输入长度
    if (self.firstPassWordField == textField) {
        NSString *getPassWord1 = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //1. 输入的长度到了11位,就停止编写
        if ([getPassWord1 length]>16) {
            return NO;
        }
        //2.通过判断输入长度是否符合, 控制login按钮是否可点击(以及是否呈灰色)
        if ([getPassWord1 length]>=6&&[getPassWord1 length]<=16) {
            if ([self.secondPassWordField.text length]>=6&&[self.secondPassWordField.text length]<=16) {
                [self.achieveBtn setUserInteractionEnabled:YES];
                self.achieveBtn.adjustsImageWhenHighlighted = YES;
                [self.achieveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                [self.achieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
                return YES;
            }else{
                [self.achieveBtn setUserInteractionEnabled:NO];
                self.achieveBtn.adjustsImageWhenHighlighted = NO;
                [self.achieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            }
        }else{
            [self.achieveBtn setUserInteractionEnabled:NO];
            self.achieveBtn.adjustsImageWhenHighlighted = NO;
            [self.achieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        }
    }else if (self.secondPassWordField == textField){
        NSString *getPassWord2 = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if([getPassWord2 length]>16)
        {
            return NO;
        }
        if ([getPassWord2 length]>=6&&[getPassWord2 length]<=16) {
            
            if ([self.firstPassWordField.text length]>=6&&[self.firstPassWordField.text length]<=16) {
                [self.achieveBtn setUserInteractionEnabled:YES];
                self.achieveBtn.adjustsImageWhenHighlighted = YES;
                [self.achieveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                [self.achieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateHighlighted];
                return YES;
            }else{
                [self.achieveBtn setUserInteractionEnabled:NO];
                self.achieveBtn.adjustsImageWhenHighlighted = NO;
                [self.achieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            }
        }else{
            [self.achieveBtn setUserInteractionEnabled:NO];
            self.achieveBtn.adjustsImageWhenHighlighted = NO;
            [self.achieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.achieveBtn setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            return YES;
        }
    }
    return YES;
}
//当点击了return
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //第一个输入框结束时  点击next   跳转到下一个输入框
    if (self.firstPassWordField == textField) {
        [self.secondPassWordField becomeFirstResponder];
    }else if (self.secondPassWordField == textField)
    {
        [self.secondPassWordField resignFirstResponder];
        [self achieveBtnClick];
    }
    return YES;
}
//点击View,使textField失去焦点
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



#pragma mark - 判断方法
//正则表达式判断
- (BOOL)checkOutTextFieldByZZ
{
    self.passWordCheckText = nil;
    //1.如果姓名格式有误
    [JJRegexKit stringsSeparatedByText:self.firstPassWordField.text pattern:DDPassWordCheck TextPart:^(JJTextPart *textPart) {
        self.passWordCheckText = textPart.text;
    }];
    
    
    //正则表达检验优先
    if (self.passWordCheckText != nil) {
        [self textExample:@"密码输入有误, 请输入6-16位有效字符"];
        return NO;
    }else if([self isPassWordSame]){
        return YES;
    }else{
        return NO;
    }
}
//密码相同判断
- (BOOL)isPassWordSame
{
    //判断两次密码是否一致
    if ([self.firstPassWordField.text isEqualToString:self.secondPassWordField.text] ) {
        return YES;
    }else
    {
        [self textExample:@"密码不一致, 两次密码不一致，请确认"];
        return NO;
    }
}




#pragma mark - 弹窗
- (void)textExample:(NSString *)text {
    [MBProgressHUD showError:text];   
}




#pragma mark - 视图需要根据键盘上移
- (void)makeViewUp:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y += 100;
    view.frame = frame;
}

@end
