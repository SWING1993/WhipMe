//
//  WMExitAlertView.m
//  WhipMe
//
//  Created by anve on 17/1/24.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMExitAlertView.h"

@interface WMExitAlertView ()

@property (nonatomic, assign) BOOL          isShowing;
@property (nonatomic, strong) UIView        *viewCurrent;

@property (nonatomic, strong) UILabel       *lblMark, *lineTitle;
@property (nonatomic, strong) UIButton      *btnCancel, *btnConfirm, *btnBack, *btnTitle;
@property (nonatomic, strong) UIImageView   *imageIcon;

@end

@implementation WMExitAlertView


- (instancetype)initWithTitle:(NSString *)objTitle delegate:(id<WMExitAlertViewDelegate>)objDelegate cancel:(NSString *)cancelT confirm:(NSString *)confirmT
{
    self = [super init];
    if (self) {
        _title = objTitle;
        _delegate = objDelegate;
        _cancelTitle = cancelT;
        _confirmTitle = confirmT;
        
        [self setFrame:CGRectMake(0, 0, [Define screenWidth], [Define screenHeight])];
        [self setup];
    }
    return self;
}

- (CGFloat)sizeByWidth {
    CGFloat float_r = 550.0/750.0;
    return float_r*[Define screenWidth];
}

- (void)setup
{
    WEAK_SELF
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnBack setBackgroundColor:[UIColor blackColor]];
    [_btnBack setAlpha:0.3f];
    [_btnBack addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnBack];
    [_btnBack mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    _viewCurrent = [UIView new];
    [_viewCurrent setBackgroundColor:[UIColor clearColor]];
    [_viewCurrent.layer setCornerRadius:4.0];
    [_viewCurrent.layer setMasksToBounds:YES];
    [self addSubview:self.viewCurrent];
    [self.viewCurrent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([weakSelf sizeByWidth]);
        make.height.mas_equalTo(150.0);
        make.center.equalTo(weakSelf);
    }];
    
    _btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTitle setBackgroundColor:rgb(44, 44, 44)];
    [_btnTitle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_btnTitle setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_btnTitle.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_btnTitle.titleLabel setNumberOfLines:0];
    [_btnTitle setUserInteractionEnabled:NO];
    [_btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnTitle setTitleEdgeInsets:UIEdgeInsetsMake(38.0, 25.0, 20.0, 25.0)];
    [self.viewCurrent addSubview:self.btnTitle];
    [self.btnTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(90.0);
        make.width.equalTo(weakSelf.viewCurrent);
        make.top.equalTo(weakSelf.viewCurrent);
        make.centerX.equalTo(weakSelf.viewCurrent);
    }];
    
    CGFloat height_title = 90.0;
    if ([NSString isBlankString:self.title] == NO) {
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        [pStyle setLineSpacing:5.f];
        
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:pStyle};
        
        NSMutableAttributedString *att_title = [[NSMutableAttributedString alloc] initWithString:self.title attributes:attribute];
        [self.btnTitle setAttributedTitle:att_title forState:UIControlStateNormal];
        
        CGSize size_h = [self.title boundingRectWithSize:CGSizeMake([self sizeByWidth], MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        height_title = MAX(90.0, floorf(size_h.height + 1.0)+58.0);
        [self.btnTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height_title);
        }];
    } else {
        [self.btnTitle setAttributedTitle:nil forState:UIControlStateNormal];
        [self.btnTitle setTitle:@"" forState:UIControlStateNormal];
    }
//    [self.viewCurrent mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(MAX(150.0, 60.0f+height_title));
//    }];
    
    _lineTitle = [[UILabel alloc] init];
    [_lineTitle setBackgroundColor:[UIColor clearColor]];
    [_viewCurrent addSubview:_lineTitle];
    [_lineTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(weakSelf.viewCurrent);
        make.height.mas_equalTo(2.0);
        make.top.equalTo(weakSelf.btnTitle.mas_bottom);
    }];
    
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel setBackgroundColor:rgb(44, 44, 44)];
    [_btnCancel setTitle:self.cancelTitle ?: @"确定" forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(onClclickWithCanel) forControlEvents:UIControlEventTouchUpInside];
    [_viewCurrent addSubview:_btnCancel];
    [_btnCancel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineTitle.mas_bottom);
        make.left.equalTo(weakSelf.viewCurrent);
        make.height.mas_equalTo(58.0);
        make.width.equalTo(weakSelf.viewCurrent).multipliedBy(0.5).offset(-0.5);
    }];
    
    if ([NSString isBlankString:self.confirmTitle] == NO) {
        _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnConfirm setBackgroundColor:[Define kColorRed]];
        [_btnConfirm setTitle:self.confirmTitle ?:@"" forState:UIControlStateNormal];
        [_btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnConfirm addTarget:self action:@selector(onClclickWithConfirm) forControlEvents:UIControlEventTouchUpInside];
        [_viewCurrent addSubview:_btnConfirm];
        [_btnConfirm mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.btnCancel.mas_top);
            make.right.equalTo(weakSelf.viewCurrent);
            make.height.equalTo(weakSelf.btnCancel.mas_height);
            make.width.equalTo(weakSelf.btnCancel.mas_width);
        }];
    }
    
    _imageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exit_alert_icon"]];
    [_imageIcon setBackgroundColor:[UIColor clearColor]];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_imageIcon setClipsToBounds:YES];
    [self addSubview:self.imageIcon];
    [self.imageIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(219/2.0, 186/2.0));
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf.viewCurrent.mas_top);
    }];
}

#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.isShowing) {
        return;
    }
    self.isShowing = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self setAlpha:0];
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismissAlert {
    [self removeSuperview];
}

- (void)removeSuperview {
    if (!self.isShowing) {
        return;
    }
    
    [UIView animateWithDuration:0.35f animations:^(void) {
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isShowing = NO;
    }];
}

- (void)onClclickWithCanel {
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(exitAlertView:buttonIndex:)]) {
        [self.delegate exitAlertView:self buttonIndex:0];
    }
}

- (void)onClclickWithConfirm {
    [self dismissAlert];
    if ([self.delegate respondsToSelector:@selector(exitAlertView:buttonIndex:)]) {
        [self.delegate exitAlertView:self buttonIndex:1];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

@end
