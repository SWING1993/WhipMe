//
//  BlackListManagerViewCell.m
//  WhipMe
//
//  Created by youye on 17/4/1.
//  Copyright © 2017年 -. All rights reserved.
//

#import "BlackListManagerViewCell.h"

static NSInteger const iconWH = 41.0;

@implementation BlackListManagerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setup];
    }
    return self;
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass(self.class);
}

+ (CGFloat)cellHeight {
    return 65.0;
}

- (void)setup {
    WEAKSELF
    _viewCurrent = [UIView new];
    _viewCurrent.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.viewCurrent];
    [self.viewCurrent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.contentView);
        make.centerX.equalTo(weakSelf.contentView);
        make.top.equalTo(weakSelf.contentView);
        make.height.equalTo(weakSelf.contentView);
    }];
    
    _imageIcon = [UIImageView new];
    _imageIcon.backgroundColor = [Define kColorBackGround];
    _imageIcon.layer.cornerRadius = iconWH/2.0;
    _imageIcon.layer.masksToBounds = YES;
    _imageIcon.contentMode = UIViewContentModeScaleAspectFill;
    _imageIcon.clipsToBounds = YES;
    [self.viewCurrent addSubview:self.imageIcon];
    [self.imageIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0);
        make.centerY.equalTo(weakSelf.viewCurrent);
        make.size.mas_equalTo(CGSizeMake(iconWH, iconWH));
    }];
    
    _lblTitle = [UILabel new];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.textColor = [Define kColorBlack];
    _lblTitle.font = [UIFont systemFontOfSize:15.0];
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    _lblTitle.text = @"";
    [self.viewCurrent addSubview:self.lblTitle];
    [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageIcon.mas_right).offset(15.0);
        make.top.equalTo(weakSelf.imageIcon.mas_top);
        make.right.equalTo(weakSelf.viewCurrent).offset(-90.0);
        make.height.mas_equalTo(20);
    }];
    
    _lblDescribe = [UILabel new];
    _lblDescribe.backgroundColor = [UIColor clearColor];
    _lblDescribe.textColor = [Define kColorLight];
    _lblDescribe.font = [UIFont systemFontOfSize:11.0];
    _lblDescribe.textAlignment = NSTextAlignmentLeft;
    _lblDescribe.text = @"";
    [self.viewCurrent addSubview:self.lblDescribe];
    [self.lblDescribe mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblTitle.mas_left);
        make.top.equalTo(weakSelf.lblTitle.mas_bottom);
        make.width.equalTo(weakSelf.lblTitle.mas_width);
        make.height.mas_equalTo(20);
    }];
    
    CGRect size_chek = CGRectMake( 0, 0, 75.0, 28.0);
    _btnCheck = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCheck setBackgroundImage:[UIImage imageWithDraw:[Define kColorLight] sizeMake:size_chek] forState:UIControlStateNormal];
    _btnCheck.layer.cornerRadius = size_chek.size.height/2.0;
    _btnCheck.layer.masksToBounds = YES;
    [_btnCheck setTitle:@"移除黑名单" forState:UIControlStateNormal];
    [_btnCheck.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_btnCheck setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnCheck addTarget:self action:@selector(onClickWithCheck:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewCurrent addSubview:self.btnCheck];
    [self.btnCheck mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size_chek.size);
        make.right.equalTo(weakSelf.viewCurrent).offset(-15.0);
        make.centerY.equalTo(weakSelf.viewCurrent);
    }];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [Define kColorLine];
    [self.viewCurrent addSubview:self.lineView];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.viewCurrent);
        make.width.equalTo(weakSelf.viewCurrent);
        make.bottom.equalTo(weakSelf.viewCurrent);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)onClickWithCheck:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(blackListManagerViewCellWithCheck:)]) {
        [self.delegate blackListManagerViewCellWithCheck:self];
    }
}

- (void)setModel:(FansAndFocusModel *)model {
    _model = model;
    
    [self.imageIcon setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[Define kDefaultImageHead]];
    
    if ([NSString isBlankString:model.nickname]) {
        [self.lblTitle setText:@""];
    } else {
        [self.lblTitle setText:model.nickname];
    }
    if ([NSString isBlankString:model.sign]) {
        [self.lblDescribe setText:@""];
    } else {
        [self.lblDescribe setText:model.sign];
    }
    
}

@end
