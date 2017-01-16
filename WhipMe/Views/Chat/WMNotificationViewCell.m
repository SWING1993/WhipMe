//
//  WMNotificationViewCell.m
//  WhipMe
//
//  Created by anve on 17/1/14.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMNotificationViewCell.h"
#import "NotificationModel.h"

@implementation WMNotificationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    WEAK_SELF
    _lblTitle = [UILabel new];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    _lblTitle.textColor = [Define kColorBlack];
    _lblTitle.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.lblTitle];
    [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10.0);
        make.left.equalTo(weakSelf.contentView).offset(15.0);
        make.width.equalTo(weakSelf.contentView).multipliedBy(0.5).offset(-20.0);
        make.height.mas_equalTo(20.0);
    }];
    
    _lblDate = [UILabel new];
    _lblDate.backgroundColor = [UIColor clearColor];
    _lblDate.textAlignment = NSTextAlignmentRight;
    _lblDate.textColor = [Define kColorLight];
    _lblDate.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.lblDate];
    [self.lblDate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10.0);
        make.right.equalTo(weakSelf.contentView).offset(-15.0);
        make.width.equalTo(weakSelf.contentView).multipliedBy(0.5).offset(-20.0);
        make.height.mas_equalTo(20.0);
    }];
    
    _lblContent = [UILabel new];
    _lblContent.backgroundColor = [UIColor clearColor];
    _lblContent.textAlignment = NSTextAlignmentLeft;
    _lblContent.textColor = [Define kColorLight];
    _lblContent.font = [UIFont systemFontOfSize:14.0];
    _lblContent.numberOfLines = 0;
    [self.contentView addSubview:self.lblContent];
    [self.lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lblTitle.mas_bottom).offset(10.0);
        make.left.equalTo(weakSelf.contentView).offset(15.0);
        make.width.equalTo(weakSelf.contentView).offset(-30.0);
        make.height.mas_equalTo(20.0);
    }];
}

+ (CGFloat)cellHeight:(NSString *)content {
    CGSize size_h = CGSizeZero;
    if ([NSString isBlankString:content] == NO) {
        NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
        pStyle.lineSpacing = 5.0f;
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName:pStyle};
        size_h = [content boundingRectWithSize:CGSizeMake([Define screenWidth]-30.0, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attribute
                                       context:nil].size;
    }
    return MAX(70.0, floorf(size_h.height + 1.0) + 50.0);
}

- (void)setCellModel:(NotificationModel *)model {
    _cellModel = model;
    
    [self.lblTitle setText:model.nid];
    [self.lblDate setText:model.createDate];
    if ([NSString isBlankString:model.content]) {
        [self.lblContent setAttributedText:nil];
        [self.lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20.0);
        }];
        return;
    }
    NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
    pStyle.lineSpacing = 5.0f;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName:pStyle, NSForegroundColorAttributeName:[Define kColorLight]};
    
    CGSize size_h = [model.content boundingRectWithSize:CGSizeMake([Define screenWidth]-30.0, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attribute
                                   context:nil].size;
    [self.lblContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(MAX(20.0, floorf(size_h.height+1.0)));
    }];
    
    NSMutableAttributedString *att_content = [[NSMutableAttributedString alloc] initWithString:model.content attributes:attribute];
    [self.lblContent setAttributedText:att_content];
}

@end
