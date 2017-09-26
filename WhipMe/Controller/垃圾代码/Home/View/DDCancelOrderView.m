//
//  DDCancelOrderView.m
//  DDExpressClient
//
//  Created by Jadyn on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCancelOrderView.h"
#import "Constant.h"
#import "UIView+Size.h"

NSString *const ContinueButtonTitle = @"继续等待";
NSString *const CancelOrderButtonTitle = @"取消订单";
NSString *const CancelButtonTitle = @"确定取消";

NSString *const DDTitle_Text = @"快递小哥就在附近";
NSString *const DDSubTitle_Text = @"再等会吧";
NSString *const DDConfirmCancel_Text = @"当前可免费取消";
NSString *const DDConfirmCancel_SubTitle = @"快递员还有1km就到了,请再耐心等待会吧";


@interface DDCancelOrderView()
{
    /** 根控制器 */
    //UIWindow *_window;
}
/** 背景黑色半隐身视图 */
@property (nonatomic, strong) UIButton *buttonBlack;
/** 弹窗视图 */
@property (nonatomic, strong) UIView *viewCurrent;
/** 标题图片 */
@property (nonatomic, strong) UIImageView *imageIcon;
/** 避免重复弹窗 */
@property (nonatomic, assign) BOOL isShowing;
/**继续等待按钮*/
@property (nonatomic, strong) UIButton *continueButton;
/**取消订单按钮*/
@property (nonatomic, strong) UIButton *cancelButton;
/**弹窗标题*/
@property (nonatomic, strong) UILabel *alertTitleLabel;
/** 弹窗小标题 */
@property (nonatomic, strong) UILabel *alertSubTitleLabel;
/** 确定取消按钮 */
@property (nonatomic, strong) UIButton *confirmCancelButton;
/** 视图类型 */
@property (nonatomic, assign) DDCancelOrderViewStyle viewDDStyle;

@end

@implementation DDCancelOrderView
@synthesize buttonBlack;
@synthesize viewCurrent;
@synthesize imageIcon;

@synthesize alertTitleLabel;
@synthesize alertSubTitleLabel;

@synthesize cancelButton;
@synthesize continueButton;
@synthesize confirmCancelButton;

- (instancetype)initWithDelegate:(id<DDCancelOrderViewDelegate>)delegate withStyle:(DDCancelOrderViewStyle)style
{
    self = [super init];
    if (self)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(DDSCreenBounds), CGRectGetHeight(DDSCreenBounds))];
        [window addSubview:self];
        
        self.viewDDStyle = style;
        self.delegate = delegate;
        
        /** 初始化视图 */
        [self createBackView];
        
        /** 视图的删除方法 */
        DDRemoveNotificationWithName(KREMOVE_CANCEL_ORDER_VIEW);
        DDAddNotification(@selector(dismissAlert), KREMOVE_CANCEL_ORDER_VIEW);
    }
    return self;
}

/** 初始化视图 */
- (void)createBackView
{
    //灰色背景
    buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBlack setFrame:CGRectMake(0, 0, CGRectGetWidth(DDSCreenBounds), CGRectGetHeight(DDSCreenBounds))];
    [buttonBlack setBackgroundColor:[UIColor blackColor]];
    [buttonBlack setAlpha:0.5f];
    [self addSubview:buttonBlack];
    
    //中心白色内容视图
    [self ddCreateWithCurrentView];
    
}

/** 初始化弹窗视图 */
- (void)ddCreateWithCurrentView
{
    /** 弹窗视图 */
    viewCurrent = [[UIView alloc] init];
    [viewCurrent setFrame:CGRectMake(33.0f, buttonBlack.centery - 125.0f, buttonBlack.width - 33*2.0f, 250.0f)];
    [viewCurrent setBackgroundColor:[UIColor whiteColor]];
    [viewCurrent.layer setCornerRadius:5.0f];
    [viewCurrent.layer setMasksToBounds:true];
    [self addSubview:viewCurrent];
    
    //中间的图片icon
    imageIcon = [[UIImageView alloc] init];
    [imageIcon setFrame:CGRectMake(viewCurrent.centerx - 78.0f, 25.0f, 156.0f, 94.0f)];
    [imageIcon setImage:[UIImage imageNamed:DDCancelOrderTitleIcon]];
    [imageIcon setContentMode:UIViewContentModeCenter];
    [viewCurrent addSubview:imageIcon];
    
    //主标题
    alertTitleLabel = [[UILabel alloc] init];
    [alertTitleLabel setFrame:CGRectMake(20.0f, imageIcon.bottom + 20.0f, viewCurrent.width-40, 19.0f)];
    [alertTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [alertTitleLabel setFont:kButtonFont];
    [alertTitleLabel setTextColor:TITLE_COLOR];
    [viewCurrent addSubview:alertTitleLabel];
    
    //副标题
    alertSubTitleLabel = [[UILabel alloc] init];
    [alertSubTitleLabel setFrame:CGRectMake(alertTitleLabel.left, alertTitleLabel.bottom + 8.0f, alertTitleLabel.width, 14.0f)];
    [alertSubTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [alertSubTitleLabel setFont:kTitleFont];
    [alertSubTitleLabel setTextColor:TIME_COLOR];
    [viewCurrent addSubview:alertSubTitleLabel];
    
    //@"继续等待"
    cancelButton = [[UIButton alloc] init];
    [cancelButton setFrame:CGRectMake(alertTitleLabel.left, viewCurrent.height - 55.0f, viewCurrent.width/2.0f - 27.5f, 30.0f)];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton setTitle:CancelOrderButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:kContentFont];
    [cancelButton.layer setBorderWidth:1];
    [cancelButton.layer setBorderColor:KPlaceholderColor.CGColor];
    [cancelButton.layer setCornerRadius:cancelButton.height/2.0f];
    [cancelButton.layer setMasksToBounds:true];
    [viewCurrent addSubview:cancelButton];
    
    //@"取消订单"
    continueButton = [[UIButton alloc]init];
    [continueButton setFrame:CGRectMake(viewCurrent.width/2.0f + 7.5f, cancelButton.top, cancelButton.width, cancelButton.height)];
    [continueButton setBackgroundColor:DDGreen_Color];
    [continueButton setTitle:ContinueButtonTitle forState:UIControlStateNormal];
    [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [continueButton.titleLabel setFont:kContentFont];
    [continueButton.layer setCornerRadius:continueButton.height/2.0f];
    [continueButton.layer setMasksToBounds:true];
    [continueButton addTarget:self action:@selector(onClickWithContinue) forControlEvents:UIControlEventTouchUpInside];
    [viewCurrent addSubview:continueButton];
    
    if (self.viewDDStyle == DDCancelOrderViewStyleWaitCourier)
    {
        imageIcon.image = [UIImage imageNamed:DDCancelOrderTitleIcon];
        [alertTitleLabel setText:DDTitle_Text];
        [alertSubTitleLabel setText:DDSubTitle_Text];
        [cancelButton addTarget:self action:@selector(onClickWithCancel) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        imageIcon.image = [UIImage imageNamed:@"cancelAlertImage2"];
        [alertTitleLabel setText:DDConfirmCancel_Text];
        [alertSubTitleLabel setText:DDConfirmCancel_SubTitle];
        [cancelButton addTarget:self action:@selector(onClickWithConfirmCancel) forControlEvents:UIControlEventTouchUpInside];

    }
    

}

#pragma mark - 点击事件
/** 确认取消按钮(点击事件) */
- (void)onClickWithCancel
{
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(cancelOrderView:withButtonIndex:)])
    {
        [self.delegate cancelOrderView:self withButtonIndex:DDCancelOrderViewButtonCancel];
    }
}

/** 继续等待按钮(点击事件) */
- (void)onClickWithContinue
{
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(cancelOrderView:withButtonIndex:)])
    {
        [self.delegate cancelOrderView:self withButtonIndex:DDCancelOrderViewButtonContinue];
    }
}

/** 确定取消按钮点击事件 */
- (void)onClickWithConfirmCancel
{
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(cancelOrderView:withButtonIndex:)])
    {
        [self.delegate cancelOrderView:self withButtonIndex:DDCancelOrderViewButtonConfirmCancel];
    }
}

/** 视图的显示方法 */
- (void)show
{
//    if (self.isShowing) {
//        return;
//    }
    
    //[_window addSubview:self];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    [self setAlpha:0];
    [UIView animateWithDuration:0.35f animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        //self.isShowing = YES;
        
    }];
}
/** 视图的删除方法 */
- (void)dismissAlert
{
//    if (!self.isShowing) {
//        return;
//    }
    
    [UIView animateWithDuration:0.35f animations:^(void) {
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        //[self removeFromSuperview];
        //DDRemoveNotificationWithName(KREMOVE_CANCEL_ORDER_VIEW);
        //self.isShowing = NO;
    }];
}

@end
