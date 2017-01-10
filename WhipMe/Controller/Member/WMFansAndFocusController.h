//
//  WMFansAndFocusController.h
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WMFansAndFocusStyle) {
    WMFansAndFocusStyleFans = 0,
    WMFansAndFocusStyleFocus,
};

@interface WMFansAndFocusController : UIViewController

@property (nonatomic, assign) WMFansAndFocusStyle controlStyle;

- (instancetype)initWithStyle:(WMFansAndFocusStyle)style;

@end
