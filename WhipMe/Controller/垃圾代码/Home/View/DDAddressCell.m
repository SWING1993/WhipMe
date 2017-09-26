//
//  DDAddressCell.m
//  DDExpressClient
//
//  Created by Jadyn on 16/3/4.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDAddressCell.h"
#import "Constant.h"
@interface DDAddressCell()
/**
 *  地址名称
 */
@property (strong, nonatomic) IBOutlet UILabel *addressNameLabel;
/**
 *  详细地址信息
 */
@property (strong, nonatomic) IBOutlet UILabel *addressContentLabel;


@end



@implementation DDAddressCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"DDAddressCell" owner:self options:nil] lastObject];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, BORDER_COLOR.CGColor); CGContextStrokeRect(context, CGRectMake(15, rect.size.height, rect.size.width - 15, 1));
}




/**
 *  setter方法
 *
 *  @param AddressDetail 传入数据模型.
 */
-(void)setAddressDetail:(DDAddressDetail *)addressDetail
{
    _addressDetail = addressDetail;
    self.addressNameLabel.text = addressDetail.addressName;
    self.addressContentLabel.text = addressDetail.localDetailAddress;
}

@end
