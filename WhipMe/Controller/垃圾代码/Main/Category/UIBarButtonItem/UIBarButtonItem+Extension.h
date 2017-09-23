//
//  UIBarButtonItem+Extension.h
//  20151228LSWeibo
//
//  Created by Steven.Liu on 15/12/29.
//  Copyright © 2015年 Steven.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *) initBarItemWithTarget:(id)target andNorImage:(NSString *)norImage andHilightImg:(NSString *)hilightImage andAction:(SEL)action;

@end
