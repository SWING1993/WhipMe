//
//  DDAlertView.h
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import "DDAlertView.h"
#import "Constant.h"

@interface DDAlertView ()
{
    UIWindow *_window;
}
@property (nonatomic, assign) BOOL          isShowing;
@property (nonatomic, strong) UIView        *viewContent;
@property (nonatomic, strong) UIView        *viewCurrent;
@property (nonatomic, strong) UIButton        *buttonBlack;

@property (nonatomic, strong) NSString      *isTitle;
@property (nonatomic, strong) NSString      *isCancelTitle;
@property (nonatomic, strong) NSString      *isNextTitle;

@property (nonatomic, strong) UIImageView   *imageBottomLine;
@property (nonatomic, strong) UIButton      *btnBack;

@property (nonatomic, strong) UIImageView   *imageCenterLine;
@property (nonatomic, strong) UIButton      *btnNext;

@end

@implementation DDAlertView
@synthesize buttonBlack, viewContent, viewCurrent;
@synthesize imageBottomLine, btnBack, imageCenterLine, btnNext;
@synthesize font_Title, color_Title;

- (instancetype)initWithTitle:(NSString *)objTitle delegate:(id<DDAlertViewDelegate>)objDelegate cancelTitle:(NSString *)cancelTitle nextTitle:(NSString *)nextTitle
{
    self = [super init];
    if (self)
    {
        self.isTitle = objTitle;
        self.delegate = objDelegate;
        self.isCancelTitle = cancelTitle;
        self.isNextTitle = nextTitle;
        
        _window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, CGRectGetWidth(_window.bounds), CGRectGetHeight(_window.bounds));
        
    }
    return self;
}

- (void)show
{
    if (self.isShowing)
    {
        return;
    }
    
    [_window addSubview:self];
    
    [viewContent setAlpha:0];
    [UIView animateWithDuration:0.35f animations:^{
        viewContent.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

- (void)dismissAlert
{
    [self removeSuperview];
}

- (void)removeSuperview
{
    if (!self.isShowing)
    {
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

- (void)onClickWithClear:(id)sender
{
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(ddAlertView:buttonIndex:)])
    {
        [self.delegate ddAlertView:self buttonIndex:0];
    }
}

- (void)onClickWithNext:(id)sender
{
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(ddAlertView:buttonIndex:)])
    {
        [self.delegate ddAlertView:self buttonIndex:1];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
}

- (void)setup
{
    viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [viewContent setBackgroundColor:[UIColor clearColor]];
    [self addSubview:viewContent];
    
    buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBlack setFrame:CGRectMake(0, 0, viewContent.width, viewContent.height)];
    [buttonBlack setBackgroundColor:[UIColor blackColor]];
    [buttonBlack setAlpha:0.3f];
    [buttonBlack addTarget:self action:@selector(onClickWithClear:) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:buttonBlack];
    
    viewCurrent = [[UIView alloc] init];
    [viewCurrent setFrame:CGRectMake(kMargin*2.0f, 100.0f, viewContent.width - kMargin*4.0f, 100.0f)];
    [viewCurrent setBackgroundColor:[UIColor whiteColor]];
    [viewCurrent.layer setCornerRadius:2.0f];
    [viewCurrent.layer setMasksToBounds:true];
    [viewContent addSubview:viewCurrent];
    
    UILabel *lblTitle = [[UILabel alloc] init];
    [lblTitle setFrame:CGRectMake(20.0f, 30.0f, viewCurrent.width - 40.0f, 20.0f)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:color_Title?color_Title:CONTENT_COLOR];
    [lblTitle setFont:font_Title?font_Title:kContentFont];
    [lblTitle setNumberOfLines:0];
    [viewCurrent addSubview:lblTitle];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 5.0f;
    NSDictionary *attributes = @{NSFontAttributeName:lblTitle.font, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize sizeTitle = [self.isTitle boundingRectWithSize:CGSizeMake(lblTitle.width, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil].size;
    
    sizeTitle.height = sizeTitle.height > 40.0f ? floorf(sizeTitle.height+1) : lblTitle.height;
    [lblTitle setSize:CGSizeMake(lblTitle.width, sizeTitle.height)];
    
    if (sizeTitle.height > 40.0f)
    {
        NSMutableAttributedString *attMessage = [[NSMutableAttributedString alloc] initWithString:self.isTitle];
        [attMessage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.isTitle length])];
        [lblTitle setAttributedText:attMessage];
    } else {
        [lblTitle setText:self.isTitle];
    }
    
    imageBottomLine = [[UIImageView alloc] init];
    [imageBottomLine setFrame:CGRectMake(0, lblTitle.bottom + 30.0f, viewCurrent.width, 1.0)];
    [imageBottomLine setBackgroundColor:BORDER_COLOR];
    [viewCurrent addSubview:imageBottomLine];
    
    if ([self.isNextTitle length] > 0)
    {
        btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setFrame:CGRectMake(0, imageBottomLine.bottom, viewCurrent.width/2.0f, 44.0f)];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setBackgroundImage:[UIImage imageWithDrawColor:[UIColor whiteColor] withSize:btnBack.bounds] forState:UIControlStateNormal];
        [btnBack setBackgroundImage:[UIImage imageWithDrawColor:HIGHLIGHT_COLOR withSize:btnBack.bounds] forState:UIControlStateHighlighted];
        
        [btnBack.titleLabel setFont:kContentFont];
        [btnBack setTitle:self.isCancelTitle forState:UIControlStateNormal];
        [btnBack setTitleColor:CONTENT_COLOR forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(onClickWithClear:) forControlEvents:UIControlEventTouchUpInside];
        [viewCurrent addSubview:btnBack];
        
        imageCenterLine = [[UIImageView alloc] init];
        [imageCenterLine setFrame:CGRectMake(btnBack.right, btnBack.origin.y, 1.0, btnBack.height)];
        [imageCenterLine setBackgroundColor:BORDER_COLOR];
        [viewCurrent addSubview:imageCenterLine];
        
        btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNext setFrame:CGRectMake(imageCenterLine.right, btnBack.top, btnBack.width, btnBack.height)];
        [btnNext setBackgroundColor:[UIColor clearColor]];
        [btnNext setBackgroundImage:[UIImage imageWithDrawColor:[UIColor whiteColor] withSize:btnNext.bounds] forState:UIControlStateNormal];
        [btnNext setBackgroundImage:[UIImage imageWithDrawColor:HIGHLIGHT_COLOR withSize:btnNext.bounds] forState:UIControlStateHighlighted];
        
        [btnNext.titleLabel setFont:kContentFont];
        [btnNext setTitle:self.isNextTitle forState:UIControlStateNormal];
        [btnNext setTitleColor:CONTENT_COLOR forState:UIControlStateNormal];
        [btnNext addTarget:self action:@selector(onClickWithNext:) forControlEvents:UIControlEventTouchUpInside];
        [viewCurrent addSubview:btnNext];
    }
    else
    {
        btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack setFrame:CGRectMake(0, imageBottomLine.bottom, viewCurrent.width, 44.0f)];
        [btnBack setBackgroundColor:[UIColor clearColor]];
        [btnBack setBackgroundImage:[UIImage imageWithDrawColor:[UIColor whiteColor] withSize:btnBack.bounds] forState:UIControlStateNormal];
        [btnBack setBackgroundImage:[UIImage imageWithDrawColor:HIGHLIGHT_COLOR withSize:btnBack.bounds] forState:UIControlStateHighlighted];
        
        [btnBack.titleLabel setFont:kContentFont];
        [btnBack setTitle:self.isCancelTitle forState:UIControlStateNormal];
        [btnBack setTitleColor:CONTENT_COLOR forState:UIControlStateNormal];
        [btnBack setTitleColor:RED_COLOR forState:UIControlStateHighlighted];
        [btnBack addTarget:self action:@selector(onClickWithClear:) forControlEvents:UIControlEventTouchUpInside];
        [viewCurrent addSubview:btnBack];
    }
    [viewCurrent setSize:CGSizeMake(viewCurrent.width, btnBack.bottom)];
    [viewCurrent setOrigin:CGPointMake(viewCurrent.left, floorf((viewContent.height - viewCurrent.height)/2.0f))];
}

@end
