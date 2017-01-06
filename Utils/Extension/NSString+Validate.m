//
//  NSString+Validate.m
//  WhipMe
//
//  Created by yangg on 2016/10/2.
//  Copyright © 2016年 -. All rights reserved.
//

#import "NSString+Validate.h"

@implementation NSString (Validate)

    
+ (BOOL)isValidateFixed:(NSString *)fixed
    {
        NSString *phoneRegex = @"([0-9]{3,4})-([0-9]{7,8})";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:fixed];
    }
    
+ (BOOL)isValidateMobile:(NSString *)mobile {
    NSString *phoneRegex = @"^1(3|4|5｜7|8)\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
    
+ (BOOL)isValidateMoney:(NSString *)money {
    NSString *moneyRegex = @"^[0-9]+(.[0-9]{2})?$";
    
    NSPredicate *moneyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moneyRegex];
    return [moneyTest evaluateWithObject:money];
}
    
+ (NSString *)generateUuidString {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    
    return uuidString;
}

+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

@end
