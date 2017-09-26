//
//  DDItemTypeView.h
//  DDExpressClient
//
//  Created by SongGang on 3/11/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDItemTypeViewDelegate <NSObject>
@optional
- (void)itemTypeCancelAction;
- (void)itemTypeOKAction:(NSString *)typeString;

@end

@interface DDItemTypeView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<DDItemTypeViewDelegate> delegate;
@property (nonatomic, strong) NSArray *itemTypeArray;

- (void)showSelectedType:(NSString *)type;

@end
