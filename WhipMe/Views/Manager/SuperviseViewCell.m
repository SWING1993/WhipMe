//
//  SuperviseViewCell.m
//  WhipMe
//
//  Created by youye on 17/2/20.
//  Copyright © 2017年 -. All rights reserved.
//

#import "SuperviseViewCell.h"

@interface SuperviseViewCell ()

@property (nonatomic, strong) UIImageView *headV, *themeV;
@property (nonatomic, strong) UILabel *themeL, *subTitle, *goingL;

@end

@implementation SuperviseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup {
    WEAKSELF
    
    _headV = [UIImageView new];
    _headV.backgroundColor = [UIColor clearColor];
    _headV.contentMode = UIViewContentModeScaleAspectFill;
    _headV.clipsToBounds = YES;
    _headV.layer.cornerRadius = 40.0/2.0;
    _headV.layer.masksToBounds = true;
    [self.contentView addSubview:self.headV];
    [self.headV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.0);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
        make.right.equalTo(weakSelf.contentView).offset(-9.0);
    }];
    
    _themeV = [UIImageView new];
    _themeV.backgroundColor = [UIColor clearColor];
    _themeV.contentMode = UIViewContentModeScaleAspectFill;
    _themeV.clipsToBounds = YES;
    [self.contentView addSubview:self.themeV];
    [self.themeV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30.0, 30.0));
        make.centerY.equalTo(weakSelf.headV.mas_centerY);
        make.left.mas_equalTo(18.0);
    }];
    
    _themeL = [UILabel new];
    _themeL.backgroundColor = [UIColor clearColor];
    _themeL.textAlignment = NSTextAlignmentLeft;
    _themeL.font = [UIFont systemFontOfSize:14.0];
    _themeL.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.themeL];
    [self.themeL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.themeV.mas_right).offset(16.0);
        make.top.equalTo(weakSelf.headV.mas_top);
        make.height.mas_equalTo(20.0);
        make.width.mas_equalTo(150.0);
    }];
    
    _subTitle = [UILabel new];
    _subTitle.backgroundColor = [UIColor clearColor];
    _subTitle.textAlignment = NSTextAlignmentLeft;
    _subTitle.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.subTitle];
    [self.subTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.themeV.mas_right).offset(16.0);
        make.top.equalTo(weakSelf.themeL.mas_bottom);
        make.height.equalTo(weakSelf.themeL.mas_height);
        make.width.mas_equalTo(200.0);
    }];
    
    _goingL = [UILabel new];
    _goingL.backgroundColor = [UIColor clearColor];
    _goingL.textAlignment = NSTextAlignmentCenter;
    _goingL.font = [UIFont systemFontOfSize:10.0];
    _goingL.textColor = [UIColor whiteColor];
    _goingL.layer.masksToBounds = YES;
    _goingL.layer.cornerRadius = 7.0;
    [self.contentView addSubview:self.goingL];
    [self.goingL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.themeL.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.themeL.mas_centerY);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(40);
    }];
    
}

- (void)setModel:(WhipM *)model {
    _model = model;
    
    [self.themeV setImageWithURL:[NSURL URLWithString:model.themeIcon] placeholderImage:[UIImage imageNamed:@"zaoqi"]];
    self.themeL.text = model.themeName ?: @"";
    CGSize themeLWidth = [self.themeL.text sizeWithAttributes:@{NSFontAttributeName:self.themeL.font}];
    [self.themeL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MIN([Define screenWidth]-134.0, floorf(themeLWidth.width)+1.0));
    }];
    
    [self.headV setImageWithURL:[NSURL URLWithString:model.supervisorIcon] placeholderImage:[Define kDefaultImageHead]];
    
    self.subTitle.textColor = [Define kColorBlue];
    if (model.accept == 0) {
        self.goingL.text = @"待确认";
        self.subTitle.text = [NSString stringWithFormat:@"保证金:%.2f元",model.guarantee];
        self.goingL.backgroundColor = [Define kColorYellow];
    } else if (model.accept == 1) {
        self.goingL.text = @"已拒绝";
        self.subTitle.text = [NSString stringWithFormat:@"保证金:%.2f元",model.guarantee];
        self.goingL.backgroundColor = [Define kColorRed];
    } else {
        self.subTitle.text = [NSString stringWithFormat:@"被鞭挞%ld次",(long)model.recordNum];
    }
    
}

@end
