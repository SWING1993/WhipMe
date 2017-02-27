//
//  WMShareImageView.m
//  Deom_2017_02_07
//
//  Created by youye on 17/2/25.
//  Copyright © 2017年 sely. All rights reserved.
//

#import "WMShareImageView.h"

@interface WMShareImageView ()

@property (nonatomic, strong) UIImageView *imageCustom, *imgCode;
@property (nonatomic, strong) UILabel *lblName, *lblDetail, *lblTitle;
@property (nonatomic, strong) UIView *viewBottom;

@end

@implementation WMShareImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _imageCustom = [[UIImageView alloc] init];
    [_imageCustom setFrame:[UIScreen mainScreen].bounds];
    [_imageCustom setBackgroundColor:[UIColor whiteColor]];
    [_imageCustom setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:self.imageCustom];
    
    _viewBottom = [UIView new];
    [_viewBottom setBackgroundColor:[UIColor blackColor]];
    [_viewBottom setAlpha:0.5];
    [self.imageCustom addSubview:self.viewBottom];
    
    _imgCode = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRcode"]];
    [_imgCode setBackgroundColor:[UIColor clearColor]];
    [_imgCode setContentMode:UIViewContentModeScaleAspectFill];
    [_imgCode setClipsToBounds:YES];
    [self.imageCustom addSubview:_imgCode];
    
    _lblName = [UILabel new];
    [_lblName setText:@"by"];
    [_lblName setTextAlignment:NSTextAlignmentRight];
    [_lblName setTextColor:[UIColor colorWithWhite:0.7 alpha:1.0]];
    [_lblName setFont:[UIFont systemFontOfSize:10.0]];
    [self.imageCustom addSubview:_lblName];
    
    _lblDetail = [UILabel new];
    [_lblDetail setText:@"长按识别二维码，下载鞭挞我"];
    [_lblDetail setTextAlignment:NSTextAlignmentRight];
    [_lblDetail setTextColor:[UIColor whiteColor]];
    [_lblDetail setFont:[UIFont systemFontOfSize:12.0]];
    [self.imageCustom addSubview:_lblDetail];
    
    _lblTitle = [UILabel new];
    [_lblTitle setText:@"开启你的改变故事"];
    [_lblTitle setTextAlignment:NSTextAlignmentRight];
    [_lblTitle setTextColor:[UIColor greenColor]];
    [_lblTitle setFont:[UIFont systemFontOfSize:16.0]];
    [self.imageCustom addSubview:_lblTitle];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    WEAKSELF
    [self.viewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(weakSelf.imageCustom);
        make.height.mas_equalTo(100.0);
        make.bottom.equalTo(weakSelf.imageCustom);
    }];
    [self.imgCode mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62.0, 62.0));
        make.right.equalTo(weakSelf.imageCustom).offset(-24.0);
        make.bottom.equalTo(weakSelf.imageCustom).offset(-16.0);
    }];
    [self.lblName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageCustom).offset(24.0);
        make.right.equalTo(weakSelf.imgCode.mas_left).offset(-15.0);
        make.height.mas_equalTo(14.0);
        make.top.equalTo(weakSelf.imgCode.mas_top);
    }];
    [self.lblDetail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblName.mas_left);
        make.right.equalTo(weakSelf.lblName.mas_right);
        make.height.mas_equalTo(20.0);
        make.centerY.equalTo(weakSelf.imgCode.mas_centerY);
    }];
    [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblName.mas_left);
        make.right.equalTo(weakSelf.lblName.mas_right);
        make.height.mas_equalTo(20.0);
        make.bottom.equalTo(weakSelf.imgCode.mas_bottom).offset(2.0);
    }];
    
}

- (void)setName:(NSString *)name {
    _name = name;
    [self.lblName setText:[NSString stringWithFormat:@"by%@",name]];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imageCustom setImage:image];
    
    CGFloat ratio_r = self.imageCustom.width/image.size.width;
    CGFloat ratio_h = image.size.height*ratio_r;
    
    [self.imageCustom setSize:CGSizeMake(self.imageCustom.width, ratio_h)];
    [self setSize:self.imageCustom.size];
}



@end
