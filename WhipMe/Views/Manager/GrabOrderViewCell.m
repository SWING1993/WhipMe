//
//  GrabOrderViewCell.m
//  WhipMe
//
//  Created by youye on 17/2/20.
//  Copyright © 2017年 -. All rights reserved.
//

#import "GrabOrderViewCell.h"

@interface GrabOrderViewCell ()

@property (nonatomic, strong) UIImageView *headV, *themeV;
@property (nonatomic, strong) UILabel *themeL, *subTitle, *guaranteeL, *contentL;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *acceptBtn, *refuseBtn;

@end

@implementation GrabOrderViewCell

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
    _subTitle.textColor = [Define kColorGary];
    [self.contentView addSubview:self.subTitle];
    [self.subTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.themeV.mas_right).offset(16.0);
        make.top.equalTo(weakSelf.themeL.mas_bottom);
        make.height.equalTo(weakSelf.themeL.mas_height);
        make.width.mas_equalTo(200.0);
    }];
    
    _contentL = [UILabel new];
    _contentL.backgroundColor = [UIColor clearColor];
    _contentL.textAlignment = NSTextAlignmentLeft;
    _contentL.font = [UIFont systemFontOfSize:14.0];
    _contentL.textColor = [UIColor blackColor];
    _contentL.numberOfLines = 0;
    [self.contentView addSubview:self.contentL];
    [self.contentL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.subTitle.mas_left);
        make.right.equalTo(weakSelf.contentView).offset(-16.0);
        make.top.equalTo(weakSelf.subTitle.mas_bottom).offset(10.0);
        make.height.mas_equalTo(20.0);
    }];
    
    _line = [UIView new];
    _line.backgroundColor = rgba(153, 153, 153, 0.5);
    [self.contentView addSubview:self.line];
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.themeL.mas_left);
        make.right.equalTo(weakSelf.contentView).offset(-3);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(weakSelf.contentView).offset(-44.0);
    }];
    
    _guaranteeL = [UILabel new];
    _guaranteeL.backgroundColor = [UIColor clearColor];
    _guaranteeL.textAlignment = NSTextAlignmentLeft;
    _guaranteeL.font = [UIFont systemFontOfSize:10.0];
    _guaranteeL.textColor = [Define kColorRed];
    [self.contentView addSubview:self.guaranteeL];
    [self.guaranteeL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.line.mas_left);
        make.height.mas_equalTo(22.0);
        make.width.mas_equalTo(100);
        make.bottom.equalTo(weakSelf.contentView).offset(-11);
    }];
    
    _acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _acceptBtn.backgroundColor = [Define kColorBlue];
    _acceptBtn.layer.cornerRadius = 11;
    _acceptBtn.layer.masksToBounds = true;
    _acceptBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [_acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
    [_acceptBtn addTarget:self action:@selector(onclickWithAccept) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.acceptBtn];
    [self.acceptBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22.0);
        make.width.mas_equalTo(50.0);
        make.right.equalTo(weakSelf.contentView).offset(-9);
        make.centerY.equalTo(weakSelf.guaranteeL.mas_centerY);
    }];
    
    _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refuseBtn.backgroundColor = rgb(216.0, 198.0, 147.0);
    _refuseBtn.layer.cornerRadius = 11;
    _refuseBtn.layer.masksToBounds = true;
    _refuseBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [_refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_refuseBtn addTarget:self action:@selector(onclickWithrefuse) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.refuseBtn];
    [self.refuseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(50);
        make.right.equalTo(weakSelf.acceptBtn.mas_left).offset(-12);
        make.centerY.equalTo(weakSelf.guaranteeL.mas_centerY);
    }];

}

+ (CGFloat)cellHeight:(NSString *)content {
    CGSize size_h = CGSizeZero;
    if ([NSString isBlankString:content] == NO) {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        size_h = [content boundingRectWithSize:CGSizeMake([Define screenWidth]-80.0, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attribute
                                       context:nil].size;
    }
    return MAX(85.0+44.0, floorf(size_h.height + 1.0) + 10.0);
}

//拒绝
- (void)onclickWithAccept {
    [self clickWithHandleTask:@"1"];
}

// 同意
- (void)onclickWithrefuse {
    [self clickWithHandleTask:@"2"];
}

- (void)clickWithHandleTask:(NSString *)accept {
    
    UserManager *info = [UserManager shared];
    NSDictionary *param = @{@"supervisor":info.userId ?: @"",
                            @"supervisorName":info.nickname ?: @"",
                            @"supervisorIcon":info.icon ?: @"",
                            @"taskId":self.model.taskId ?: @"",
                            @"creator":self.model.nickname ?: @"",
                            @"creatorId":self.model.creator ?: @"",
                            @"accept":accept ?: @"2",};
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(grabOrderViewCell:hostUrl:indexPath:)]) {
        [self.delegate grabOrderViewCell:param hostUrl:@"adminHandleTask" indexPath:self.path];
    }
}

- (void)setModel:(WhipM *)model {
    _model = model;
    
    [self.themeV setImageWithURL:[NSURL URLWithString:model.themeIcon] placeholderImage:[UIImage imageNamed:@"zaoqi"]];
    self.themeL.text = model.themeName ?: @"";
    CGSize themeLWidth = [self.themeL.text sizeWithAttributes:@{NSFontAttributeName:self.themeL.font}];
    [self.themeL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MIN([Define screenWidth]-134.0, floorf(themeLWidth.width)+1.0));
    }];
    
    [self.headV setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[Define kDefaultImageHead]];
    
    self.subTitle.text = [NSString stringWithFormat:@"开始:%@/结束:%@",model.startDate,model.endDate];
    self.guaranteeL.text = [NSString stringWithFormat:@"自由服务费：%.2f元",model.guarantee];
  
    self.contentL.text = model.plan;
    
}

@end
