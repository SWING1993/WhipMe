//
//  NSObject+Commom.m
//  BlackCard
//
//  Created by Song on 16/8/4.
//  Copyright © 2016年 冒险元素. All rights reserved.
//

#import "NSObject+Commom.h"
#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define KColorBlack         HKRGBColor(47.0, 49.0, 61.0)

static NSTimeInterval const timeoutShow = 2.5;

@implementation NSObject (Commom)

- (void)showTipStr:(NSString *)tipStr {
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.detailsLabel.textColor = [UIColor whiteColor];
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabel.text = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:timeoutShow];
    }
}


- (MBProgressHUD *)showLoadingTipStr:(NSString *)tipStr {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
//    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
    hud.detailsLabel.text = tipStr;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
//    [hud hideAnimated:YES afterDelay:timeoutShow];
    return hud;
}

@end
