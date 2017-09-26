//
//  NSBundle+AppIcon.h
//  DDExpressClient
//
//  Created by yangg on 16/4/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (AppIcon)

- (NSString *)appIconPath;
- (UIImage *)appIcon;

@end
