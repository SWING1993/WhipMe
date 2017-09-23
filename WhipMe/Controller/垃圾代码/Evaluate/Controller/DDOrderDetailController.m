//
//  DDOrderDetailController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
#define KOrderStar 7777

#import "DDOrderDetailController.h"
#import "DDLineView.h"
#import "DDLabelLists.h"
#import "UIPlaceHolderTextView.h"
#import "DDOrderList.h"
#import "UIImageView+WebCache.h"
#import "DDCheckCostDetailController.h"
#import "DDComplainController.h"
#import "DDCourierDetailController.h"
#import "DDOrderDetail.h"
#import "DDCostDetail.h"
#import "DDMyCouponsController.h"
#import "ShareMessageItem.h"
#import "ShareSDKUtils.h"
#import "NSObject+CustomCategory.h"
#import "YYModel.h"

/** 匿名评价快递员 */
NSString *const DDOrderAnonymous = @"匿名评价快递员";
/** 实名评价快递员 */
NSString *const DDOrderRealName = @"评价快递员";
/** 您的评价会让我们做的更好 */
NSString *const DDOrderSayHelloTo = @"您的评价会让我们做的更好";
/** 完成评价，获得优惠券 */
NSString *const DDOrderCouponMsg = @"完成评价，获得优惠券";
/** 支付成功 */
NSString *const DDOrderPaySuccess = @"支付成功";
/** 查看明细 */
NSString *const DDOrderLook = @"查看明细 ";
/** 匿名评价提示语 */
NSString *const DDAnonymousText = @"输入其他评价...(匿名评价，放心填写)";

@interface DDOrderDetailController () <DDLabelListsDelegate, UITextViewDelegate, DDInterfaceDelegate, UIActionSheetDelegate>
/** 枚举，显示界面为匿名评价订单还是实名评价订单 */
@property (nonatomic,assign) DDOrderDetailControlStyle orderControlStyle;
/** 评分数*/
@property (nonatomic,assign) NSInteger GradeCount;
/** 本视图的整体滚动视图 */
@property (nonatomic, strong) UIScrollView *detailScroll;
/** 白色背景视图 */
@property (nonatomic, strong) UIView *viewContent;
/** 锯齿图片 */
@property (nonatomic, strong) UIImageView *sawtoothImage;
/** 快递员头像 */
@property (nonatomic, strong) UIImageView *iconImage;
/** 快递员名字 */
@property (nonatomic, strong) UILabel *nickNameLabel;
/** 快递公司名字 */
@property (nonatomic, strong) UILabel *companyLabel;
/** 快递员评分等级 */
@property (nonatomic, strong) UIImageView *levelImage;
/** 快递员评分值 */
@property (nonatomic, strong) UILabel *gradeLabel;
/** 订单数量 */
@property (nonatomic, strong) UIButton *orderCountBtn;
/** 电话按钮 */
@property (nonatomic, strong) UIButton *phoneBtn;
/** 订单费用 */
@property (nonatomic, strong) UILabel *priceLabel;
/** 查看明细按钮 */
@property (nonatomic, strong) UIButton *priceDetailBtn;
/** 评分按钮背景 */
@property (nonatomic, strong) UIView *giveGradeView;
/** 存储星星评分按钮 */
@property (nonatomic, strong) NSMutableArray *giveStarArray;
/** 消息提示（您的评价会让我们做的更好） */
@property (nonatomic, strong) UILabel *messageLabel;
/** 匿名评价提示（匿名评价快递员） */
@property (nonatomic, strong) UILabel *anonymousLabel;
 /** 支付成功提示 */
@property (nonatomic, strong) UILabel *successPayLabel;
/** 查看抵扣卷按钮 */
@property (nonatomic, strong) UIButton *deductionBtn;
/** 投诉按钮 */
@property (nonatomic, strong) UIButton *complaintBtn;
/** 评价的背景 */
@property (nonatomic, strong) UIView *evaluationView;
/** 标签显示窗 */
@property (nonatomic, strong) DDLabelLists *tagsView;
/** 标签字符串的数组 */
@property (nonatomic, strong) NSMutableArray *selectedtagsArray;
/** 待评价的标签 */
@property (nonatomic, strong) NSMutableArray *starTagsArray;
@property (nonatomic, strong) UIPlaceHolderTextView *evaluationText;

 /** 提交评论按钮 */
@property (nonatomic, strong) UIButton *submitBtn;

/** 评价标签的网络请求 */
@property (nonatomic, strong) DDInterface *interEvaSign;

/** 提交评价的网络请求 */
@property (nonatomic, strong) DDInterface *interSubmit;

/* 此单评星 **/
@property (nonatomic, assign) NSInteger orderStar;

/**< 订单详情interface */
@property (nonatomic, strong) DDInterface   *detailOrderInterface;

@property (nonatomic, strong) UIView *shareBackView;
/**  底部分享视图  */
@property (nonatomic, strong) UIView *shareView;
/**  微信好友按钮  */
@property (nonatomic, strong) UIButton *wechatFriendsBtn;
/**  朋友圈按钮  */
@property (nonatomic, strong) UIButton *wechatCircleBtn;
/**  取消按钮  */
@property (nonatomic, strong) UIButton *cancelBtn;

@property (strong, nonatomic) UIButton *btnCourierInfo;

@end

@implementation DDOrderDetailController
@synthesize btnCourierInfo;

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"订单详情" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDAddNotification(@selector(keyBoardWillShow:), UIKeyboardWillShowNotification);
    DDAddNotification(@selector(keyBoardWillHide:), UIKeyboardWillHideNotification);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DDRemoveNotificationObserver();
}

/**
 设置值
 */
- (void)setOrderDetail:(DDOrderDetail *)orderDetail
{
    _orderDetail = orderDetail;
    //默认标签的plist数组
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:orderDetail.courierIcon]];
    
    [self.nickNameLabel setText:orderDetail.courierName];
    
    [self.companyLabel setText:orderDetail.companyName];
    
    self.levelImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%ld",(long)[orderDetail.courierStar integerValue]]];
    
    [self.gradeLabel setText:orderDetail.courierStar];
    CGSize gradeSize = [self.gradeLabel.text sizeWithAttributes:@{NSFontAttributeName : self.gradeLabel.font}];
    [self.gradeLabel setSize:CGSizeMake(floorf(gradeSize.width)+12.0f, 12.0f)];
    
    [self.orderCountBtn setOrigin:CGPointMake(self.gradeLabel.right + 7.0f, self.gradeLabel.top)];
    
    //给字符串添加图标
    NSTextAttachment *countArrow = [[NSTextAttachment alloc] init];
    [countArrow setImage:[UIImage imageNamed:@"orderArrow"]];
    [countArrow setBounds:CGRectMake(0, 1, 7.0f, 7.0f)];
    NSAttributedString *countIcon = [NSAttributedString attributedStringWithAttachment:countArrow];
    
    NSString *countTitle = [NSString stringWithFormat:@"%ld单 ",orderDetail.finishedCount];
    NSMutableAttributedString *countTitleAtt = [[NSMutableAttributedString alloc] initWithString:countTitle];
    [countTitleAtt addAttribute:NSFontAttributeName value:kTimeFont range:NSMakeRange(0, countTitle.length)];
    [countTitleAtt addAttribute:NSForegroundColorAttributeName value:TIME_COLOR range:NSMakeRange(0, countTitle.length)];
    [countTitleAtt insertAttributedString:countIcon atIndex:countTitle.length];
    
    [self.orderCountBtn setAttributedTitle:countTitleAtt forState:UIControlStateNormal];
    
    CGSize countSize = [countTitle sizeWithAttributes:@{NSFontAttributeName : self.orderCountBtn.titleLabel.font}];
    [self.orderCountBtn setSize:CGSizeMake(floorf(countSize.width) + 8.0f, self.orderCountBtn.height)];
    
    NSString *orderPrice = [NSString stringWithFormat:@"%.02f",orderDetail.orderCost];
    NSRange range_prefix = [orderPrice rangeOfString:@"¥"];
    NSRange range_order = NSMakeRange(0, orderPrice.length);
    
    NSMutableAttributedString *orderPriceAtt = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [orderPriceAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50.0f] range:range_order];
    [orderPriceAtt addAttribute:NSFontAttributeName value:kContentFont range:range_prefix];
    [self.priceLabel setAttributedText:orderPriceAtt];
    
    
    if (self.orderControlStyle == DDOrderDetailControlStyleAnonymous) {
        /** 匿名评价*/
        [self ddAnonymousOfEvaluation];
    }  else {
        /** 评价完成的状态 */
        [self ddEvaluationOfComplete];
    }
    
}

/**
 *  初始化界面的控件
 */
#pragma mark - 初始化界面的控件
- (void)ddCreateForViewControl
{
    self.view.backgroundColor =  KBackground_COLOR;
    //创建滚动视图，作为界面的所有内容父视图
    UIScrollView *detailScroll = [[UIScrollView alloc] init];
    [detailScroll setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
    [detailScroll setBackgroundColor:KBackground_COLOR];
    [detailScroll setShowsHorizontalScrollIndicator:false];
    [detailScroll setShowsVerticalScrollIndicator:false];
    [self.view addSubview:detailScroll];
    self.detailScroll = detailScroll;
    
    //点击取消键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickWithTap)];
    [detailScroll addGestureRecognizer:tapGr];
    
    //顶部的黑条
    UIImageView *blackImage = [[UIImageView alloc] init];
    [blackImage setSize:CGSizeMake(detailScroll.width - 16.0f, kMargin)];
    [blackImage setCenter:CGPointMake(detailScroll.centerx, 15.0f)];
    [blackImage.layer setCornerRadius:blackImage.height/2.0f];
    [blackImage.layer setMasksToBounds:true];
    [blackImage setBackgroundColor:KPlaceholderColor];
    [detailScroll addSubview:blackImage];
    
    //创建白色背景视图
    UIView *viewContent = [[UIView alloc] init];
    [viewContent setFrame:CGRectMake(15.0f, 15.0f, detailScroll.width - 30.0f, detailScroll.height - 30.0f)];
    [viewContent setBackgroundColor:[UIColor whiteColor]];
    [detailScroll addSubview:viewContent];
    self.viewContent = viewContent;
    
    btnCourierInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCourierInfo setFrame:CGRectMake(0, 0, floorf(viewContent.width/3.0f*2.0f), 100.0f)];
    [btnCourierInfo setBackgroundColor:[UIColor clearColor]];
    [btnCourierInfo setAdjustsImageWhenHighlighted:false];
    [btnCourierInfo addTarget:self action:@selector(onClickWithCourierInfo:) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:btnCourierInfo];
    
    //快递员头像
    UIImageView *iconImage = [[UIImageView alloc] init];
    [iconImage setSize:CGSizeMake(40.0f, 40.0f)];
    [iconImage setCenter:CGPointMake(22.0f + iconImage.centerx, 100/2.0f)];
    [iconImage.layer setCornerRadius:iconImage.height/2.0f];
    [iconImage.layer setMasksToBounds:true];
    [iconImage setBackgroundColor:KBackground_COLOR];
    [iconImage setUserInteractionEnabled:false];
    [viewContent addSubview:iconImage];
    self.iconImage = iconImage;
    
    //快递员名字
    UILabel *nickNameLabel = [[UILabel alloc] init];
    [nickNameLabel setFrame:CGRectMake(iconImage.right + kMargin, iconImage.top, viewContent.width - iconImage.right*2.0f - kMargin, 18.0f)];
    [nickNameLabel setBackgroundColor:[UIColor clearColor]];
    [nickNameLabel setTextAlignment:NSTextAlignmentLeft];
    [nickNameLabel setFont:kTitleFont];
    [nickNameLabel setTextColor:TITLE_COLOR];
    [nickNameLabel setUserInteractionEnabled:false];
    [viewContent addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    
    //快递公司名字
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFrame:CGRectMake(nickNameLabel.left, nickNameLabel.bottom + 4.0f, nickNameLabel.width, nickNameLabel.height)];
    [companyLabel setBackgroundColor:[UIColor clearColor]];
    [companyLabel setTextAlignment:NSTextAlignmentLeft];
    [companyLabel setFont:kTitleFont];
    [companyLabel setTextColor:TIME_COLOR];
    [viewContent addSubview:companyLabel];
    self.companyLabel = companyLabel;
    
    //快递员评分等级
    UIImageView *levelImage = [[UIImageView alloc] init];
    [levelImage setFrame:CGRectMake(companyLabel.left, companyLabel.bottom + 2.0f, 64.0f, 11.0f)];
    [levelImage setBackgroundColor:[UIColor clearColor]];
    [viewContent addSubview:levelImage];
    self.levelImage = levelImage;

    //快递员评分值
    UILabel *gradeLabel = [[UILabel alloc] init];
    [gradeLabel setFrame:CGRectMake(levelImage.right + 5.0f, levelImage.top, 40.0f, 12.0f)];
    [gradeLabel setBackgroundColor:DDGreen_Color];
    [gradeLabel.layer setCornerRadius:gradeLabel.height/2.0f];
    [gradeLabel.layer setMasksToBounds:true];
    [gradeLabel setTextAlignment:NSTextAlignmentCenter];
    [gradeLabel setTextColor:[UIColor whiteColor]];
    [gradeLabel setFont:KCountFont];
    [viewContent addSubview:gradeLabel];
    self.gradeLabel = gradeLabel;
    
    //订单数量
    UIButton *orderCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderCountBtn setFrame:CGRectMake(gradeLabel.right + 5.0f, gradeLabel.top, gradeLabel.width, gradeLabel.height)];
    [orderCountBtn setBackgroundColor:[UIColor clearColor]];
    [orderCountBtn.titleLabel setFont:kTimeFont];
    [orderCountBtn setTitleColor:TIME_COLOR forState:UIControlStateNormal];
    [orderCountBtn setAdjustsImageWhenHighlighted:false];
    [orderCountBtn addTarget:self action:@selector(onClickWithOrderCount) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:orderCountBtn];
    self.orderCountBtn = orderCountBtn;
    
    //电话按钮
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setSize:CGSizeMake(40.0f, 40.0f)];
    [phoneBtn setCenter:CGPointMake(viewContent.width - 22.0f - phoneBtn.centerx, iconImage.centerY)];
    [phoneBtn.layer setCornerRadius:phoneBtn.height/2.0f];
    [phoneBtn.layer setMasksToBounds:true];
    [phoneBtn setAdjustsImageWhenHighlighted:false];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:DDOrderPhone] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(onClickWithPhone) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:phoneBtn];
    self.phoneBtn = phoneBtn;
    
    //在白色背景上放置两个半圆和虚线
    UIImageView *leftCircle = [[UIImageView alloc] init];
    [leftCircle setSize:CGSizeMake(19.0f, 19.0f)];
    [leftCircle setCenter:CGPointMake(viewContent.left, 100 + viewContent.top + leftCircle.centery)];
    [leftCircle setBackgroundColor:detailScroll.backgroundColor];
    [leftCircle.layer setCornerRadius:leftCircle.height/2.0f];
    [leftCircle.layer setMasksToBounds:true];
    [detailScroll addSubview:leftCircle];
    
    UIImageView *rightCircle = [[UIImageView alloc] init];
    [rightCircle setSize:CGSizeMake(19.0f, 19.0f)];
    [rightCircle setCenter:CGPointMake(viewContent.right, leftCircle.centerY)];
    [rightCircle setBackgroundColor:detailScroll.backgroundColor];
    [rightCircle.layer setCornerRadius:rightCircle.height/2.0f];
    [rightCircle.layer setMasksToBounds:true];
    [detailScroll addSubview:rightCircle];
    
    DDLineView *dottedLineView = [[DDLineView alloc] init];
    [dottedLineView setSize:CGSizeMake(viewContent.width, 1.0f)];
    [dottedLineView setCenter:CGPointMake(detailScroll.centerx, rightCircle.centerY)];
    [detailScroll addSubview:dottedLineView];
    //设置虚线
    [dottedLineView drawDashLineLength:4.0f lineSpacing:4.0f lineColor:detailScroll.backgroundColor];
    
    //订单费用
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFrame:CGRectMake(iconImage.left, 156.0f, viewContent.width - iconImage.left*2.0f, 38.0f)];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    [priceLabel setFont:[UIFont systemFontOfSize:50.0f]];
    [priceLabel setTextColor:DDGreen_Color];
    [viewContent addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    //支付成功提示
    UILabel *successPayLabel = [[UILabel alloc] init];
    [successPayLabel setSize:CGSizeMake(priceLabel.width, 14.0f)];
    [successPayLabel setCenter:CGPointMake(priceLabel.centerX, (priceLabel.top+100.0f)/2.0f)];
    [successPayLabel setBackgroundColor:[UIColor clearColor]];
    [successPayLabel setTextAlignment:NSTextAlignmentCenter];
    [successPayLabel setFont:kTitleFont];
    [successPayLabel setTextColor:KPlaceholderColor];
    [successPayLabel setText:DDOrderPaySuccess];
    [viewContent addSubview:successPayLabel];
    self.successPayLabel = successPayLabel;
    
    //查看明细按钮
    UIButton *priceDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceDetailBtn setBackgroundColor:[UIColor clearColor]];
    [priceDetailBtn setAdjustsImageWhenHighlighted:false];
    [priceDetailBtn addTarget:self action:@selector(onClickWithLook) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:priceDetailBtn];
    self.priceDetailBtn = priceDetailBtn;
    
    //给字符串添加图标
    NSTextAttachment *loock_Arrow = [[NSTextAttachment alloc] init];
    [loock_Arrow setImage:[UIImage imageNamed:@"orderArrow"]];
    [loock_Arrow setBounds:CGRectMake(0, 2, 7.0f, 7.0f)];
    NSAttributedString *look_icon = [NSAttributedString attributedStringWithAttachment:loock_Arrow];
    
    NSRange range_look = NSMakeRange(0, DDOrderLook.length);
    NSMutableAttributedString *att_look_title = [[NSMutableAttributedString alloc] initWithString:DDOrderLook];
    [att_look_title addAttribute:NSFontAttributeName value:kContentFont range:range_look];
    [att_look_title addAttribute:NSForegroundColorAttributeName value:CONTENT_COLOR range:range_look];
    [att_look_title insertAttributedString:look_icon atIndex:DDOrderLook.length];
    [priceDetailBtn setAttributedTitle:att_look_title forState:UIControlStateNormal];
    
    //orderArrow
    CGSize look_size = [DDOrderLook sizeWithAttributes:@{NSFontAttributeName : kContentFont}];
    [priceDetailBtn setSize:CGSizeMake(floorf(look_size.width) + 8.0f, floorf(look_size.height) + 1.0f)];
    [priceDetailBtn setCenter:CGPointMake(viewContent.centerx, priceLabel.bottom + 20.0f + priceDetailBtn.centery)];
    
    //匿名评价提示（匿名评价快递员）
    UILabel *anonymousLabel = [[UILabel alloc] init];
    [anonymousLabel setFrame:CGRectMake(priceLabel.left, priceDetailBtn.bottom + 40.0f, priceLabel.width, 14.0f)];
    [anonymousLabel setBackgroundColor:[UIColor clearColor]];
    [anonymousLabel setTextAlignment:NSTextAlignmentCenter];
    [anonymousLabel setFont:kTitleFont];
    [anonymousLabel setTextColor:KPlaceholderColor];
    [anonymousLabel setText:DDOrderAnonymous];
    [viewContent addSubview:anonymousLabel];
    self.anonymousLabel = anonymousLabel;
    
    //评分按钮背景
    UIView *giveGradeView = [[UIView alloc] init];
    [giveGradeView setFrame:CGRectMake(iconImage.left, anonymousLabel.bottom + 18.0f, viewContent.width - iconImage.left*2.0f, 34.0f)];
    [giveGradeView setBackgroundColor:[UIColor clearColor]];
    [viewContent addSubview:giveGradeView];
    self.giveGradeView = giveGradeView;
    
    self.giveStarArray = [[NSMutableArray alloc] initWithCapacity:0];
    //循环创建五个星星打分按钮
    for (int i=0; i<5; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setSize:CGSizeMake(34.0f, 34.0f)];
        [itemButton setOrigin:CGPointMake(i*50.0f, 0)];
        [itemButton setBackgroundImage:[UIImage imageNamed:DDStarOff] forState:UIControlStateNormal];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [itemButton setTag:KOrderStar + i];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [giveGradeView addSubview:itemButton];
        [self.giveStarArray addObject:itemButton];
    }
    [giveGradeView setSize:CGSizeMake(self.giveStarArray.count*50.0f - 16.0f, giveGradeView.height)];
    [giveGradeView setCenter:CGPointMake(viewContent.centerx, giveGradeView.centerY)];
    
    //消息提示（您的评价会让我们做的更好)
    UILabel *messageLabel = [[UILabel alloc] init];
    [messageLabel setFrame:CGRectMake(priceLabel.left, giveGradeView.bottom + 21.0f, priceLabel.width, 14.0f)];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setNumberOfLines:0];
    [messageLabel setFont:kTimeFont];
    [messageLabel setTextColor:DDGreen_Color];
    [viewContent addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
    //查看抵扣卷按钮
    UIButton *deductionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deductionBtn setSize:CGSizeMake(56.0f, 56.0f)];
    [deductionBtn setCenter:CGPointMake(viewContent.centerx - 34.0f - deductionBtn.centerx, messageLabel.bottom + 44.0f + deductionBtn.centery)];
    [deductionBtn.layer setCornerRadius:deductionBtn.height/2.0f];
    [deductionBtn.layer setMasksToBounds:true];
    [deductionBtn setBackgroundImage:[UIImage imageNamed:DDDeduction] forState:UIControlStateNormal];
    [deductionBtn setAdjustsImageWhenHighlighted:false];
    [deductionBtn addTarget:self action:@selector(onClickWithDeduction) forControlEvents:UIControlEventTouchUpInside];
    [deductionBtn setHidden:true];
    [viewContent addSubview:deductionBtn];
    self.deductionBtn = deductionBtn;
    
    //投诉按钮
    UIButton *complaintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [complaintBtn setSize:deductionBtn.size];
    [complaintBtn setCenter:CGPointMake(viewContent.centerx, messageLabel.bottom + 25.0f + deductionBtn.centery)];
    [complaintBtn.layer setCornerRadius:complaintBtn.height/2.0f];
    [complaintBtn.layer setMasksToBounds:true];
    [complaintBtn setBackgroundImage:[UIImage imageNamed:DDComplaint] forState:UIControlStateNormal];
    [complaintBtn setAdjustsImageWhenHighlighted:false];
    [complaintBtn addTarget:self action:@selector(onClickWithComplaint) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:complaintBtn];
    self.complaintBtn = complaintBtn;
    [viewContent setSize:CGSizeMake(viewContent.width, MAX(complaintBtn.bottom + 20.0f, detailScroll.height - 30.0f))];
    
    UIImageView *sawtoothImage = [[UIImageView alloc] init];
    [sawtoothImage setFrame:CGRectMake(viewContent.left, viewContent.bottom, viewContent.width, 5.0f)];
    [sawtoothImage setBackgroundColor:[UIColor clearColor]];
    [sawtoothImage setImage:[UIImage imageNamed:DDSawtooth]];
    [detailScroll addSubview:sawtoothImage];
    self.sawtoothImage = sawtoothImage;
    
    [detailScroll setContentSize:CGSizeMake(detailScroll.width, MAX(detailScroll.height, sawtoothImage.bottom + 15.0f))];
    
    /** 创建评论窗口 */
    [self ddCreateForEvaluationing];
    
    
    
    [self.view addSubview:self.shareBackView];
    [self.shareBackView addSubview:self.shareView];
    [self.shareView addSubview:self.wechatCircleBtn];
    [self.shareView addSubview:self.wechatFriendsBtn];
    [self.shareView addSubview:self.cancelBtn];
}

/**
 匿名评价的状态
 */
- (void)ddAnonymousOfEvaluation
{
    [self.successPayLabel setHidden:false];
    [self.anonymousLabel setHidden:false];
    [self.deductionBtn setHidden:true];
    
    [self.giveGradeView setSize:CGSizeMake(self.giveStarArray.count*50.0f - 16.0f, self.giveGradeView.height)];
    [self.giveGradeView setCenter:CGPointMake(self.viewContent.centerx, self.giveGradeView.centerY)];
    
    [self.messageLabel setFrame:CGRectMake(self.priceLabel.left, self.giveGradeView.bottom + 21.0f, self.priceLabel.width, 14.0f)];
    [self.complaintBtn setCenter:CGPointMake(self.viewContent.centerx, self.messageLabel.bottom + 25.0f + self.deductionBtn.centery)];
    [self.viewContent setSize:CGSizeMake(self.viewContent.width, self.complaintBtn.bottom + 30.0f)];
    [self.sawtoothImage setFrame:CGRectMake(self.viewContent.left, self.viewContent.bottom, self.viewContent.width, 5.0f)];
    
    [self.messageLabel setText:DDOrderCouponMsg];
}

/**
 *  实名评价的状态
 */
- (void)ddRealNameOfEvaluation
{
    [self.successPayLabel setHidden:false];
    [self.anonymousLabel setHidden:true];
    [self.deductionBtn setHidden:false];
    
    [self.giveGradeView setFrame:CGRectMake(self.iconImage.left, self.priceDetailBtn.bottom + 30.0f, self.self.viewContent.width - self.iconImage.left*2.0f, 34.0f)];
    
    [self.giveGradeView setSize:CGSizeMake(self.giveStarArray.count*50.0f - 16.0f, self.giveGradeView.height)];
    [self.giveGradeView setCenter:CGPointMake(self.self.viewContent.centerx, self.giveGradeView.centerY)];
    
    [self.messageLabel setFrame:CGRectMake(self.priceLabel.left, self.giveGradeView.bottom + 21.0f, self.priceLabel.width, 14.0f)];
    [self.deductionBtn setCenter:CGPointMake(self.self.viewContent.centerx - 34.0f - self.deductionBtn.centerx, self.messageLabel.bottom + 44.0f + self.deductionBtn.centery)];
    [self.complaintBtn setCenter:CGPointMake(self.self.viewContent.centerx + 34.0f + self.complaintBtn.centerx, self.deductionBtn.centerY)];
    
    [self.sawtoothImage setOrigin:CGPointMake(self.sawtoothImage.left, self.self.viewContent.bottom)];
    [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, MAX(self.detailScroll.height, self.sawtoothImage.bottom + 15.0f))];
    
    [self.messageLabel setText:DDOrderSayHelloTo];
}

/**
 *  评价完成的状态
 */
- (void)ddEvaluationOfComplete
{
    [self.messageLabel setHidden:true];
    [self.anonymousLabel setHidden:true];
    [self.deductionBtn setHidden:false];
    
    self.giveGradeView.centerY = self.giveGradeView.centerY;
    self.giveGradeView.y = self.priceDetailBtn.bottom + 30.0f;

    for (NSInteger i=0; i<self.giveStarArray.count; i++)
    {
        UIButton *itemButotn = [self.giveStarArray objectAtIndex:i];
        if (i < self.orderDetail.evaluateGrade)
        {
            [itemButotn setBackgroundImage:[UIImage imageNamed:DDStarOn] forState:UIControlStateNormal];
        } else {
            [itemButotn setBackgroundImage:[UIImage imageNamed:DDStarOff] forState:UIControlStateNormal];
        }
    }
    
    //创建标签
    //DDLabelLists *detailTags = [[DDLabelLists alloc] initWithFrame:CGRectMake(self.priceLabel.left, self.giveGradeView.bottom + 21.0f, self.priceLabel.width, 20.0f)];
    DDLabelLists *detailTags = [[DDLabelLists alloc] initWithFrame:CGRectMake(self.priceLabel.left, self.giveGradeView.bottom + 21.0f, self.priceLabel.width - 30.0f, 1000.0f)];
    [detailTags setBackgroundColor:[UIColor clearColor]];
    [detailTags setLabelBackgroundColor:[UIColor clearColor]];
    [detailTags setLabelBorderColor:true];
    [detailTags setItemLabels:(NSMutableArray *)self.orderDetail.evaluateArray];
    [detailTags setHidden:false];
    [self.viewContent addSubview:detailTags];

    [detailTags setSize:CGSizeMake(detailTags.width, [detailTags fittedSize].height)];
    [detailTags setCenter:CGPointMake(self.viewContent.centerX, detailTags.centerY)];
    
    [self.deductionBtn setCenter:CGPointMake(self.viewContent.centerx - 34.0f - self.deductionBtn.centerx, detailTags.bottom + 21.0f +self.deductionBtn.centery)];
    [self.complaintBtn setCenter:CGPointMake(self.viewContent.centerx + 34.0f + self.complaintBtn.centerx, self.deductionBtn.centerY)];
    
    [self.sawtoothImage setOrigin:CGPointMake(self.sawtoothImage.left, self.viewContent.bottom)];
    [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, MAX(self.detailScroll.height, self.sawtoothImage.bottom + 15.0f))];
    
    [self.viewContent setSize:CGSizeMake(self.viewContent.width, self.complaintBtn.bottom + 30.0f)];
    [self.sawtoothImage setFrame:CGRectMake(self.viewContent.left, self.viewContent.bottom, self.viewContent.width, 5.0f)];
}

/**
 评价视图显示窗
 */
- (void)ddCreateForEvaluationing
{
    //评价的背景
    UIView *evaluationView = [[UIView alloc] init];
    [evaluationView setFrame:CGRectMake(0, self.giveGradeView.bottom + 18.0f, self.viewContent.width, self.viewContent.width)];
    [evaluationView setBackgroundColor:[UIColor clearColor]];
    [evaluationView setHidden:true];
    [self.viewContent addSubview:evaluationView];
    self.evaluationView = evaluationView;
    
    //创建标签
    DDLabelLists *tagsView = [[DDLabelLists alloc] initWithFrame:CGRectMake(15.0f, 0, evaluationView.width - 30.0f, 80.0f)];
    [tagsView setBackgroundColor:[UIColor clearColor]];
    [tagsView setLabelBackgroundColor:[UIColor clearColor]];
    [tagsView setLabelBorderColor:false];
    [tagsView setDelegate:self];
    [evaluationView addSubview:tagsView];
    self.tagsView = tagsView;
    
    /** 评价输入框 */
    UIPlaceHolderTextView *evaluationText = [[UIPlaceHolderTextView alloc] init];
    [evaluationText setFrame:CGRectMake(15.0f, tagsView.bottom + 20.0f, evaluationView.width - 30.0f, 75.0f)];
    [evaluationText setBackgroundColor:[UIColor clearColor]];
    [evaluationText.layer setCornerRadius:4.0f];
    [evaluationText.layer setMasksToBounds:true];
    [evaluationText.layer setBorderWidth:1.0f];
    [evaluationText.layer setBorderColor:BORDER_COLOR.CGColor];
    [evaluationText setTextAlignment:NSTextAlignmentLeft];
    [evaluationText setTextColor:DDGreen_Color];
    [evaluationText setFont:kTimeFont];
    [evaluationText setDelegate:self];
    [evaluationText setPlaceholder:DDAnonymousText];
    [evaluationText setPlaceholderColor:KPlaceholderColor];
    [evaluationView addSubview:evaluationText];
    self.evaluationText = evaluationText;
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake( evaluationText.left, evaluationText.bottom + 15.0f, evaluationText.width, 40.0f)];
    [submitBtn setBackgroundImage:[UIImage imageWithDrawColor:DDGreen_Color withSize:submitBtn.bounds] forState:UIControlStateNormal];
    [submitBtn.layer setCornerRadius:submitBtn.height/2.0f];
    [submitBtn.layer setMasksToBounds:true];
    [submitBtn setAdjustsImageWhenHighlighted:false];
    [submitBtn.titleLabel setFont:kButtonFont];
    [submitBtn setTitle:@"提交评论" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onClickWithSubmit) forControlEvents:UIControlEventTouchUpInside];
    [evaluationView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    [evaluationView setSize:CGSizeMake(evaluationView.width, submitBtn.bottom + 15.0f)];
    
    [self.sawtoothImage setOrigin:CGPointMake(self.sawtoothImage.left, self.viewContent.bottom)];
    
    [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, MAX(self.detailScroll.height, self.sawtoothImage.bottom + 15.0f))];
}

#pragma mark - Event Method
/**
 *  五个星星打分按钮
 */
- (void)onClickWithItem:(UIButton *)sender
{
    if (self.orderControlStyle == DDOrderDetailControlStyleEvaluationOfComplete)
    {
        return;
    } 

   [self.tagsView setSize:CGSizeMake(self.tagsView.width, 1000)];
   [self.tagsView setItemLabels:self.starTagsArray[sender.tag%KOrderStar]];
   [self.tagsView setSize:CGSizeMake(self.tagsView.width, [self.tagsView fittedSize].height)];
    
   //[self.evaluationText setFrame:CGRectMake(15.0f, self.tagsView.bottom + 20.0f, self.evaluationView.width - 30.0f, 75.0f)];
    self.evaluationText.y = self.tagsView.bottom + 20.0f;
    self.submitBtn.y = self.evaluationText.bottom + 15.0f;
    
    for (NSInteger i=0; i<self.giveStarArray.count; i++)
    {
        UIButton *itemButotn = [self.giveStarArray objectAtIndex:i];
        if (itemButotn.tag <= sender.tag)
        {
            self.GradeCount = i+1;
            [itemButotn setBackgroundImage:[UIImage imageNamed:DDStarOn] forState:UIControlStateNormal];
        } else {
            [itemButotn setBackgroundImage:[UIImage imageNamed:DDStarOff] forState:UIControlStateNormal];
        }
    }
   
    /** 打分的时候，弹出评论视图 */
    [self.anonymousLabel setHidden:false];
    [self.anonymousLabel setText:self.orderControlStyle==DDOrderDetailControlStyleAnonymous?DDOrderAnonymous:DDOrderRealName];
    [self.evaluationView setHidden:false];
    //修改坐标
    [self.priceLabel setHidden:true];
    [self.priceDetailBtn setHidden:true];
    [self.successPayLabel setHidden:true];
    [self.deductionBtn setHidden:true];
    [self.messageLabel setHidden:true];
    [self.complaintBtn setHidden:true];
    [UIView animateWithDuration:0.35f animations:^{
        [self.anonymousLabel setOrigin:CGPointMake( self.anonymousLabel.left, 124.0f)];
        [self.giveGradeView setOrigin:CGPointMake(self.giveGradeView.left, self.anonymousLabel.bottom+18.0f)];
        [self.evaluationView setOrigin:CGPointMake(self.evaluationView.left, self.giveGradeView.bottom + 18.0f)];
    } completion:^(BOOL finsih) {
        [self.sawtoothImage setOrigin:CGPointMake(self.sawtoothImage.left, self.viewContent.bottom)];
        [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, MAX(self.detailScroll.height, self.sawtoothImage.bottom + 15.0f))];
    }];
    
}


/** 订单数量 */
- (void)onClickWithOrderCount
{

}

/**  拨打电话 */
- (void)onClickWithPhone
{
    [self callCustomerService:self.orderDetail.courierPhone];
}

/**
 *  拨打电话
 */
- (void)callCustomerService:(NSString *)phone
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self.view addSubview:callWebview];
}

/** 查看明细按钮 */
- (void)onClickWithLook
{
    DDCheckCostDetailController *controler = [[DDCheckCostDetailController alloc] initWithOrderId:self.orderDetail.orderId];
    [self.navigationController pushViewController:controler animated:true];
}

/** 查看抵扣卷按钮 */
- (void)onClickWithDeduction
{
    self.shareBackView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBackView.backgroundColor = DDRGBAColor(0, 0, 0, 0.3);
        self.shareBackView.y -= 154;
    }];
    
}

/** 进入快递员详情 */
- (void)onClickWithCourierInfo:(id)sender
{
    DDCourierDetailController *controller = [[DDCourierDetailController alloc] initWithCourierId:self.orderDetail.courierId];
    [self.navigationController pushViewController:controller  animated:YES];
}

- (void)wechatFriendsBtnClick
{
    [self pushToPlatformFromPlatformType:SSDKPlatformSubTypeWechatSession];
}

- (void)wechatCircleBtnClick
{
    [self pushToPlatformFromPlatformType:SSDKPlatformSubTypeWechatTimeline];
}

- (void)pushToPlatformFromPlatformType:(SSDKPlatformType)type
{
    ShareMessageItem *item = [[ShareMessageItem alloc] init];
    item.title = @"寄快递，先领券，艾特小哥发红包啦!";
    item.message = @"最高立减15元，快来艾特小哥试手气~";
    item.image = OrderShareImageURL;
    
    item.url = [NSString stringWithFormat:@"%@/atxg/share_award_coupon/clickSharePage?shareAwardCoupon.orderId=%@&signature=%@",kURL_Pre_Test, self.orderDetail.orderId,[self getSignatureByOrderIdKey]];
    [[ShareSDKUtils shareInstance] shareMessageWithPlatformType:type shareMessageItem:item];
}


- (void)shareViewCancelButtonClick
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBackView.backgroundColor = DDRGBAColor(0, 0, 0, 0);
        self.shareBackView.y += 154;
    } completion:^(BOOL finished) {
        self.shareBackView.hidden = YES;
    }];
}
- (NSString *)getSignatureByOrderIdKey
{
    NSString *key = [NSString stringWithFormat:@"%@1a@$3321ooobbA#bbbbbbbb2@@@@@@@%%%%%%", self.orderDetail.orderId];
    return [key MD5];
}

/** 投诉按钮 */
- (void)onClickWithComplaint
{
    DDComplainController *complainControler = [[DDComplainController alloc] init];
    complainControler.orderId = self.orderDetail.orderId;
    [self.navigationController pushViewController:complainControler animated:YES];
}

/** 提交评论 */
- (void)onClickWithSubmit
{
    [self.selectedtagsArray addObject:self.evaluationText.text.length > 0 ? self.evaluationText.text : @"系统默认好评"];
    [self submitEvaRequest];
}

#pragma mark - DDLabelListsDelegate
/**
 labelList 标签视图
 buttonIndex 选择的单个标签在数组的下标
 isSelect 是否选择该标签
 */
- (void)ddLabelLists:(DDLabelLists *)labelList index:(NSInteger)buttonIndex withSelect:(BOOL)isSelect
{
    if (isSelect) {
        [self.selectedtagsArray addObject:labelList.textArray[buttonIndex]];
    } else {
        [self.selectedtagsArray removeObject:labelList.textArray[buttonIndex]];
    }
    
}

/** 取消键盘编辑 */
- (void)onClickWithTap
{
    [self.view endEditing:false];
}

#pragma mark - Private Method
/** 键盘显示所触发的事件 */
- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    
    UIWindow *windowTemp = [UIApplication sharedApplication].keyWindow;
    CGRect targetTemp = [self.evaluationText convertRect:self.evaluationText.bounds toView:windowTemp];

    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.detailScroll setContentOffset:CGPointMake(self.detailScroll.contentOffset.x, MAX(CGRectGetMaxY(targetTemp) + kMargin - (self.detailScroll.height - ty), 0))];
    } completion:^(BOOL finish) {
        if (self.detailScroll.contentSize.height - CGRectGetMinY(targetTemp) + 7.0f > self.detailScroll.height - CGRectGetMinY(targetTemp) + 7.0f) {
            [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, MAX(self.detailScroll.height, self.sawtoothImage.bottom + ty + 15.0f))];
        
        }
    }];
}

/** 键盘隐藏所触发的事件 */
- (void)keyBoardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.detailScroll setContentOffset:CGPointMake(self.detailScroll.contentOffset.x, 0)];
    } completion:^(BOOL finish) {
        [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, MAX(self.detailScroll.height, self.sawtoothImage.bottom + 15.0f))];
    }];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - Setter && Getter
- (UIView *)shareBackView
{
    if (_shareBackView == nil) {
        _shareBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 154)];
        _shareBackView.backgroundColor = DDRGBAColor(0, 0, 0, 0);
        _shareBackView.hidden = YES;
        _shareBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewCancelButtonClick)];
        [_shareBackView addGestureRecognizer:tapGesture];
    }
    return _shareBackView;
}


- (UIView *)shareView
{
    if (_shareView == nil) {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height, self.shareBackView.width, 154)];
        _shareView.backgroundColor = DDRGBAColor(255, 255, 255, 1);
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.shareView.height - 43, self.view.width, 0.5f)];
        lineView.backgroundColor = DDRGBColor(233, 233, 233);
        [_shareView addSubview:lineView];
    }
    return _shareView;
}

-(UIButton *)wechatFriendsBtn
{
    if (_wechatFriendsBtn == nil) {
        _wechatFriendsBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width / 2 - 100, 0, 100, 112)];
        [_wechatFriendsBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [_wechatFriendsBtn addTarget:self action:@selector(wechatFriendsBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_wechatFriendsBtn setImageEdgeInsets:UIEdgeInsetsMake(-12, 0, 12, 0)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_wechatFriendsBtn.x, 77, _wechatFriendsBtn.width, 15)];
        label.text = @"微信好友";
        label.textColor = DDRGBColor(102, 102, 102);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self.shareView addSubview:label];
    }
    return _wechatFriendsBtn;
}


- (UIButton *)wechatCircleBtn
{
    if (_wechatCircleBtn == nil) {
        _wechatCircleBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width / 2, 0, 100, 112)];
        [_wechatCircleBtn setImage:[UIImage imageNamed:@"friend-zone"] forState:UIControlStateNormal];
        [_wechatCircleBtn addTarget:self action:@selector(wechatCircleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_wechatCircleBtn setImageEdgeInsets:UIEdgeInsetsMake(-12, 0, 12, 0)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_wechatCircleBtn.x, 77, _wechatCircleBtn.width, 15)];
        label.text = @"朋友圈";
        label.textColor = DDRGBColor(102, 102, 102);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self.shareView addSubview:label];
    }
    return _wechatCircleBtn;
}

-(UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.shareView.height - 42, self.view.width, 42)];
        [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:DDRGBColor(51, 51, 51) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelBtn addTarget:self action:@selector(shareViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)testData
{
    if (self.starTagsArray.count == 0) {
        //TODO:测试数据
        NSArray * one = [[NSArray alloc] initWithObjects:@"态度好",@"速度特别快",@"等了十年",@"你在干什么",@"好佩服",@"包装袋破了",@"你相信么",nil];
        NSArray * two = [[NSArray alloc] initWithObjects:@"态度好",@"速度特别快",@"好佩服",@"包装袋破了",@"你相信么",nil];
        NSArray * three = [[NSArray alloc] initWithObjects:@"速度特别快",@"等了十年",@"你在干什么",@"好佩服",@"包装袋破了",@"你相信么",nil];
        NSArray * four = [[NSArray alloc] initWithObjects:@"态度好",@"等了十年",@"你在干什么",@"好佩服",@"包装袋破了",@"你相信么",nil];
        NSArray * five = [[NSArray alloc] initWithObjects:@"态度好",@"速度特别快",@"等了十年",@"你在干什么",@"好佩服",@"包装袋破了",nil];
        NSMutableArray * array = [[NSMutableArray alloc] initWithObjects:one,two,three,four,five, nil];
        self.starTagsArray = array;
    }
}

- (NSMutableArray *)selectedtagsArray
{
    if (_selectedtagsArray == nil) {
        _selectedtagsArray = [NSMutableArray array];
    }
    return _selectedtagsArray;
}



#pragma mark - 初始化生成临时数据
- (instancetype)initWithOrderStyle:(DDOrderDetailControlStyle)controlStyle
{
    self = [super init];
    if (self) {
        self.orderControlStyle = controlStyle;
        
        //初始化界面的控件
        [self ddCreateForViewControl];
        
        if (controlStyle == DDOrderDetailControlStyleAnonymous) {
            /** 评价标签 数据请求 */
            [self requestEvaluateSign];
        }
    }
    return self;
}

/**
 *  提交评价
 */
- (void) submitEvaRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //订单 ID
    [param setObject:self.orderDetail.orderId   forKey:@"orderId"];
    [param setObject:@(self.GradeCount)         forKey:@"star"];
    [param setObject:self.selectedtagsArray     forKey:@"content"];
    
    if (!self.interSubmit) {
        self.interSubmit = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interSubmit interfaceWithType:INTERFACE_TYPE_SUBMIT_EVALUATE  param:param];
}

/**
 *  评价标签
 */
- (void) requestEvaluateSign
{
    if (!self.interEvaSign) {
        self.interEvaSign = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interEvaSign interfaceWithType:INTERFACE_TYPE_EVALUATE_TAG  param:nil];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if(interface == self.interEvaSign) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }else {
            NSMutableArray * evArray = [NSMutableArray arrayWithArray:result[@"mList"]];
            self.starTagsArray = evArray;
        }
        
        [self testData];
    } else if (interface == self.interSubmit) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }else {
            //提交评价成功再请求订单详情成功之后进入评价完成的订单详情页面
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:self.orderDetail.orderId  forKey:@"orderId"];
            self.detailOrderInterface = [[DDInterface alloc] initWithDelegate:self];
            [self.detailOrderInterface interfaceWithType:INTERFACE_TYPE_ORDER_DETAIL  param:param];
        }
    } else if (interface == self.detailOrderInterface) {
        if (error) [MBProgressHUD showError:error.domain];
        else {
            DDOrderDetail *orderDetail = [DDOrderDetail yy_modelWithDictionary:result];
            DDOrderDetailController *orderDetalController = [[DDOrderDetailController alloc] initWithOrderStyle:DDOrderDetailControlStyleEvaluationOfComplete];
            orderDetalController.orderDetail = orderDetail;
            orderDetalController.orderDetail.orderId = self.orderDetail.orderId;
            [self.navigationController pushViewController:orderDetalController animated:YES];
            NSArray<UIViewController *> *nowControllers = [self.navigationController viewControllers];
            NSMutableArray<UIViewController *> *newViewControllers = [NSMutableArray arrayWithArray:nowControllers];
            [newViewControllers removeObjectAtIndex:(nowControllers.count - 2)];
            [self.navigationController setViewControllers:newViewControllers animated:YES];
        }
    }
}



@end
