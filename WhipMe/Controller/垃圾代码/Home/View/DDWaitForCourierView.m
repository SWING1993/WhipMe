//
//  DDWaitForCourierView.m
//  DDForCourierClient
//
//  Created by Jadyn on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDWaitForCourierView.h"
#import "Constant.h"
#import "DDInterface.h"
#import "DDLineView.h"
#import "DDStarGradeView.h"
#import "DDCourierDetail.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

/** 本视图的高 */
#define KViewFrame_H 290.0f

/**DDWaitForCourierView等待取件*/
NSString *const DDWaitTitleText = @"等待取件";
/**DDWaitForCourierView取消订单*/
NSString *const DDWaitCancelTitle = @"取消订单";
/**DDWaitForCourierView评分*/
NSString *const DDWaitForCourierViewScore = @"分";
/**DDWaitForCourierView送单数*/
NSString *const OrderNumber = @"单";
/**DDWaitForCourierView提示语*/
NSString *const MessageText = @"快递员将第一时间来取件，请您稍等，如您的计划有变，请在快递员取件之前取消订单，否则该订单将正常收费。";
/**DDWaitForCourierView由ta再寄一件按钮文字*/
NSString *const SendAgainOnlyText = @"由ta再寄一件";
/**DDWaitForCourierView换小哥再寄一件按钮文字*/
NSString *const SendAgainText = @"换小哥再寄一件";


@interface DDWaitForCourierView()

/** 主视图 */
@property (nonatomic, strong) UIView *viewContent;
/** 上层navigation视图 */
@property (nonatomic, strong) UIView *viewUpTitle;
/**中间白色的视图*/
@property (nonatomic, strong) UIView *viewCurrent;
/**标题*/
@property (nonatomic, strong) UILabel *lblTitle;
/**取消订单按钮*/
@property (nonatomic, strong) UIButton *btnCancel;
/**快递员logo*/
@property (nonatomic, strong) UIButton *courierLogo;
/**快递员所属公司*/
@property (nonatomic, strong) UILabel *courierCompany;
/**快递员名字*/
@property (nonatomic, strong) UILabel *courierName;
/**评星*/
@property (nonatomic, strong) DDStarGradeView *viewStar;
/**评分*/
@property (nonatomic, strong) UILabel *scoreLabel;
/**送单数*/
@property (nonatomic, strong) UILabel *sendNumberLabel;
/**电话按钮*/
@property (nonatomic, strong) UIButton *callCourierButton;
/**电话号码*/
@property (nonatomic, strong) NSString *telephoneNumber;
/**喇叭视图*/
@property (nonatomic, strong) UIImageView *hornImageView;
/**提示语*/
@property (nonatomic, strong) UIButton *contentLabel;
/**再来一单(换个人)*/
@property (nonatomic, strong) UIButton *sendAgainAnother;
/**再来一单(同个人)*/
@property (nonatomic, strong) UIButton *sendAgainOnly;
/**底层开合按钮*/
@property (nonatomic, strong) UIButton *slideButton;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) DDLineView *lineView;

@property (nonatomic, strong) UIButton *btnCourierInfo;

/** 视图类型 */
@property (nonatomic,assign) BOOL viewIsContracted;


@property (nonatomic,assign) CGFloat viewContentH;
@property (nonatomic,assign) CGFloat selfViewH;
@property (nonatomic,assign) CGFloat viewCurrentH;
@property (nonatomic,assign) CGFloat slideButtonY;

@end


@implementation DDWaitForCourierView
@synthesize viewContent;
@synthesize viewCurrent;
@synthesize viewUpTitle;
@synthesize lblTitle;
@synthesize btnCancel;

@synthesize courierName;
@synthesize courierCompany;
@synthesize courierLogo;
@synthesize scoreLabel;
@synthesize sendNumberLabel;

@synthesize callCourierButton;
@synthesize hornImageView;
@synthesize contentLabel;
@synthesize viewStar;

@synthesize sendAgainAnother;
@synthesize sendAgainOnly;
@synthesize slideButton;
@synthesize btnCourierInfo;

- (instancetype)initWithDelegate:(id<DDWaitForCourierViewDelegate>)delegate withStyle:(DDWaitForCourierViewStyle)style
{
    self = [super init];
    if (self)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self setFrame:CGRectMake(0, -KViewFrame_H, CGRectGetWidth(DDSCreenBounds), KViewFrame_H)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.viewIsContracted = style;
        self.delegate = delegate;
        
        //初始化视图
        [self createView];
        
        [window addSubview:self];
        
        [self setViewHeightWithAnimation:NO];
        
        DDRemoveNotificationWithName(KREMOVE_WAIT_EXPRESS_VIEW);
        DDAddNotification(@selector(dismissAlert), KREMOVE_WAIT_EXPRESS_VIEW);
        
    }
    return self;
}

/** 初始化上层navigation视图 */
- (void)ddCreateWithUpTitleView
{
    /** 上层navigation视图 */
    viewUpTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(DDSCreenBounds), 64.0f)];
    viewUpTitle.backgroundColor = [UIColor clearColor];
    [viewContent addSubview:viewUpTitle];
    
    /** 返回箭头按钮 */
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setFrame:CGRectMake(0, 20.0f, 44.0f, 44.0f)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setImage:[UIImage imageNamed:@"Back_White"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [viewUpTitle addSubview:backButton];
    
    /** 等待应答 */
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(85.0f, 20.0f, viewUpTitle.width - 85*2.0f, viewUpTitle.height - 20.0f)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:kButtonFont];
    [lblTitle setText:DDWaitTitleText];
    [viewUpTitle addSubview:lblTitle];
    
    /** 取消订单 */
    btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(viewUpTitle.width-85, lblTitle.top, 70.0f, viewUpTitle.height - lblTitle.top)];
    [btnCancel setTitle:DDWaitCancelTitle forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:kContentFont];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel setAdjustsImageWhenHighlighted:false];
    [btnCancel addTarget:self action:@selector(onClickWithCancel) forControlEvents:UIControlEventTouchUpInside];
    [viewUpTitle addSubview:btnCancel];
}

/** 初始化视图 */
- (void)createView
{
    //绿色背景视图
    viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-13.0f)];
    [viewContent setBackgroundColor:DDGreen_Color];
    [self addSubview:viewContent];
    
    /** 初始化上层navigation视图 */
    [self ddCreateWithUpTitleView];
    
    //中间框视图   可延展
    viewCurrent = [[UIView alloc] init];
    [viewCurrent setFrame:CGRectMake(15, btnCancel.bottom + 10.0f, viewContent.width-30, 185)];
    [viewCurrent setBackgroundColor:[UIColor whiteColor]];
    [viewCurrent.layer setCornerRadius:5.f];
    [viewContent.layer setMasksToBounds:true];
    [viewContent addSubview:viewCurrent];
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSlideButton:)];
    [viewCurrent addGestureRecognizer:panGesture];

    //快递员详情的点击按钮
    btnCourierInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCourierInfo setFrame:CGRectMake(0, 0, floorf(viewCurrent.width/3.0f*2.0f), 80.0f)];
    [btnCourierInfo setBackgroundColor:[UIColor clearColor]];
    [btnCourierInfo setAdjustsImageWhenHighlighted:false];
    [btnCourierInfo addTarget:self action:@selector(onClickWithCourierInfo:) forControlEvents:UIControlEventTouchUpInside];
    [viewCurrent addSubview:btnCourierInfo];
    
    //快递员Logo
    courierLogo = [[UIButton alloc] init];
    [courierLogo setFrame:CGRectMake(16, 16, 40, 40)];
    [courierLogo.layer setCornerRadius:courierLogo.height/2.0f];
    [courierLogo.layer setMasksToBounds:true];
    [courierLogo setUserInteractionEnabled:false];
    [viewCurrent addSubview:courierLogo];
    
    //快递员姓名
    courierName = [[UILabel alloc] init];
    [courierName setFrame:CGRectMake(66, 13, 120, 14)];
    [courierName setTextAlignment:NSTextAlignmentLeft];
    [courierName setTextColor:TITLE_COLOR];
    [courierName setFont:kTitleFont];
    [courierName setUserInteractionEnabled:false];
    [viewCurrent addSubview:courierName];
    
    //快递员所属公司
    courierCompany = [[UILabel alloc] init];
    [courierCompany setFrame:CGRectMake(66, 36, 100, 12)];
    [courierCompany setTextAlignment:NSTextAlignmentLeft];
    [courierCompany setTextColor:TIME_COLOR];
    [courierCompany setFont:kTimeFont];
    [courierCompany setUserInteractionEnabled:false];
    [viewCurrent addSubview:courierCompany];
    
    //快递员评星图
    viewStar = [[DDStarGradeView alloc] initWithFrame:CGRectMake(66, 53, 67, 14)];
    [viewStar setBackgroundColor:[UIColor clearColor]];
    [viewCurrent addSubview:viewStar];
    
    //快递员评分
    scoreLabel = [[UILabel alloc] init];
    [scoreLabel setFrame:CGRectMake(viewStar.right + 5.0f, 54, 26, 12)];
    [scoreLabel setBackgroundColor:DDGreen_Color];
    [scoreLabel.layer setCornerRadius:self.scoreLabel.height/2];
    [scoreLabel.layer setMasksToBounds:true];
    [scoreLabel setTextAlignment:NSTextAlignmentCenter];
    [scoreLabel setTextColor:[UIColor whiteColor]];
    [scoreLabel setFont:KCountFont];
    [viewCurrent addSubview:scoreLabel];
    
    //快递员送单数
    sendNumberLabel = [[UILabel alloc] init];
    [sendNumberLabel setFrame:CGRectMake(scoreLabel.right + 5.0f, 53, 41, 12)];
    [sendNumberLabel setTextAlignment:NSTextAlignmentCenter];
    [sendNumberLabel setTextColor:TIME_COLOR];
    [sendNumberLabel setFont:kTimeFont];
    [viewCurrent addSubview:sendNumberLabel];
    
    //电话Logo
    callCourierButton = [[UIButton alloc] init];
    [callCourierButton setFrame:CGRectMake(viewCurrent.width-57, 18, 43, 43)];
    [callCourierButton setBackgroundImage:[UIImage imageNamed:@"orderPhone"] forState:UIControlStateNormal];
    [callCourierButton addTarget:self action:@selector(onClickCallCourierButton) forControlEvents:UIControlEventTouchUpInside];
    [viewCurrent addSubview:callCourierButton];
    
    //虚线视图
    DDLineView *dottedLineView = [[DDLineView alloc] init];
    [dottedLineView setSize:CGSizeMake(viewCurrent.width, 1.0f)];
    [dottedLineView setOrigin:CGPointMake(0, 80)];
    [viewCurrent addSubview:dottedLineView];
    self.lineView = dottedLineView;
    //设置虚线
    [dottedLineView drawDashLineLength:4.0f lineSpacing:4.0f lineColor:BORDER_COLOR];
    
    UIView * contentView = [[UIView alloc] init];
    contentView.x = 0;
    contentView.y = 81;
    contentView.width = self.width;
    contentView.height = 100;
    
    //喇叭视图
    hornImageView = [[UIImageView alloc] init];
    [hornImageView setFrame:CGRectMake(16, 95, 15, 15)];
    [hornImageView setImage:[UIImage imageNamed:DDAssureIcon]];
    [viewCurrent addSubview:hornImageView];
    
    //介绍文字
    contentLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentLabel setFrame:CGRectMake(45, 94, viewCurrent.width-65, 54)];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [contentLabel setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [contentLabel.titleLabel setNumberOfLines:3];
    [viewCurrent addSubview:contentLabel];
    
    NSMutableParagraphStyle *_paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [_paragraphStyle setAlignment:NSTextAlignmentLeft];
    [_paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [_paragraphStyle setLineSpacing:5.0f];
    
    NSDictionary *attribute = @{NSFontAttributeName:kTimeFont, NSForegroundColorAttributeName:TIME_COLOR, NSParagraphStyleAttributeName:_paragraphStyle};
//    CGSize size_msg =[MessageText boundingRectWithSize:CGSizeMake(contentLabel.width, MAXFLOAT)
//                                               options:NSStringDrawingUsesLineFragmentOrigin
//                                            attributes:attribute
//                                               context:nil].size;
//    [contentLabel setSize:CGSizeMake(contentLabel.width, floorf(size_msg.height)+1.0f)];
    NSMutableAttributedString *att_str_text = [[NSMutableAttributedString alloc] initWithString:MessageText attributes:attribute];
    [contentLabel setAttributedTitle:att_str_text forState:UIControlStateNormal];
    
    CGSize size_send = [SendAgainText sizeWithAttributes:@{NSFontAttributeName:kTimeFont}];
    CGFloat sendButton_w = floorf(size_send.width + 30.0f);
    
    //让ta再来一单按钮
    sendAgainOnly = [[UIButton alloc] init];
    [sendAgainOnly setFrame:CGRectMake((viewCurrent.width - sendButton_w*2.0f - 15.0f)/2, contentLabel.bottom + 15.0f, sendButton_w, 30)];
    [sendAgainOnly setTitle:SendAgainOnlyText forState:UIControlStateNormal];
    [sendAgainOnly setTitleColor:DDGreen_Color forState:UIControlStateNormal];
    [sendAgainOnly.layer setCornerRadius:sendAgainOnly.height/2];
    [sendAgainOnly.layer setMasksToBounds:true];
    [sendAgainOnly.layer setBorderWidth:1.0f];
    [sendAgainOnly.layer setBorderColor:DDGreen_Color.CGColor];
    [sendAgainOnly.titleLabel setFont:kTitleFont];
    [sendAgainOnly addTarget:self action:@selector(onClickSendAgainWithSameCourier) forControlEvents:UIControlEventTouchUpInside];
    [viewCurrent addSubview:sendAgainOnly];
    
    //换个小哥再来一单按钮
    sendAgainAnother = [[UIButton alloc] init];
    [sendAgainAnother setFrame:CGRectMake(sendAgainOnly.right + 15.0f, sendAgainOnly.top, sendAgainOnly.width, sendAgainOnly.height)];
    [sendAgainAnother setTitle:SendAgainText forState:UIControlStateNormal];
    [sendAgainAnother setTitleColor:TIME_COLOR forState:UIControlStateNormal];
    [sendAgainAnother.layer setCornerRadius:sendAgainOnly.height/2];
    [sendAgainAnother.layer setMasksToBounds:true];
    [sendAgainAnother.layer setBorderWidth:1.0f];
    [sendAgainAnother.layer setBorderColor:KPlaceholderColor.CGColor];
    [sendAgainAnother.titleLabel setFont:kTitleFont];
    [sendAgainAnother addTarget:self action:@selector(onClickSendAgainWithAnotherCourier) forControlEvents:UIControlEventTouchUpInside];
    [viewCurrent addSubview:sendAgainAnother];
    //修改大小
    [viewCurrent setSize:CGSizeMake(viewCurrent.width, sendAgainAnother.bottom + 15.0f)];
    [viewContent setSize:CGSizeMake(viewContent.width, viewCurrent.bottom + 15.0f)];
    
    //开合按钮
    slideButton = [[UIButton alloc] init];
    [slideButton setSize:CGSizeMake(60.0f, 30.0f)];
    [slideButton setCenter:CGPointMake(viewContent.centerx, viewContent.bottom)];
    [slideButton setBackgroundColor:DDGreen_Color];
    [slideButton.layer setCornerRadius:slideButton.height/2];
    [slideButton.layer setMasksToBounds:true];
    [slideButton setAdjustsImageWhenHighlighted:false];
    [slideButton setImage:[UIImage imageNamed:@"reveal-icon"] forState:UIControlStateNormal];
    [slideButton addTarget:self action:@selector(onClickSlideButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:slideButton];
    //修改大小
    [self setSize:CGSizeMake(self.width, slideButton.bottom)];

    self.selfViewH = self.height;
    self.viewContentH = self.viewContent.height;
    self.viewCurrentH = self.viewCurrent.height;
    self.slideButtonY = self.slideButton.y;
}

/** 视图的显示方法 */
- (void)show
{
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    //self.hidden = NO;

    [UIView animateWithDuration:0.35f animations:^{
        self.y = 0;
    } completion:^(BOOL finished) {

    }];
}
/** 视图的删除方法 */
- (void)dismissAlert
{
    [UIView animateWithDuration:0.35f animations:^(void) {
        self.y = -(self.height+25);
    } completion:^(BOOL finished) {
        //self.hidden = YES;
    }];
}

- (void)setViewHeightWithAnimation:(BOOL)animate
{
    if (self.viewIsContracted) {
        if (animate) {
            [UIView animateWithDuration:0.25 animations:^{
                self.viewCurrent.height = self.viewCurrentH - 127;
                self.height = self.selfViewH - 127;
                self.viewContent.height = self.viewContentH - 127;
                self.slideButton.y = self.slideButtonY - 127;
                
            } completion:^(BOOL finished) {
                self.lineView.hidden = YES;
            }];
        } else {
            self.viewCurrent.height = self.viewCurrentH - 127;
            self.height = self.selfViewH - 127;
            self.viewContent.height = self.viewContentH - 127;
            self.slideButton.y = self.slideButtonY - 127;
        }

    } else {
        if (animate) {
            self.lineView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.viewCurrent.height = self.viewCurrentH;
                self.height = self.selfViewH;
                self.viewContent.height = self.viewContentH;
                self.slideButton.y = self.slideButtonY;
                
            } completion:^(BOOL finished) {
                
            }];
        } else {
            self.viewCurrent.height = self.viewCurrentH;
            self.height = self.selfViewH;
            self.viewContent.height = self.viewContentH;
            self.slideButton.y = self.slideButtonY;
        }

    }
    
    
}

#pragma mark - Button Click Event
/**
 *  换小哥再寄一件按钮点击事件
 */
- (void)onClickSendAgainWithAnotherCourier
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waitForCourierView:didClickSendAgainBtn: andIsSameCourier:)]) {
        [self.delegate waitForCourierView:self didClickSendAgainBtn:self.courierDetail andIsSameCourier:NO];
    }
}
/**
 *  由ta再寄一件按钮点击事件(追单)
 */
- (void)onClickSendAgainWithSameCourier
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waitForCourierView:didClickSendAgainBtn:andIsSameCourier:)]) {
        [self.delegate waitForCourierView:self didClickSendAgainBtn:self.courierDetail andIsSameCourier:YES];
    }
}

/**
 *  电话按钮点击事件
 */
- (void)onClickCallCourierButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waitForCourierView:didClickPhoneCallBtn:)]) {
        [self.delegate waitForCourierView:self didClickPhoneCallBtn:self.courierDetail];
    }
}

/**
 *  快递员logo按钮点击事件
 */
- (void)onClickWithCourierInfo:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waitForCourierView:didClickCourierDetailBtn:)]) {
        [self.delegate waitForCourierView:self didClickCourierDetailBtn:self.courierDetail];
    }
}
/**
 *  取消订单按钮点击事件
 */
- (void)onClickWithCancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waitForCourierView:didClickCancelBtn:)]) {
        [self.delegate waitForCourierView:self didClickCancelBtn:self.courierDetail];
    }
}


/**
 *  收放按钮点击
 */
- (void)onClickSlideButton
{
    self.viewIsContracted = !self.viewIsContracted;
    [self setViewHeightWithAnimation:YES];
}

- (void)panSlideButton:(UIPanGestureRecognizer*)panGesture
{
    CGPoint transPoint = [panGesture translationInView:self.viewCurrent];
    [panGesture setTranslation:CGPointZero inView:self.viewCurrent];
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        if (self.height + transPoint.y < self.selfViewH - 127
            || self.height + transPoint.y > self.selfViewH) {
            self.viewIsContracted = (self.height + transPoint.y < self.selfViewH - 127);
            [self setViewHeightWithAnimation:NO];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.lineView.hidden = NO;
                self.viewCurrent.height = viewCurrent.height + transPoint.y;
                self.height = self.height + transPoint.y;
                self.viewContent.height = self.viewContent.height + transPoint.y;
                self.slideButton.y = self.slideButton.y + transPoint.y;
            }];
            self.viewIsContracted = (transPoint.y < 0);
        }
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self setViewHeightWithAnimation:YES];
    }
}

//先去掉单击手势
//- (void)tapSlideButton:(UITapGestureRecognizer*)tapGesture
//{
//    self.viewIsContracted = !self.viewIsContracted;
//    [self setViewHeightWithAnimation:YES];
//}

/**
 返回按钮点击事件
 */
- (void) onClickBackButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waitForCourierView:didClickbackToOrderListBtn:)]) {
        [self.delegate waitForCourierView:self didClickbackToOrderListBtn:self.courierDetail];
    }
}

#pragma mark - setter Method
- (void)setCourierDetail:(DDCourierDetail *)courierDetail
{
    _courierDetail = courierDetail;
    
//    _courierDetail.courierHeadIcon = [DDInterfaceTool logoWithCompanyId:_courierDetail.courierHeadIcon ?: @""];
    _courierDetail.courierName = _courierDetail.courierName ?: @"无名姓";
    _courierDetail.courierStar = _courierDetail.courierStar ?: @"1";
    
//    if (!_courierDetail) {
//        _courierDetail = [[DDCourierDetail alloc] init];
//        _courierDetail.courierID = @"1111111111111";
//        _courierDetail.courierHeadIcon = @"http://1.png";
//        _courierDetail.courierName = @"张文兵";
//        _courierDetail.courierPhone = @"13813725375";
//        _courierDetail.companyName = @"顺丰速运";
//        _courierDetail.courierIdentityID = @"";
//        _courierDetail.courierGrade = @"3";
//        _courierDetail.finishedOrderNumber = @"165";
//        _courierDetail.courierRank = @"";
//        _courierDetail.courierStar = @"3.0";
//        _courierDetail.orderId = @"111111111111111";
//        _courierDetail.msgId = @"";
//        _courierDetail.longitude = @"116";
//        _courierDetail.latitude = @"40";
//    }
    
    [self.courierLogo sd_setImageWithURL:[NSURL URLWithString:courierDetail.courierHeadIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:DDPersonalHeadIcon]];
    
    courierCompany.text = [NSString stringWithFormat:@"%@",_courierDetail.companyName];
    courierName.text = [NSString stringWithFormat:@"%@",_courierDetail.courierName];
    
    [viewStar setProgress:[_courierDetail.courierStar floatValue]];
    [viewStar display];
    
    scoreLabel.text = [NSString stringWithFormat:@"%.1f",[_courierDetail.courierStar floatValue]];
    
    //给字符串添加图标
    NSTextAttachment *count_Arrow = [[NSTextAttachment alloc] init];
    [count_Arrow setImage:[UIImage imageNamed:@"orderArrow"]];
    [count_Arrow setBounds:CGRectMake(0, 1, 7.0f, 7.0f)];
    NSAttributedString *count_icon = [NSAttributedString attributedStringWithAttachment:count_Arrow];
    
    NSString *count_title = [NSString stringWithFormat:@"%ld%@",(long)[_courierDetail.finishedOrderNumber integerValue],OrderNumber];
    NSMutableAttributedString *att_count_title = [[NSMutableAttributedString alloc] initWithString:count_title];
    [att_count_title addAttribute:NSFontAttributeName value:kTimeFont range:NSMakeRange(0, count_title.length)];
    [att_count_title addAttribute:NSForegroundColorAttributeName value:TIME_COLOR range:NSMakeRange(0, count_title.length)];
    [att_count_title insertAttributedString:count_icon atIndex:count_title.length];
    [sendNumberLabel setAttributedText:att_count_title];
    
    CGSize count_size = [count_title sizeWithAttributes:@{NSFontAttributeName : sendNumberLabel.font}];
    [sendNumberLabel setSize:CGSizeMake(floorf(count_size.width) + 8.0f, sendNumberLabel.height)];
    
}


@end
