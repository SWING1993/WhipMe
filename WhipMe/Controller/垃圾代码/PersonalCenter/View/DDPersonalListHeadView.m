//
//  DDPernalListHeadView.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/24.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPersonalListHeadView.h"
#import "DDSelfInfomation.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "CustomStringUtils.h"

/** 头像宽高 */
#define HeadIcon_WH 59
/** 头像，名字，电话的X坐标 */
#define HeadIcon_X 20

@interface DDPersonalListHeadView ()

/** 个人头像,点击可以跳转到详情页面 */
@property (nonatomic, strong) UIImageView *imageHeadIcon;
/** 名字标签 */
@property (nonatomic, strong) UILabel *lblNickname;
/** 电话标签 */
@property (nonatomic, strong) UILabel *lblPhoneNumber;

@end

@implementation DDPersonalListHeadView
@synthesize imageHeadIcon;
@synthesize lblNickname;
@synthesize lblPhoneNumber;

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
    }
    return self;
}

- (void)updateUserInfo
{
    NSString *imageUrl = [CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"avatar"]] ? @"" : [LocalUserInfo objectForKey:@"avatar"];
    [imageHeadIcon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:DDPersonalHeadIcon]];
    
    if ([CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"name"]]) {
        [lblNickname setTextColor:DDRGBColor(145, 241, 189)];
        [lblNickname setText:@"昵称未设置"];
    } else {
        [lblNickname setTextColor:[UIColor whiteColor]];
        [lblNickname setText:[LocalUserInfo objectForKey:@"nick"]];
    }
    
    [lblPhoneNumber setText:[CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"phone"]] ? @"" : [LocalUserInfo objectForKey:@"phone"]];
}

- (CGFloat)originYHeadSize
{
    CGFloat tableHeaderViewHeight = (MainScreenHeight - DDLeftSliderMenuScale * MainScreenHeight)/2 + 120 * DDLeftSliderMenuScale;
    
    CGFloat imageH = floorf(tableHeaderViewHeight) - 30.0f - HeadIcon_WH;
    return imageH;
}

#pragma mark - 类的对象方法:设置 view
/**  设置头像等控件 */
- (void)setItems
{
    //初始化头像
    imageHeadIcon = [[UIImageView alloc] init];
    [imageHeadIcon setFrame:CGRectMake(HeadIcon_X, [self originYHeadSize], HeadIcon_WH, HeadIcon_WH)];
    [imageHeadIcon setUserInteractionEnabled:YES];
    [imageHeadIcon.layer setCornerRadius:imageHeadIcon.height/2.0f];
    [imageHeadIcon.layer setMasksToBounds:true];
    [self addSubview:imageHeadIcon];
    
    UITapGestureRecognizer *headTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickWithHead:)];
    [imageHeadIcon addGestureRecognizer:headTap];
    
    //初始化名字标签
    lblNickname = [[UILabel alloc] init];
    [lblNickname setFrame:CGRectMake(imageHeadIcon.right + 14.0f, imageHeadIcon.top + 10.0f, 200.0f, 20.0f)];
    [lblNickname setBackgroundColor:[UIColor clearColor]];
    [lblNickname setTextAlignment:NSTextAlignmentLeft];
    [lblNickname setFont:kContentFont];
    [lblNickname setTextColor:[UIColor whiteColor]];
    [lblNickname setUserInteractionEnabled:true];
    [self addSubview:lblNickname];
    
    UITapGestureRecognizer *nicknameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickWithHead:)];
    [lblNickname addGestureRecognizer:nicknameTap];
    
    //初始化电话号码标签
    lblPhoneNumber = [[UILabel alloc] init];
    [lblPhoneNumber setFrame:CGRectMake(lblNickname.left, lblNickname.bottom + 8.0f, lblNickname.width, lblNickname.height)];
    [lblPhoneNumber setBackgroundColor:[UIColor clearColor]];
    [lblPhoneNumber setTextAlignment:NSTextAlignmentLeft];
    [lblPhoneNumber setFont:kTitleFont];
    [lblPhoneNumber setTextColor:[UIColor whiteColor]];
    [lblPhoneNumber setUserInteractionEnabled:true];
    [self addSubview:lblPhoneNumber];
    
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickWithHead:)];
    [lblPhoneNumber addGestureRecognizer:phoneTap];
}

#pragma mark - 类的对象方法:监听点击事件
/**
    点击箭头按钮响应
 */
- (void)onClickWithHead:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(personalListHeadDidClick)]) {
        [self.delegate personalListHeadDidClick];
    }
}


@end
