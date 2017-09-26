//
//  KMoreAlertView.m
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

#define KMoreItem_H 34.0f
#define KMoreView_W 135.0f

#import "DDMoreAlertView.h"
#import "Constant.h"

@interface DDMoreAlertView ()
{
    float _topFloat;
    float _centerFloat;
    
    UIWindow *_window;
}

@property (nonatomic, assign) BOOL     isShowing;
@property (nonatomic, strong) UIButton *buttonBgView;
@property (nonatomic, strong) NSArray  *arrayTitles;

@end

@implementation DDMoreAlertView
@synthesize buttonBgView, arrayTitles;

- (instancetype)initWithImageArray:(NSArray *)titles delegate:(id<DDMoreAlertViewDelegate>)delegate top:(float)topFloat center:(float)centerFloat
{
    self = [super init];
    if (self)
    {
        arrayTitles = titles;
        _topFloat = topFloat;
        _centerFloat = centerFloat;
        self.delegate = delegate;
        
        _window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, CGRectGetWidth(_window.bounds), CGRectGetHeight(_window.bounds));
        
        [self setupImage];
        
    }
    return self;
}

- (void)setupImage
{
    UIButton *viewBlack = [[UIButton alloc] init];
    [viewBlack setFrame:CGRectMake(0, 0, self.width, self.height)];
    [viewBlack setBackgroundColor:[UIColor clearColor]];
    [viewBlack addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewBlack];
    
    UIImage *labelNormal = [UIImage imageNamed:DDCourierList_Bubble];
    labelNormal = [labelNormal stretchableImageWithLeftCapWidth:labelNormal.size.width * 0.15f topCapHeight:labelNormal.size.height * 0.5f];
    buttonBgView = [[UIButton alloc] init];
    [buttonBgView setFrame:CGRectMake(self.width - KMoreView_W - _centerFloat, _topFloat, KMoreView_W, arrayTitles.count*KMoreItem_H)];
    [buttonBgView setBackgroundColor:[UIColor clearColor]];
    [buttonBgView setBackgroundImage:labelNormal forState:UIControlStateNormal];
    [buttonBgView setAdjustsImageWhenHighlighted:false];
    [self addSubview:buttonBgView];
    
    UIScrollView *itemScroll = [[UIScrollView alloc] init];
    [itemScroll setFrame:CGRectMake(kMargin, kMargin, buttonBgView.width -kMargin*2.0f, buttonBgView.height - kMargin)];
    [itemScroll setBackgroundColor:[UIColor clearColor]];
    [itemScroll setShowsHorizontalScrollIndicator:false];
    [itemScroll setShowsVerticalScrollIndicator:false];
    [itemScroll setUserInteractionEnabled:true];
    [buttonBgView addSubview:itemScroll];
    
    for (int i=0; i<[arrayTitles count]; i++)
    {
        NSDictionary *dict = arrayTitles[i];
        
        UIButton *btnItem = [[UIButton alloc] init];
        [btnItem setFrame:CGRectMake( 0, i*KMoreItem_H, itemScroll.width, KMoreItem_H)];
        [btnItem setBackgroundColor:[UIColor clearColor]];
        [btnItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btnItem setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [btnItem setContentEdgeInsets:UIEdgeInsetsMake(0, 5.0f, 0, 0)];
        [btnItem setAdjustsImageWhenHighlighted:false];
        [btnItem addTarget:self action:@selector(didIsButton:) forControlEvents:UIControlEventTouchUpInside];
        [itemScroll addSubview:btnItem];
        
        //获取字符
        NSString *item_str = [NSString stringWithFormat:@"  %@",dict[@"title"]];
        
        //给字符串添加图标
        NSTextAttachment *itemImage = [[NSTextAttachment alloc] init];
        [itemImage setImage:[UIImage imageNamed:dict[@"imageIcon"]]];
        [itemImage setBounds:CGRectMake(0, -6, 20.0f, 20.0f)];
        NSAttributedString *itemASString = [NSAttributedString attributedStringWithAttachment:itemImage];
        
        NSDictionary *attribute = @{NSFontAttributeName:kTitleFont,
                                    NSForegroundColorAttributeName:[UIColor whiteColor]};
        //创建可编辑字符串
        NSMutableAttributedString *att_item_str = [[NSMutableAttributedString alloc] initWithString:item_str attributes:attribute];
        [att_item_str insertAttributedString:itemASString atIndex:0];
        [btnItem setAttributedTitle:att_item_str forState:UIControlStateNormal];
        
        UIImageView *imageDown = [[UIImageView alloc] init];
        [imageDown setFrame:CGRectMake(0, btnItem.height - 0.5f, btnItem.width, 0.5f)];
        [imageDown setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.3]];
        [btnItem addSubview:imageDown];
        
        if (i == [arrayTitles count] - 1) {
            [imageDown setHidden:YES];
        }
    }
    [itemScroll setContentSize:CGSizeMake(itemScroll.width, arrayTitles.count*KMoreItem_H)];
    [itemScroll setSize:CGSizeMake(itemScroll.width, MIN(arrayTitles.count*KMoreItem_H, (self.height - _topFloat)/2.0f))];
    [buttonBgView setSize:CGSizeMake(buttonBgView.width, itemScroll.height + kMargin*2.0f)];
    
}

- (instancetype)initWithTitles:(NSArray *)titles delegate:(id<DDMoreAlertViewDelegate>)delegate top:(float)topFloat center:(float)centerFloat
{
    self = [super init];
    if (self)
    {
        arrayTitles = titles;
        _topFloat = topFloat;
        _centerFloat = centerFloat;
        self.delegate = delegate;
        
        _window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, CGRectGetWidth(_window.bounds), CGRectGetHeight(_window.bounds));
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIButton *viewBlack = [[UIButton alloc] init];
    [viewBlack setFrame:CGRectMake(0, 0, self.width, self.height)];
    [viewBlack setBackgroundColor:[UIColor clearColor]];
    [viewBlack addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewBlack];
    
    UIImage *labelNormal = [UIImage imageNamed:DDCourierList_Bubble];
    labelNormal = [labelNormal stretchableImageWithLeftCapWidth:labelNormal.size.width * 0.15f topCapHeight:labelNormal.size.height * 0.5f];
    buttonBgView = [[UIButton alloc] init];
    [buttonBgView setFrame:CGRectMake(self.width - KMoreView_W - _centerFloat, _topFloat, KMoreView_W, arrayTitles.count*KMoreItem_H)];
    [buttonBgView setBackgroundColor:[UIColor clearColor]];
    [buttonBgView setBackgroundImage:labelNormal forState:UIControlStateNormal];
    [buttonBgView setAdjustsImageWhenHighlighted:false];
    [self addSubview:buttonBgView];
    
    UIScrollView *itemScroll = [[UIScrollView alloc] init];
    [itemScroll setFrame:CGRectMake(kMargin, kMargin, buttonBgView.width -kMargin*2.0f, buttonBgView.height - kMargin)];
    [itemScroll setBackgroundColor:[UIColor clearColor]];
    [itemScroll setShowsHorizontalScrollIndicator:false];
    [itemScroll setShowsVerticalScrollIndicator:false];
    [itemScroll setUserInteractionEnabled:true];
    [buttonBgView addSubview:itemScroll];
    
    for (int i=0; i<[arrayTitles count]; i++)
    {
        UIButton *btnItem = [[UIButton alloc] init];
        [btnItem setFrame:CGRectMake( 0, i*KMoreItem_H, itemScroll.width, KMoreItem_H)];
        [btnItem setBackgroundColor:DDGreen_Color];
        [btnItem.titleLabel setFont:kTitleFont];
        [btnItem setTitle:arrayTitles[i] forState:UIControlStateNormal];
        [btnItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnItem setAdjustsImageWhenHighlighted:false];
        [btnItem addTarget:self action:@selector(didIsButton:) forControlEvents:UIControlEventTouchUpInside];
        [itemScroll addSubview:btnItem];
        
        UIImageView *imageDown = [[UIImageView alloc] init];
        [imageDown setFrame:CGRectMake(0, btnItem.height - 0.5f, btnItem.width, 0.5f)];
        [imageDown setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.3]];
        [btnItem addSubview:imageDown];
        
        if (i == [arrayTitles count] - 1)
        {
            [imageDown setHidden:YES];
        }
    }
    [itemScroll setContentSize:CGSizeMake(itemScroll.width, arrayTitles.count*KMoreItem_H)];
    [itemScroll setSize:CGSizeMake(itemScroll.width, MIN(arrayTitles.count*KMoreItem_H, (self.height - _topFloat)/2.0f))];
    [buttonBgView setSize:CGSizeMake(buttonBgView.width, itemScroll.height + kMargin*2.0f)];

}

- (void)didIsButton:(UIButton *)sender
{
    [self removeSuperview];
    
    NSInteger index = lrintf(sender.origin.y / sender.height);
    if ([self.delegate respondsToSelector:@selector(ddMoreAlertView:AtIndex:)])
    {
        [self.delegate ddMoreAlertView:self AtIndex:index];
    }
}

- (void)dismissAlert
{
    [self removeSuperview];
}

- (void)show
{
    if (self.isShowing) {
        return;
    }
    
    [_window addSubview:self];
    
    [self setAlpha:0];
    [UIView animateWithDuration:0.35f animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
    
}

- (void)removeSuperview
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
