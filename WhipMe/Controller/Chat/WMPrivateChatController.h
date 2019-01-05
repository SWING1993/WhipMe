//
//  WMPrivateChatController.h
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMPrivateChatController : UINavigationController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray<UIViewController *> *viewControllerArray;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UISegmentedControl *navigationView;
@property (nonatomic, strong, readwrite) NSArray<NSString *> *buttonText;

@end
