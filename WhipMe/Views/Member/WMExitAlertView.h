//
//  WMExitAlertView.h
//  WhipMe
//
//  Created by anve on 17/1/24.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMExitAlertViewDelegate;

@interface WMExitAlertView : UIView

@property (nonatomic, weak) id<WMExitAlertViewDelegate> delegate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *confirmTitle;

- (instancetype)initWithTitle:(NSString *)objTitle delegate:(id<WMExitAlertViewDelegate>)objDelegate cancel:(NSString *)cancelT confirm:(NSString *)confirmT;

- (void)show;

@end

@protocol WMExitAlertViewDelegate <NSObject>
@optional
- (void)exitAlertView:(WMExitAlertView *)alertView buttonIndex:(NSInteger)hvState;

@end
