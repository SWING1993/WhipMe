//
//  DDMyWalletCell.m
//  DDExpressClient
//
//  Created by yoga on 16/5/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDMyWalletCell.h"
#import "Constant.h"

@interface DDMyWalletCell()
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIButton *rightArrow;
@end


@implementation DDMyWalletCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}


- (void)initViews
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = DDRGBColor(51, 51, 51);
    label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:label];
    self.headLabel = label;
    
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.textColor = DDRGBColor(32, 198, 122);
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:rightLabel];
    self.rightLabel = rightLabel;
    
    UIButton *rightArrow = [[UIButton alloc]init];
    rightArrow.userInteractionEnabled = NO;
    [rightArrow setImage:[UIImage imageNamed:@"AddressArrow"] forState:UIControlStateNormal];
    rightArrow.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:rightArrow];
    self.rightArrow = rightArrow;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.headLabel setFrame:CGRectMake(15, 0, 100, 44)];
    [self.rightLabel setFrame:CGRectMake(150, 0, DDSCreenBounds.size.width - 150 - 35, 44)];
    [self.rightArrow setFrame:CGRectMake(DDSCreenBounds.size.width - 35, 7, 30, 30)];
}


- (void)setWalletCoin:(DDWalletCoin *)walletCoin
{
    _walletCoin = walletCoin;
    if (self.isCouponCell == NO) {
        self.rightLabel.text = [NSString stringWithFormat:@"%ld 元",(long)walletCoin.balanceNum];
        NSRange rangeSS = [self.rightLabel.text rangeOfString:@"元"];
        NSMutableAttributedString *attRemin = [[NSMutableAttributedString alloc] initWithString:self.rightLabel.text];
        [attRemin addAttribute:NSForegroundColorAttributeName  value:DDRGBAColor(153, 153, 153, 1) range:rangeSS];
        [self.rightLabel setAttributedText:attRemin];
    }else {
        self.rightLabel.text = [NSString stringWithFormat:@"%ld 张",(long)walletCoin.couponCount];
        NSRange rangeSS = [self.rightLabel.text rangeOfString:@"张"];
        NSMutableAttributedString *attRemin = [[NSMutableAttributedString alloc] initWithString:self.rightLabel.text];
        [attRemin addAttribute:NSForegroundColorAttributeName  value:DDRGBAColor(153, 153, 153, 1) range:rangeSS];
        [self.rightLabel setAttributedText:attRemin];
    }
    
}





@end
