//
//  DDSendAddressCell.h
//  DDExpressClient
//
//  Created by SongGang on 2/25/16.
//  Copyright © 2016 NS. All rights reserved.
//

/**
    寄件人地址 cell
 */
#import <UIKit/UIKit.h>
#import "DDAddressDetail.h"
@interface DDSendAddressCell : UITableViewCell
@property (nonatomic,strong) DDAddressDetail * addressDetail;
@end
