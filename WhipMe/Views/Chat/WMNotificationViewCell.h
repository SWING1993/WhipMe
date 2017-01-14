//
//  WMNotificationViewCell.h
//  WhipMe
//
//  Created by anve on 17/1/14.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotificationModel;
@interface WMNotificationViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lblContent, *lblTitle, *lblDate;

@property (nonatomic, strong) NotificationModel *cellModel;

+ (CGFloat)cellHeight:(NSString *)content;

@end
