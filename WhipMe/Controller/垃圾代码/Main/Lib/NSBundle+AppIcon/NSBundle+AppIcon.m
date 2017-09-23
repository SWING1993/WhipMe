//
//  NSBundle+AppIcon.m
//  DDExpressClient
//
//  Created by yangg on 16/4/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "NSBundle+AppIcon.h"

@implementation NSBundle (AppIcon)

- (NSString *)appIconPath
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    return icon;
}

- (UIImage *)appIcon
{
    UIImage *appIcon = [UIImage imageNamed:[self appIconPath]] ;
    return appIcon;
}

@end
