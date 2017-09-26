//
//  DDLoadingView.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/4/12.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDLoadingView.h"
#import "Constant.h"

@interface DDLoadingView ()

@property (nonatomic,weak) UIImageView *animationImageView;
@end

@implementation DDLoadingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self setFrame:CGRectMake(0, 0, CGRectGetWidth(DDSCreenBounds), CGRectGetHeight(DDSCreenBounds))];
        [window addSubview:self];
        
        [self setItems];
    }
    return self;
}

- (void)setItems
{
    //灰色背景
    UIButton *buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBlack setFrame:CGRectMake(0, 0, CGRectGetWidth(DDSCreenBounds), CGRectGetHeight(DDSCreenBounds))];
    [buttonBlack setBackgroundColor:[UIColor blackColor]];
    [buttonBlack setAlpha:0.3f];
    [self addSubview:buttonBlack];
    
    NSMutableArray *imagesArray = [NSMutableArray array];
    for (NSInteger i = 1; i < 17; i ++) {
        [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loding-1000%02ld.png",(long)i]]];
    }
    
    UIImageView *animationImageView = [[UIImageView alloc] init];
    CGFloat animationBtnW = buttonBlack.width*0.4;
    CGFloat animationBtnH = buttonBlack.height*0.2;
    CGFloat animationBtnX = buttonBlack.width*0.3;
    CGFloat animationBtnY = buttonBlack.height*0.4;
    [animationImageView setFrame:CGRectMake(animationBtnX, animationBtnY, animationBtnW, animationBtnH)];
    [animationImageView setBackgroundColor:[UIColor whiteColor]];
    [animationImageView.layer setCornerRadius:5.0f];
    [animationImageView.layer setMasksToBounds:true];
    animationImageView.animationImages = imagesArray;//将序列帧数组赋给UIImageView的animationImages属性
    animationImageView.animationDuration = 0.65;//设置动画时间
    animationImageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    [animationImageView startAnimating];//开始播放动画
    
    UILabel *alertTitleLabel = [[UILabel alloc] init];
    [alertTitleLabel setFrame:CGRectMake(0, animationImageView.height - 25, animationImageView.width, 15.0f)];
    [alertTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [alertTitleLabel setFont:kTitleFont];
    [alertTitleLabel setTextColor:TITLE_COLOR];
    [alertTitleLabel setText:@"努力加载中..."];
    [animationImageView addSubview:alertTitleLabel];
    
    [self addSubview:animationImageView];
}

//- (void)layoutSubviews
//{
//    self.frame = CGRectMake(0, 0, 200, 200);
//    
//    self.animationImageView.frame = CGRectMake(100, 100, 200, 200);
//}

@end
