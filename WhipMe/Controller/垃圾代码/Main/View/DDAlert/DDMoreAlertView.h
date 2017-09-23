//
//  DDMoreAlertView.h
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDMoreAlertView;
@protocol DDMoreAlertViewDelegate <NSObject>
@optional
- (void)ddMoreAlertView:(DDMoreAlertView *)moreView AtIndex:(NSInteger)index;

@end

@interface DDMoreAlertView : UIView

@property (nonatomic, assign) id<DDMoreAlertViewDelegate> delegate;

- (instancetype)initWithTitles:(NSArray *)titles delegate:(id<DDMoreAlertViewDelegate>)delegate top:(float)topFloat center:(float)centerFloat;

- (instancetype)initWithImageArray:(NSArray *)titles delegate:(id<DDMoreAlertViewDelegate>)delegate top:(float)topFloat center:(float)centerFloat;

- (void)show;

@end
