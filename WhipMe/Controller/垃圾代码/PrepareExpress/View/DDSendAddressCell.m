//
//  DDSendAddressCellView.m
//  DDExpressClient
//
//  Created by SongGang on 2/25/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDSendAddressCell.h"
#import "Constant.h"
@class DDAddressDetail;

@interface DDSendAddressCell()
/** 地址 */
@property (nonatomic,strong) UILabel  *addressLabel;
/** 名字 */
@property (nonatomic,strong) UILabel *nickLabel;
/** 电话 */
@property (nonatomic,strong) UILabel *phoneLabel;
/** 编辑按钮 */
@property (nonatomic,strong) UIImageView *editIcon;
/** 标签按钮 */
@property (nonatomic,strong) UIButton * signButton;
@end

@implementation DDSendAddressCell
@synthesize addressDetail = _addressDetail;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

/**
    初始化界面
 */
-(void)initView
{
    UILabel *adressLabel = [[UILabel alloc] init];
    adressLabel.textColor = DDRGBColor(153, 153, 153);
    adressLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:adressLabel];
    self.addressLabel = adressLabel;
  
    UILabel *namLabel = [[UILabel alloc] init];
    namLabel.textColor = DDRGBColor(51, 51, 51);
    namLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:namLabel];
    self.nickLabel = namLabel;

    UILabel *phonLabel = [[UILabel alloc] init];
    phonLabel.font = [UIFont systemFontOfSize:14];
    phonLabel.textColor = DDRGBColor(51, 51, 51);
    [self addSubview:phonLabel];
    self.phoneLabel = phonLabel;
    
    UIButton * button = [[UIButton alloc] init];
    button.userInteractionEnabled = NO;
    [self addSubview:button];
    self.signButton = button;
}

/**
    界面布局
 */
-(void)layoutSubviews
{

    [super layoutSubviews];
    CGSize nameSize = [self sizeOfString:self.nickLabel.text withFont:self.nickLabel.font];
//    CGSize addressSize = [self sizeOfString:self.addressLabel.text withFont:self.addressLabel.font];
    CGSize phoneSize = [self sizeOfString:self.phoneLabel.text withFont:self.phoneLabel.font];

    self.nickLabel.x = 15;
    self.nickLabel.y = 20;
    self.nickLabel.width = nameSize.width < (DDSCreenBounds.size.width-150) ? nameSize.width : DDSCreenBounds.size.width-150;
    self.nickLabel.height = 15;
    
    self.phoneLabel.x = 15 + self.nickLabel.width + 7;
    self.phoneLabel.y = self.nickLabel.y;
    self.phoneLabel.width = phoneSize.width < (DDSCreenBounds.size.width-150) ? phoneSize.width : (DDSCreenBounds.size.width-150);
    self.phoneLabel.height = 15;
    
    if (_addressDetail.sign.length != 0) {
        CGSize signSize = [self sizeOfString:_addressDetail.sign withFont:[UIFont systemFontOfSize:10]];
        self.signButton.x = self.phoneLabel.right + 7;
        self.signButton.y = self.nickLabel.y;
        self.signButton.width = signSize.width + 22;
        self.signButton.height = 15;
        self.signButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.signButton setTitleColor:DDRGBColor(32, 198, 122) forState:UIControlStateNormal];
        [self.signButton.layer setCornerRadius:self.signButton.height/2];
        [self.signButton.layer setBorderWidth:0.5];
        self.signButton.layer.borderColor = DDRGBColor(32, 198, 122).CGColor;
    }
    self.addressLabel.x = 15;
    self.addressLabel.y = self.nickLabel.bottom + 4;
    self.addressLabel.width = MainScreenWidth - 30;
    self.addressLabel.height = 15;
    self.addressLabel.textColor = DDRGBColor(153, 153, 153);
    self.addressLabel.font = [UIFont systemFontOfSize:14];
}

/**
    addressDetail赋值
 */
- (void)setAddressDetail:(DDAddressDetail *)addressDetail
{
    _addressDetail = addressDetail;
    
    NSString *needShowSelfAddress = @"";
    if ([addressDetail.contentAddress rangeOfString:@"/"].length > 0) {
        needShowSelfAddress = [addressDetail.contentAddress stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@", needShowSelfAddress, addressDetail.supplementAddress];
    self.nickLabel.text = addressDetail.nick;
    self.phoneLabel.text = addressDetail.phone;
    if (addressDetail.sign.length == 0) {
        [self.signButton setHidden:YES];
    }else{
        [self.signButton setHidden:NO];
        [self.signButton setTitle:addressDetail.sign forState:UIControlStateNormal];
    }
    
}

/**
    计算字符串的size
 */
- (CGSize) sizeOfString : (NSString *) string withFont: (UIFont *) fnt
{
    CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    return size;
}
@end
