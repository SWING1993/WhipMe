//
//  DDAlertView.h
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDAlertView;
@protocol DDAlertViewDelegate <NSObject>
@optional
- (void)ddAlertView:(DDAlertView *)alertView buttonIndex:(NSInteger)hvState;

@end

@interface DDAlertView : UIView

@property (nonatomic, strong) UIFont *font_Title;
@property (nonatomic, strong) UIColor *color_Title;

@property (nonatomic, assign) id<DDAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)objTitle
           delegate:(id<DDAlertViewDelegate>)objDelegate
        cancelTitle:(NSString *)cancelTitle
          nextTitle:(NSString *)nextTitle;

- (void)show;
@end
