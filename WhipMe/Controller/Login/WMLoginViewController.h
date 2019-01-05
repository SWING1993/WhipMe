//
//  WMLoginViewController.h
//  WhipMe
//
//  Created by anve on 17/1/25.
//  Copyright © 2017年 -. All rights reserved.
//  登录页面

#import <UIKit/UIKit.h>

@interface WMLoginViewController : UIViewController

- (instancetype)initWithUsers:(NSMutableArray<UserManager *> *)users;

@end
