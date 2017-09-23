//
//  AppPageViewController.h
//  YouShaQi
//
//  Created by JC_CP3 on 14-4-8.
//  Copyright (c) 2014年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppPageViewDelegate <NSObject>

- (void)AppPageViewDidDismissed;

@end

@interface AppPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, weak) id<AppPageViewDelegate> appPageViewDelegate;
@end
