//
//  NSObject+Commom.h
//  BlackCard
//
//  Created by Song on 16/8/4.
//  Copyright © 2016年 冒险元素. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Commom)

#pragma mark Tip M

- (void)showTipStr:(NSString *)tipStr;
- (MBProgressHUD *)showLoadingTipStr:(NSString *)tipStr;

@end
