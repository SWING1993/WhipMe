//
//  DDOrderListCell.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    订单列表 cell
 */

#import <UIKit/UIKit.h>
@class DDOrderList;
@interface DDOrderListCell : UITableViewCell

@property (nonatomic, strong) DDOrderList *orderList;

@end
