//
//  DDCourierHomeIdCell.m
//  DDExpressClient
//
//  Created by Jadyn on 16/3/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierHomeIdCell.h"
@interface DDCourierHomeIdCell ()
/**
 *  快递员姓名label
 */
@property (strong, nonatomic) IBOutlet UILabel *courierNameLabel;
/**
 *  快递员所属公司label
 */
@property (strong, nonatomic) IBOutlet UILabel *courierCompanyLabel;
/**
 *  快递员姓名
 */
@property (strong, nonatomic) IBOutlet UILabel *idNameLabel;
/**
 *  快递员所属公司
 */
@property (strong, nonatomic) IBOutlet UILabel *idNumberLabel;
/**
 *  右箭头
 */
@property (strong, nonatomic) IBOutlet UIView *rightBackView;
/**
 *  快递员评星图
 */
@property (strong, nonatomic) IBOutlet UIImageView *starImageView;



@end



@implementation DDCourierHomeIdCell

- (void)layoutSubviews
{

}


- (void)setCourierModel:(DDCourierDetail *)courierModel
{
    _courierModel = courierModel;
    self.idNameLabel.text = courierModel.courierName;
    self.idNumberLabel.text = courierModel.courierIdentityID;
    self.starImageView.image = [UIImage imageNamed:courierModel.courierStar];
    
}

@end
