//
//  DDPayCostView.h
//  DDExpressClient
//
//  Created by SongGang on 3/28/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@class DDRemindToPayView;
@protocol DDRemindToPayViewDelegate <NSObject>

- (void) remindToPayView:(DDRemindToPayView *)remindToPayView  didClickPayBtn:(NSInteger)unPayCount;

@end

@interface DDRemindToPayView : UIView

@property(nonatomic,strong) id<DDRemindToPayViewDelegate> delegate;

@property (nonatomic,assign) NSInteger unPayCount;

@end
