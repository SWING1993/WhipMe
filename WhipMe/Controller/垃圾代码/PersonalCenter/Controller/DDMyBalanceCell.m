//
//  DDMyBalanceCell.m
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/18.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDMyBalanceCell.h"
#import "Constant.h"
#import "CustomStringUtils.h"

@interface DDMyBalanceCell ()
{
    UILabel *titleLabel;
    UILabel *descLabel;
    UILabel *moneyLabel;
    UILabel *timeLabel;
}

@end

@implementation DDMyBalanceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(15, 15, 150, 15);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:titleLabel];
        
        descLabel = [[UILabel alloc] init];
        descLabel.frame = CGRectMake(15, 40, 150, 13);
        descLabel.textAlignment = NSTextAlignmentLeft;
        [descLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:descLabel];
        
        moneyLabel = [[UILabel alloc] init];
        moneyLabel.frame = CGRectMake(MainScreenWidth - 115, 15, 100, 15);
        moneyLabel.textAlignment = NSTextAlignmentRight;
        [moneyLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:moneyLabel];
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.frame = CGRectMake(MainScreenWidth - 115, 40, 100, 13);
        [timeLabel setTextColor:TIME_COLOR];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:timeLabel];
    }
    
    return self;
}

- (void)loadMyBalanceCellWithBalance:(DDMyBalance *)balance
{
    if (![CustomStringUtils isBlankString:balance.balanceTitle]) {
        titleLabel.text = balance.balanceTitle;
    }
    
    if (![CustomStringUtils isBlankString:balance.balanceDesc]) {
        descLabel.text = balance.balanceDesc;
    }
    
    if (balance.balanceType == 1) {
        moneyLabel.text = [NSString stringWithFormat:@"+%.02f", balance.balanceNum];
        [moneyLabel setTextColor:DDGreen_Color];
    } else {
        moneyLabel.text = [NSString stringWithFormat:@"-%.02f", balance.balanceNum];
        [moneyLabel setTextColor:DDRed_Color];
    }
    
    if (![CustomStringUtils isBlankString:balance.balanceTime]) {
        timeLabel.text = balance.balanceTime;
    }
}



@end
