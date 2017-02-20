//
//  WMMangerPageController.h
//  WhipMe
//
//  Created by youye on 17/2/20.
//  Copyright © 2017年 -. All rights reserved.
//  管理员登陆后展示

#import <UIKit/UIKit.h>

@interface WMMangerPageController : UINavigationController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray<UIViewController *> *viewControllerArray;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UISegmentedControl *navigationView;
@property (nonatomic, strong, readwrite) NSArray<NSString *> *buttonText;

@end
