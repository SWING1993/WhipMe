//
//  DDTargetAddressEditView.h
//  DDExpressClient
//
//  Created by SongGang on 2/25/16.
//  Copyright © 2016 NS. All rights reserved.
//

/**
    编辑收件人地址
 */

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@protocol DDTargetAddressEditViewDelegate <NSObject>
@optional
- (void)addToAddressBook;
- (void)createDistrictSelectPickerViewWithTitle:(NSString *)title;

@end

@class DDAddressDetail;
@interface DDTargetAddressEditView : UIView

/** 第二个地址 */
@property (strong, nonatomic) UIButton *btnSecondAddr;
@property (nonatomic, strong) HPGrowingTextView *textSecondAddr;

@property (nonatomic, strong) DDAddressDetail *addressDetail;
@property (nonatomic, assign) id<DDTargetAddressEditViewDelegate> delegate;

@end
