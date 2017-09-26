//
//  DDUploadIdCardView.m
//  DDExpressClient
//
//  Created by yangg on 16/3/24.
//  Copyright © 2016年 NS. All rights reserved.
//
/**
 身份认真上传图片身份证照片，和手持身份证消息弹窗
 */

/** 内容视图，白色的边距 */
#define KCurrentSpacing 33.0f
/** 上传身份证的默认提示图片的大小 */
#define KImageIdCardSize 154.0f

#import "DDUploadIdCardView.h"
#import "Constant.h"

@interface DDUploadIdCardView ()

/** 弹窗按钮事件对应的协议 */
@property (nonatomic, assign) id<DDUploadIdCardViewDelegate> delegate;

/** 灰黑背景 */
@property (nonatomic, strong) UIButton *viewBlack;
/** 内容视图，白色 */
@property (nonatomic, strong) UIView   *viewCurrent;
/** 左边操作按钮 */
@property (nonatomic, strong) UIButton *btnNext;
/** 右边操作按钮 */
@property (nonatomic, strong) UIButton *btnOther;
/** 图片的说明标签 */
@property (nonatomic, strong) UILabel *lblTitle;
/** 上传身份证的默认提示图片 */
@property (nonatomic, strong) UIImageView *imageIdCard;

/** 图片的名称 */
@property (nonatomic, strong) NSString *imagePath;
/** 图片的说明，标题 */
@property (nonatomic, strong) NSString *titleImage;
/** 左边按钮的标题 */
@property (nonatomic, strong) NSString *titleNext;
/** 右边按钮的标题 */
@property (nonatomic, strong) NSString *titleOther;
/** 根控制器 */
@property (nonatomic, strong) UIWindow *window;
/** 判断视图的显示 */
@property (nonatomic, assign) BOOL      isShowing;

@end

@implementation DDUploadIdCardView
@synthesize viewBlack;
@synthesize viewCurrent;

@synthesize btnNext;
@synthesize btnOther;
@synthesize lblTitle;
@synthesize imageIdCard;

#pragma mark - 自定义视图
/**
 身份认真上传图片身份证照片，和手持身份证消息弹窗
 imagePath : 图片的名称
 title : 图片的说明，标题
 delegate : 弹窗按钮事件对应的协议
 nextTitle : 左边按钮的标题
 otherTitle : 右边按钮的标题
 */
- (instancetype)initWithImagePath:(NSString *)imagePath
                        withTitle:(NSString *)title
                         delegate:(id<DDUploadIdCardViewDelegate>)objDelegate
                         withNext:(NSString *)nextTitle
                        withOther:(NSString *)otherTitel
{
    self = [super init];
    if (self) {
        self.imagePath = imagePath;
        self.titleImage = title;
        self.delegate = objDelegate;
        self.titleNext = nextTitle;
        self.titleOther = otherTitel;
        
        self.window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.window.bounds), CGRectGetHeight(self.window.bounds));
        
        //初始化cell上的自定义控件
        [self setup];
    }
    return self;
}

/**
 初始化自定义控件
 */
- (void)setup
{
    /** 灰黑背景 */
    viewBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewBlack setFrame:CGRectMake(0, 0, self.width, self.height)];
    [viewBlack setBackgroundColor:[UIColor blackColor]];
    [viewBlack setAlpha:0.5f];
    [viewBlack addTarget:self action:@selector(onClickWithClear:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewBlack];
    
    /** 白色的内容视图 */
    viewCurrent = [[UIView alloc] init];
    [viewCurrent setSize:CGSizeMake(self.width - KCurrentSpacing*2.0f, 250.0f)];
    [viewCurrent setBackgroundColor:[UIColor whiteColor]];
    [viewCurrent.layer setCornerRadius:5.0f];
    [viewCurrent.layer setMasksToBounds:true];
    [self addSubview:viewCurrent];
    
    /** 上传身份证的默认提示图片 */
    imageIdCard = [[UIImageView alloc] init];
    [imageIdCard setSize:CGSizeMake(KImageIdCardSize, KImageIdCardSize)];
    [imageIdCard setCenter:CGPointMake(viewCurrent.centerx, 20.0f + imageIdCard.centery)];
    [imageIdCard setBackgroundColor:[UIColor clearColor]];
    [imageIdCard setImage:[UIImage imageNamed:self.imagePath?:@"1.png"]];
    [viewCurrent addSubview:imageIdCard];
    
    /** 图片的说明标签 */
    lblTitle = [[UILabel alloc] init];
    [lblTitle setFrame:CGRectMake(0, imageIdCard.bottom, viewCurrent.width, 20.0f)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:TITLE_COLOR];
    [lblTitle setFont:kTitleFont];
    [lblTitle setText:self.titleImage?:@""];
    [viewCurrent addSubview:lblTitle];
    
    CGFloat _button_w = (viewCurrent.width - 60.0f)/2.0f;
    
    /** 左边操作按钮 */
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext setFrame:CGRectMake(22.0f, lblTitle.bottom + 20.0f, _button_w, 30.0f)];
    [btnNext setBackgroundColor:[UIColor whiteColor]];
    [btnNext.layer setBorderWidth:1.0f];
    [btnNext.layer setBorderColor:DDGreen_Color.CGColor];
    [btnNext.layer setCornerRadius:btnNext.height/2.0f];
    [btnNext.layer setMasksToBounds:true];
    
    [btnNext.titleLabel setFont:kContentFont];
    [btnNext setTitle:self.titleNext?:@"立即拍摄" forState:UIControlStateNormal];
    [btnNext setTitleColor:DDGreen_Color forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(onClickWithNext:) forControlEvents:UIControlEventTouchUpInside];
    [viewCurrent addSubview:btnNext];
    
    /** 右边操作按钮 */
    btnOther = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOther setFrame:CGRectMake(btnNext.right + 16.0f, btnNext.top, btnNext.width, btnNext.height)];
    [btnOther setBackgroundColor:DDGreen_Color];
    [btnOther.layer setBorderWidth:1.0f];
    [btnOther.layer setBorderColor:DDGreen_Color.CGColor];
    [btnOther.layer setCornerRadius:btnNext.height/2.0f];
    [btnOther.layer setMasksToBounds:true];
    
    [btnOther.titleLabel setFont:kContentFont];
    [btnOther setTitle:self.titleOther?:@"本地上传" forState:UIControlStateNormal];
    [btnOther setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOther addTarget:self action:@selector(onClickWithOther:) forControlEvents:UIControlEventTouchUpInside];
    [viewCurrent addSubview:btnOther];
    
    //确认白色内容视图的位置和大小
    [viewCurrent setSize:CGSizeMake(viewCurrent.width, btnNext.bottom + 25.0f)];
    [viewCurrent setCenter:CGPointMake(self.centerx, self.centery - 20.0f)];


}

#pragma mark - Action
/** 取消，清楚视图 */
- (void)onClickWithClear:(id)sender
{
    [self dismissAlert];
}

- (void)onClickWithNext:(id)sender
{
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(uploadIdCardView:withIndex:)])
    {
        [self.delegate uploadIdCardView:self withIndex:0];
    }
}

- (void)onClickWithOther:(id)sender
{
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(uploadIdCardView:withIndex:)])
    {
        [self.delegate uploadIdCardView:self withIndex:1];
    }
}

#pragma mark - 视图的显示和隐藏
- (void)show
{
    if (self.isShowing) {
        return;
    }
    
    [self.window addSubview:self];
    
    [self setAlpha:0];
    [UIView animateWithDuration:0.35f animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

- (void)dismissAlert
{
    if (!self.isShowing) {
        return;
    }
    
    [UIView animateWithDuration:0.35f animations:^(void) {
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [super removeFromSuperview];
        self.isShowing = NO;
    }];
}

@end
