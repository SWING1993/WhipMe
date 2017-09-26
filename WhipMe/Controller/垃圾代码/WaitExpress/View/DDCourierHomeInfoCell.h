//
//  DDCourierHomeInfoCell.h
//  DDExpressClient
//
//  Created by Jadyn on 16/3/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCourierDetail.h"
@interface DDCourierHomeInfoCell : UITableViewCell

/**
 *  快递员信息模型
 */
@property (nonatomic, strong)DDCourierDetail *courierModel;

@end
