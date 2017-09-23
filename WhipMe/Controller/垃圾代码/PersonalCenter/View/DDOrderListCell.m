//
//  DDOrderListCell.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDOrderListCell.h"
#import "DDOrderList.h"
#import "UIImageView+WebCache.h"
#import "CustomStringUtils.h"
#import "Constant.h"
#import "NSDate+DateHelper.h"

@interface DDOrderListCell ()
/** 公司logo */
@property (weak, nonatomic) IBOutlet UIImageView *companyIconImage;
/** 公司名称标签 */
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
/** 目标姓名标签 */
@property (weak, nonatomic) IBOutlet UILabel *targetNameLabel;
/** 目标地址标签 */
@property (weak, nonatomic) IBOutlet UILabel *targetAddressLabel;
/** 自己地址标签 */
@property (weak, nonatomic) IBOutlet UILabel *selfAddressLabel;
/** 快递日期标签 */
@property (weak, nonatomic) IBOutlet UILabel *expressDateLabel;
/** 快递状态图 */
@property (weak, nonatomic) IBOutlet UIImageView *expressStatusImageView;

@end

@implementation DDOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    
    return self;
}

/**
    订单列表数据的setter方法
 */
- (void)setOrderList:(DDOrderList *)orderList
{
    _orderList = orderList;
    
    if (![CustomStringUtils isBlankString:orderList.companyIcon]) {
        [self.companyIconImage sd_setImageWithURL:[NSURL URLWithString:orderList.companyIcon] placeholderImage:[UIImage imageNamed:KClientIcon48]];
    } else {
        [self.companyIconImage setImage:[UIImage imageNamed:KClientIcon48]];
    }
    
    self.companyNameLabel.text = [CustomStringUtils isBlankString:orderList.companyName] ? @"" : orderList.companyName;
    
    self.targetNameLabel.text = [CustomStringUtils isBlankString:orderList.targetname] ? @"" : [NSString stringWithFormat:@"收件人：%@",orderList.targetname];
    
    self.targetAddressLabel.text = [CustomStringUtils isBlankString:orderList.targetAddress] ? @"" : orderList.targetAddress;
    
    if (![CustomStringUtils isBlankString:orderList.selfAddress]) {
        self.selfAddressLabel.text = orderList.selfAddress;
    }
    
    if (![CustomStringUtils isBlankString:orderList.expressDate]) {
        long long time_number = [orderList.expressDate longLongValue]/1000;
        NSDate *tempDate = [[NSDate alloc] initWithTimeIntervalSince1970:time_number];
        NSString *tempTime = [tempDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        
        [self.expressDateLabel setText:tempTime ?: @""];
    } else {
        [self.expressDateLabel setText:@""];
    }
    
    if (orderList.expressStatus) {
        self.expressStatusImageView.image = [UIImage imageNamed:[self statusWithString:orderList.expressStatus]];
    }
}

- (NSString *)statusWithString:(NSInteger)index
{
    if (index == 1) {
        return @"待取件";
    } else if (index == 2) {
        return @"待付款";
    } else {
        return @"已完成";
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.expressStatusImageView.contentMode = UIViewContentModeCenter;
}

- (NSString *)stringByCustomUtils:(NSString *)string
{
    return string;
}


@end
