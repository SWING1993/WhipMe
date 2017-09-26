//
//  LSNavigationController.h
//  TS
//
//  Created by Steven.liu on 16-4-11.
//  Copyright (c) 2016年 Steven.liu All rights reserved. MIT
//  WELCOME TO MY BLOG  http://www.coneboy.com
//

#import <UIKit/UIKit.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

// 背景视图起始frame.x
#define startX -200;


@interface LSNavigationController : UINavigationController
{
    CGFloat startBackViewX;
}

// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;

@end
