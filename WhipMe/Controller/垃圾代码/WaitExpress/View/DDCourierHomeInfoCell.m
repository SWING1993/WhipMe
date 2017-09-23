//
//  DDCourierHomeInfoCell.m
//  DDExpressClient
//
//  Created by Jadyn on 16/3/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierHomeInfoCell.h"
@interface DDCourierHomeInfoCell()


@property (strong, nonatomic) IBOutlet UILabel *finishOrderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishOrderTimesLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyRankingNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyRankingTimesLabel;

@end
@implementation DDCourierHomeInfoCell
- (void)setCourierModel:(DDCourierDetail *)courierModel
{
    _courierModel = courierModel;
    self.finishOrderTimesLabel.text = courierModel.finishedOrderNumber;
}
@end
