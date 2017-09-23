//
//  DDMyWalletCell.h
//  DDExpressClient
//
//  Created by yoga on 16/5/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDWalletCoin.h"
@interface DDMyWalletCell : UITableViewCell

@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, strong) DDWalletCoin *walletCoin;
/**  判断是余额还是优惠券  */
@property (nonatomic, assign) BOOL isCouponCell;
@end
