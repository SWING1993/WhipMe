//
//  GrabOrderViewCell.h
//  WhipMe
//
//  Created by youye on 17/2/20.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrabOrderViewCellDelgate <NSObject>
@optional
- (void)grabOrderViewCell:(NSDictionary *)param hostUrl:(NSString *)hostUrl indexPath:(NSIndexPath *)path;

@end

@interface GrabOrderViewCell : UITableViewCell

@property (nonatomic, strong) WhipM *model;
@property (nonatomic, strong) NSIndexPath *path;
@property (nonatomic, weak  ) id<GrabOrderViewCellDelgate> delegate;

+ (CGFloat)cellHeight:(NSString *)content;

@end
