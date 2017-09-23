//
//  DDItemWeightView.h
//  DDExpressClient
//
//  Created by SongGang on 3/1/16.
//  Copyright © 2016 NS. All rights reserved.
//
/**
    物品重量
 */
#import <UIKit/UIKit.h>

@protocol DDItemWeightViewDelegate <NSObject>
@optional
- (void)itemWeightCancelAction;
- (void)itemWeightOKAction:(NSString *)weightString;

@end

@interface DDItemWeightView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<DDItemWeightViewDelegate> delegate;

- (void)showCurrentWeight:(NSString *)currentWeight;

@end
