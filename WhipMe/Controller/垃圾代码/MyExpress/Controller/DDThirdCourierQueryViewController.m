//
//  ThirdCourierQueryViewController.m
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

/**
    第三方快递查询视图
 */

//多个UITextField对应的tag值基数
#define KThirdCQText 7777

#import "DDThirdCourierQueryViewController.h"
#import "DDCourierCompanyViewController.h"
#import "DDCQDetailViewController.h"

//自定义的消息提示窗口
#import "DDAlertView.h"

@interface DDThirdCourierQueryViewController () <UITextFieldDelegate>

/** 快递单号书写框 */
@property (nonatomic, strong) UITextField *textNumbers;

/** 快递单号书写框 */
@property (nonatomic, strong) UITextField *textCourier;

@end

@implementation DDThirdCourierQueryViewController
@synthesize textNumbers;
@synthesize textCourier;

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
    [self.navigationItem setTitle:@"快递查询"];

    //配置导航栏
    [self dispositionForNavigationBar];
    
    //创建"请输入快递单号"和"请选择快递公司"的输入框视图
    [self ddCreateForTextField];
    
    //创建开始查询按钮
    [self ddCreateForButton];
    
}

#pragma mark - 类的对象方法:初始化页面
/**
    已经进入下一个节目设置的默认返回按钮，基于系统UINavigationController属性
 */
- (void)dispositionForNavigationBar
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
}

/**
    创建"请输入快递单号"和"请选择快递公司"的输入框视图
 */
- (void)ddCreateForTextField
{
    //循环创建UITextField，根据下标判断“快递单号”和“快递公司”
    NSArray *arrayTitles = [NSArray arrayWithObjects:@"请输入快递单号",@"请选择快递公司", nil];
    for (int i=0; i<arrayTitles.count; i++)
    {
        //初始化输入框
        UITextField *textItem = [[UITextField alloc] init];
        [textItem setFrame:CGRectMake( kMargin*2.0f, kMargin*5.0f + i*64.0f, self.view.width - kMargin*4.0f, 44.0f)];
        [textItem setBackgroundColor:[UIColor whiteColor]];
        [textItem.layer setBorderWidth:1.0f];
        [textItem.layer setBorderColor:BORDER_COLOR.CGColor];
        [textItem.layer setCornerRadius:2.0f];
        [textItem.layer setMasksToBounds:true];
        
        [textItem setTextAlignment:NSTextAlignmentLeft];
        [textItem setTextColor:CONTENT_COLOR];
        [textItem setDelegate:self];
        [textItem setTag:KThirdCQText + i];
        [textItem setFont:kTitleFont];
        [textItem setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textItem setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textItem setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:arrayTitles[i] attributes:@{NSForegroundColorAttributeName:CONTENT_COLOR}]];
        [self.view addSubview:textItem];
        
        //输入框左边的图标icon
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setFrame:CGRectMake(0, 0, textItem.height, textItem.height)];
        [leftView setBackgroundColor:[UIColor redColor]];
        [textItem setLeftView:leftView];
        [textItem setLeftViewMode:UITextFieldViewModeAlways];
        
        //输入框右边的按钮选择事件，对应：条形码扫描和快递公司列表选择
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView setFrame:CGRectMake(0, 0, textItem.height, textItem.height)];
        [rightView setBackgroundColor:[UIColor yellowColor]];
        [rightView setAdjustsImageWhenHighlighted:false];
        [rightView setTag:KThirdCQText + 10 + i];
        [rightView addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [textItem setRightView:rightView];
        [textItem setRightViewMode:UITextFieldViewModeAlways];
        
        if (i == 0) {
            textNumbers = textItem;
        } else {
            textCourier = textItem;
        }
    }
    
}

/**
    创建开始查询按钮
 */
- (void)ddCreateForButton
{
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setFrame:CGRectMake( textCourier.left, textCourier.bottom + kMargin*4.0f, textCourier.width, 44.0f)];
    [btnSubmit.layer setCornerRadius:2.0f];
    [btnSubmit.layer setMasksToBounds:true];
    [btnSubmit setBackgroundImage:[UIImage imageWithDrawColor:RED_COLOR withSize:btnSubmit.bounds] forState:UIControlStateNormal];
    [btnSubmit setBackgroundImage:[UIImage imageWithDrawColor:REDON_COLOR withSize:btnSubmit.bounds] forState:UIControlStateHighlighted];
    [btnSubmit.titleLabel setFont:kContentFont];
    [btnSubmit setTitle:@"开始查询" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(onClickWithSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
}

#pragma mark - 类的对象方法:点击事件监听
/**
    开始查询按钮的事件，查询成功好进入： 快递的查询结果视图，失败提示消息。
 */
- (void)onClickWithSubmit:(id)sender
{
    DDAlertView *alertView = [[DDAlertView alloc] initWithTitle:@"查无结果，请确定单号或快递公司是否正确！" delegate:nil cancelTitle:@"确定" nextTitle:nil];
    [alertView show];
//    DDCQDetailViewController *detailControl = [[DDCQDetailViewController alloc] init];
//    [self.navigationController pushViewController:detailControl animated:true];
}

/**
    输入框对应的选择事件
 */
- (void)onClickWithItem:(UIButton *)sender
{
    NSInteger index = sender.tag % KThirdCQText;
    
    if (index%10 == 0) {
        //条形码扫描
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"条形码扫描" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    } else {
        //快递公司列表
        DDCourierCompanyViewController *courierCompanyControl = [[DDCourierCompanyViewController alloc] init];
        [self.navigationController pushViewController:courierCompanyControl animated:true];
    }

}

@end
