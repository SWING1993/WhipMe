//
//  DDOldAddressCell.h
//  DDExpressClient
//
//  Created by Jadyn on 16/3/4.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDAddressDetail.h"

@interface DDAddressCell : UITableViewCell
/**
 *  头视图
 */
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
/**
 *  地址数据模型
 */
@property (strong, nonatomic) DDAddressDetail *addressDetail;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
