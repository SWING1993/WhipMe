//
//  DDExchangeCouponController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDExchangeCouponController.h"
#import "Constant.h"
#import "DDExchangedHistoryController.h"
#import "MBProgressHUD+MJ.h"
#import "DDWebViewController.h"

@interface DDExchangeCouponController () <DDInterfaceDelegate, UITextFieldDelegate>

/** 网络请求 */
@property (nonatomic, strong) DDInterface *exchangeCouponInterface;

/** 兑换按钮 */
@property (nonatomic,strong) UIButton *exchangeBtn;

/** 优惠码输入框 */
@property (nonatomic,strong) UITextField *couponTextField;

@end

@implementation DDExchangeCouponController

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    /**
     当前视图导航栏的右边“规则”按钮，已经进入下一个节目设置的默认返回按钮，基于系统UINavigationController属性
     */
    [self dispositionForNavigationBar];

    [self setItems];
}

#pragma mark - 对象方法:设置页面

/**
 当前视图导航栏的右边“规则”按钮，已经进入下一个节目设置的默认返回按钮，基于系统UINavigationController属性
 */
- (void)dispositionForNavigationBar
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"优惠券" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self adaptFirstRightItemWithTitle:@"兑换规则"];
}

/**
 设置输入框及按钮以及在页面中的约束
 */
- (void)setItems
{
    //初始化输入框
    UITextField *couponTextField = [[UITextField alloc] init];
    [couponTextField setFrame:CGRectMake(15.0f, KNavHeight+ 40.0f, self.view.width - 30.0f, 40.0f)];
    [couponTextField setBackgroundColor:[UIColor clearColor]];
    [couponTextField setDelegate:self];
    [couponTextField setFont:kTitleFont];
    [couponTextField setTextColor:TIME_COLOR];
    [couponTextField setPlaceholder:@"请输入优惠码"];
    [couponTextField setValue:KPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [couponTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [couponTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:couponTextField];
    self.couponTextField = couponTextField;

    //下划线View
    UIView *underLineView = [[UIView alloc] init];
    [underLineView setFrame:CGRectMake(couponTextField.left, couponTextField.bottom - 5.0f, couponTextField.width, 0.5f)];
    [underLineView setBackgroundColor:BORDER_COLOR];
    [self.view addSubview:underLineView];
    
    //初始化兑换按钮
    UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeBtn setFrame:CGRectMake(couponTextField.left, couponTextField.bottom + 30.0f, couponTextField.width, 40.0f)];
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeBtn setUserInteractionEnabled:false];
    [exchangeBtn setBackgroundColor:KPlaceholderColor];
    [exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exchangeBtn.layer setCornerRadius:exchangeBtn.height/2.0f];
    [exchangeBtn.layer setMasksToBounds:true];
    [exchangeBtn addTarget:self action:@selector(exchangeCouponWithRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeBtn];
    self.exchangeBtn = exchangeBtn;
}

#pragma mark - Event Method
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickFirstRightItem
{
    DDWebViewController *controller = [[DDWebViewController alloc]init];
    controller.URLString = ExchangeRuleUrlStr;
    controller.navTitle = @"兑换规则";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (strText.length > 24) {
        [textField setText:[strText substringToIndex:24]];
        return false;
    }
    
    if (strText.length > 0) {
        self.exchangeBtn.userInteractionEnabled = YES;
        self.exchangeBtn.backgroundColor = DDGreen_Color;
    } else {
        self.exchangeBtn.userInteractionEnabled = NO;
        self.exchangeBtn.backgroundColor = KPlaceholderColor;
    }
    
    return YES;
}

- (void)couponTextFieldChange:(UITextField *)textField
{
    NSString *strText = [NSString stringWithFormat:@"%@",textField.text];
    if (strText.length > 24) {
        [textField setText:[strText substringToIndex:24]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:false];
}

/** 兑换优惠券 网络请求 */
- (void)exchangeCouponWithRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.couponTextField.text forKey:@"couCode"];
    
    if (!self.exchangeCouponInterface) {
        self.exchangeCouponInterface = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.exchangeCouponInterface interfaceWithType:INTERFACE_TYPE_EXCHANGE_COUPON param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.exchangeCouponInterface) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [MBProgressHUD showSuccess:@"兑换成功"];
            double delayTime = 0.7;
            __block UINavigationController *navController = self.navigationController;
            //            __block DDRootViewController *selfVc = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(delayTime * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataListByAddExchangeCoupon)]) {
                    [self.delegate reloadDataListByAddExchangeCoupon];
                }
                [navController popViewControllerAnimated:YES];
            });
        }
    }
}

@end
