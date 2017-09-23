//
//  DDParcelTableViewCell.h
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

/** 设置tableViewCell行高 */
#define KMyExpressCellHeight 115.0f


#import <UIKit/UIKit.h>
#import "DDMyExpress.h"

@interface DDParcelTableViewCell : UITableViewCell

/** cell的数据Model */
@property (nonatomic, strong) DDMyExpress *cellForMyExpress;

//@property (nonatomic, strong) NSDictionary *cellForParcel;
@end
