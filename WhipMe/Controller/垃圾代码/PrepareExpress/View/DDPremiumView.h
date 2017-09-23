//
//  DDPremiumView.h
//  DDExpressClient
//
//  Created by SongGang on 3/10/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DDPremiumViewDelegate <NSObject>
@optional
- (void)premiumCancelAction;
- (void)premiumOKAction:(NSString *)premium;

@end

@interface DDPremiumView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id <DDPremiumViewDelegate> delegate;

@end
