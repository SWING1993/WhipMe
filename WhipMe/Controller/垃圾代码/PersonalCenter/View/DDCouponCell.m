//
//  DDCouponCell.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCouponCell.h"
#import "DDCoupons.h"
#import "Constant.h"
#import "DDLineView.h"

@interface DDCouponCell ()
/** 优惠券类别标签 */
@property (weak, nonatomic) IBOutlet UILabel *couponClassLabel;
/** 优惠券有效期标签 */
@property (weak, nonatomic) IBOutlet UILabel *couponValidLabel;
/** 优惠券用途标签 */
@property (weak, nonatomic) IBOutlet UILabel *couponUsedLabel;
/** 优惠券价值标签 */
@property (weak, nonatomic) IBOutlet UILabel *couponValueLabel;
/** 优惠券状态背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *couponStatusImage;
@property (strong, nonatomic) IBOutlet UIView *moneyBackView;

@end

@implementation DDCouponCell

/** 
    cell 类方法 
 */
+ (instancetype)couponCellWithTableView: (UITableView *)tableView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [self initItems];
}
/**
 *  布局
 */
- (void)initItems
{
    
    self.couponValueLabel.font = [UIFont systemFontOfSize:40];
    self.couponValueLabel.textColor = DDRGBAColor(32, 198, 122, 1);
    self.couponUsedLabel.font = [UIFont systemFontOfSize:12];
    self.couponUsedLabel.textColor = DDRGBAColor(153, 153, 153, 1);
    self.couponClassLabel.font = [UIFont systemFontOfSize:16];
    self.couponClassLabel.textColor = DDRGBAColor(51,51,51, 1);
    self.couponValidLabel.font = [UIFont systemFontOfSize:12];
    self.couponValidLabel.textColor = DDRGBAColor(153, 153, 153, 1);
    
    DDLineView *dottedLineView = [[DDLineView alloc] init];
    [dottedLineView setFrame:CGRectMake(15, -96, 1, 110)];
    dottedLineView.transform=CGAffineTransformMakeRotation(M_PI/2);
    //设置虚线
    [dottedLineView drawDashLineLength:4.0f lineSpacing:4.0f lineColor: DDRGBAColor(233, 233, 233, 1)];
    
    [self addSubview:dottedLineView];
    
}



/**
    优惠券setter方法
 */
-(void)setCoupon:(DDCoupons *)coupon
{
    _coupon = coupon;
    
    //对控件进行内容的填充
    self.couponClassLabel.text = coupon.couponName.length > 0 ? coupon.couponName : @"";
    self.couponValidLabel.text = coupon.couponValid.length == 13 ? [NSString stringWithFormat:@"有效期至 %@",[self setUpTime:coupon.couponValid]] : @"";
    self.couponUsedLabel.text = coupon.couponPurpose.length > 0 ? coupon.couponPurpose : @"可直接抵扣快递费";
    self.couponValueLabel.text = coupon.couponValue > 0 ? [NSString stringWithFormat:@"%ld元",(long)coupon.couponValue] : @"0元";
    NSRange rangeSS = [self.couponValueLabel.text rangeOfString:@"元"];
    NSMutableAttributedString *attRemin = [[NSMutableAttributedString alloc] initWithString:self.couponValueLabel.text];
    [attRemin addAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14], NSForegroundColorAttributeName : DDRGBAColor(32, 198, 122, 1)} range:rangeSS];
    [self.couponValueLabel setAttributedText:attRemin];
    if (coupon.couponUsed == 0 && coupon.couponExpire == 0) {
        self.couponStatusImage.image = [UIImage imageNamed:@"canUseCouponBg"];
    } else {
        self.couponStatusImage.image = [UIImage imageNamed:@"canNotUseCouponBg"];
        self.couponValueLabel.textColor = DDRGBAColor(188, 188, 188, 1);
        self.couponUsedLabel.textColor = DDRGBAColor(188, 188, 188, 1);
        self.couponClassLabel.textColor = DDRGBAColor(188, 188, 188, 1);
        self.couponValidLabel.textColor = DDRGBAColor(188, 188, 188, 1);
    }
}

/**
 *  处理时间
 */
- (NSString *)setUpTime:(NSString *)timestamp
{
    NSTimeInterval time=[timestamp doubleValue]/1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

@end
