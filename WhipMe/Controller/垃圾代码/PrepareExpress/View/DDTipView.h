//
//  DDTipView.h
//  DDExpressClient
//
//  Created by SongGang on 3/10/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDTipViewDelegate <NSObject>
@optional
- (void)tipCancelAction;
- (void)tipOKAction: (NSString *)tipString;

@end
@interface DDTipView:UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, weak) id <DDTipViewDelegate> delegate;

- (void)showSelectedTip:(NSString *)tip;

@end
