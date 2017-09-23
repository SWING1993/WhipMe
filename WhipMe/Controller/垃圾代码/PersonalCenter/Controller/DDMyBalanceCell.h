//
//  DDMyBalanceCell.h
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/18.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMyBalance.h"


/**
 *  我的余额
 */
@interface DDMyBalanceCell : UITableViewCell

- (void)loadMyBalanceCellWithBalance:(DDMyBalance *)balance;

@end
