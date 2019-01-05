//
//  NSString+Validate.h
//  WhipMe
//
//  Created by yangg on 2016/10/2.
//  Copyright © 2016年 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)
    
+ (BOOL)isValidateFixed:(NSString *)fixed;
    
+ (BOOL)isValidateMobile:(NSString *)mobile;
    
+ (BOOL)isValidateMoney:(NSString *)money;
    
+ (NSString *)generateUuidString;

/**  判断string是否为空 */
+ (BOOL)isBlankString:(NSString *)string;

- (NSString *)stringByTrimingWhitespace;

- (NSUInteger)numberOfLines;

@end
