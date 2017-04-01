//
//  BlackListManagerViewCell.h
//  WhipMe
//
//  Created by youye on 17/4/1.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansAndFocusModel.h"


@protocol BlackListManagerViewCellDelegate;

@interface BlackListManagerViewCell : UITableViewCell

@property (nonatomic, strong) UIView *viewCurrent, *lineView;
@property (nonatomic, strong) UIImageView *imageIcon;
@property (nonatomic, strong) UILabel *lblTitle, *lblDescribe;
@property (nonatomic, strong) UIButton *btnCheck;

@property (nonatomic, strong) FansAndFocusModel *model;
@property (nonatomic, weak  ) id<BlackListManagerViewCellDelegate> delegate;

+ (NSString *)cellReuseIdentifier;
+ (CGFloat)cellHeight;

@end

@protocol BlackListManagerViewCellDelegate <NSObject>
@optional
- (void)blackListManagerViewCellWithCheck:(BlackListManagerViewCell *)cell;

@end
