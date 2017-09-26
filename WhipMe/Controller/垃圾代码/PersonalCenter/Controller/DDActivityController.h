//
//  DDActivityController.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/5/5.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDRootViewController.h"

@class DDActivityController, DDActivity;
@protocol DDActivityControllerDelegat <NSObject>

@optional
- (void)activityController:(DDActivityController *)activityController selectCellWithActivity:(DDActivity *)activity;

@end

@interface DDActivityController : DDRootViewController

@property (nonatomic,weak) id<DDActivityControllerDelegat> delegate;

@end
