//
//  DDTakeTimeView.h
//  DDExpressClient
//
//  Created by SongGang on 3/1/16.
//  Copyright © 2016 NS. All rights reserved.
//

/**
    取件时间
 */

#import <UIKit/UIKit.h>

@protocol DDTakeTimeViewDelegate <NSObject>
@optional
- (void)takeTimeCancelAction;
- (void)taketimeOKAction: (NSString *)timeString;

@end

@interface DDTakeTimeView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<DDTakeTimeViewDelegate> delegate;

- (void)showCurrentTime:(NSString *)currentTime;

@end
