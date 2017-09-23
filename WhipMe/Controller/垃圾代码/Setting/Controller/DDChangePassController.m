//
//  DDChangePassController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
#define KTextTag 7777

#import "DDChangePassController.h"

@interface DDChangePassController () <UITextFieldDelegate>

/** 原密码 */
@property (nonatomic, strong) UITextField *textNowPwd;
/** 新密码 */
@property (nonatomic, strong) UITextField *textNewPwd;
/** 重复新密码 */
@property (nonatomic, strong) UITextField *textNewTwo;
/** 下一步操作按钮 */
@property (nonatomic, strong) UIButton *btnNext;


@end

@implementation DDChangePassController
@synthesize textNowPwd;
@synthesize textNewPwd;
@synthesize textNewTwo;

@synthesize btnNext;

#pragma mark - 初始化
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:KBackground_COLOR];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"修改密码" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
  
    // 初始化文本框，以Tag下标判断
    // 包含：@"请输入原密码",@"请输入新密码",@"请再次输入密码"
    [self ddCreateForTextField];
    
    // 创建确定按钮
    [self ddCreateForButton];
    
}

#pragma mark - 类对象方法:初始化页面
/**
    初始化文本框，以Tag下标判断
    包含：@"请输入原密码",@"请输入新密码",@"请再次输入密码"
 */
- (void)ddCreateForTextField
{
    //循环创建文本框
    NSArray *arrayTitles = [NSArray arrayWithObjects:@"请输入原密码",@"请输入新密码",@"请再次输入密码", nil];
    for (int i=0; i<arrayTitles.count; i++)
    {
        //初始化文本框对象
        UITextField *textItem = [[UITextField alloc] init];
        [textItem setFrame:CGRectMake( kMargin*2.0f, KNavHeight + kMargin*2.0f + i*44.0f, self.view.width - kMargin*4.0f, 34.0f)];
        [textItem setBackgroundColor:[UIColor whiteColor]];
        [textItem.layer setBorderWidth:1.0f];
        [textItem.layer setBorderColor:BORDER_COLOR.CGColor];
        [textItem.layer setCornerRadius:2.0f];
        [textItem.layer setMasksToBounds:true];
        
        [textItem setTextAlignment:NSTextAlignmentLeft];
        [textItem setTextColor:TITLE_COLOR];
        [textItem setDelegate:self];
        [textItem setTag:KTextTag + i];
        [textItem setFont:kTitleFont];
        [textItem setKeyboardType:UIKeyboardTypeAlphabet];
        [textItem setSecureTextEntry:YES];
        [textItem setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textItem setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textItem setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:arrayTitles[i] attributes:@{NSForegroundColorAttributeName:HIGHLIGHT_COLOR}]];
        [self.view addSubview:textItem];
        
        //输入框左边的边距
        UIView *leftView = [[UIView alloc] init];
        [leftView setFrame:CGRectMake(0, 0, kMargin, textItem.height)];
        [leftView setBackgroundColor:[UIColor clearColor]];
        [textItem setLeftView:leftView];
        [textItem setLeftViewMode:UITextFieldViewModeAlways];
        
        //输入框右边的边距
        UIView *rightView = [[UIView alloc] init];
        [rightView setFrame:CGRectMake(0, 0, kMargin, textItem.height)];
        [rightView setBackgroundColor:[UIColor clearColor]];
        [textItem setRightView:rightView];
        [textItem setRightViewMode:UITextFieldViewModeAlways];
        
        if (i == 0) {
            textNowPwd = textItem;
        } else if (i == 1) {
            textNewPwd = textItem;
        } else {
            textNewTwo = textItem;
        }
    }
}

/**
    创建确定按钮
 */
- (void)ddCreateForButton
{
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext setFrame:CGRectMake( textNewTwo.left, textNewTwo.bottom + 30.0f, textNewTwo.width, 40.0f)];
    [btnNext.layer setCornerRadius:2.0f];
    [btnNext.layer setMasksToBounds:true];
    [btnNext setBackgroundImage:[UIImage imageWithDrawColor:RED_COLOR withSize:btnNext.bounds] forState:UIControlStateNormal];
    [btnNext setBackgroundImage:[UIImage imageWithDrawColor:REDON_COLOR withSize:btnNext.bounds] forState:UIControlStateHighlighted];
    [btnNext.titleLabel setFont:kContentFont];
    [btnNext setTitle:@"确定" forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(onClickWithNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
}

#pragma mark - 类对象方法:监听点击
/**
    确定按钮的响应事件
 */
- (void)onClickWithNext:(id)sender
{
    
}

/**
    手机屏幕开始触摸事件
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //取消键盘编辑
    [self.view endEditing:false];
}

#pragma mark - textField 代理方法
/**
    监听 textField 的输入域变化
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断字符串的最大长度位16
    NSString *text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text_str.length >= 16) {
        [textField setText:[text_str substringToIndex:16]];
    }
    return true;
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
