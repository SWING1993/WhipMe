//
//  UIBarButtonItem+Extension.m
//  20151228LSWeibo
//
//  Created by Steven.Liu on 15/12/29.
//  Copyright © 2015年 Steven.Liu. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *) initBarItemWithTarget:(id)target andNorImage:(NSString *)norImage andHilightImg:(NSString *)hilightImage andAction:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setBackgroundImage:[UIImage imageNamed:norImage] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:hilightImage] forState:(UIControlStateHighlighted)];
    
    btn.frame = CGRectMake(0, 0, btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
