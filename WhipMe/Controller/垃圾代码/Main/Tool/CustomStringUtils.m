//
//  CustomStringUtils.m
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "CustomStringUtils.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <CommonCrypto/CommonDigest.h>

@implementation CustomStringUtils

//判断string是否为空
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
    
    return NO;
}

//获取设备型号
+ (NSString *)platform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)platformString
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (UK+Europe+Asis+China)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (UK+Europe+Asis+China)";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

//去除HTML标签
+ (NSString *)stripHTML:(NSString *)htmlStr
{
    if ([CustomStringUtils isBlankString:htmlStr]) {
        return @"";
    }
    NSRange r;
    NSString *s = htmlStr;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

//统计字数
+ (int)countWord:(NSString*)s
{
    int i, n=[s length], l=0, a=0, b=0;
    unichar c;
    for (i=0; i<n; i++) {
        c = [s characterAtIndex:i];
        if (isblank(c)) {
            b++;
        } else if(isascii(c)) {
            a++;
        } else {
            l++;
        }
    }
    if (a==0 && l==0) return 0;
    return l + (int)ceilf((float)(a+b)/2.0);
}

////分割字符串
//+ (NSArray *)splitTextWithOriginText:(NSString *)text width:(CGFloat)width font:(UIFont *)font maxLineNum:(NSUInteger)maxLineNum
//{
//    NSUInteger textLength = [text length];
//    
//    int lineNum = 0;
//    NSString *line = @"";
//    
//    NSMutableArray *textArray = [NSMutableArray array];
//    for (int location = 0; location < textLength; location++) {
//        
//        NSRange textRange = NSMakeRange(location, 1);
//        NSString *character = [text substringWithRange:textRange];
//        
//        CGFloat stringWidth = [CustomSizeUtils simpleSizeWithStr:[line stringByAppendingFormat:@"%@", character] font:font].width;
//        
//        if (![character isEqualToString:@"\n"]) {
//            if (stringWidth <= width) {
//                line = [line stringByAppendingFormat:@"%@", character];
//            } else {
//                [textArray addObject:line];
//                lineNum++;
//                line = character;
//            }
//        } else {
//            line = [line stringByAppendingFormat:@"%@", character];
//            [textArray addObject:line];
//            lineNum++;
//            line = @"";
//        }
//        if (maxLineNum > 0 && lineNum >= maxLineNum) {
//            break;
//        }
//        if (location == textLength - 1) {
//            [textArray addObject:line];
//        }
//    }
//    return textArray;
//}

//获取截取以后的字符a
+ (NSString *)getClipedTextWithOriginText:(NSString *)originText width:(CGFloat)width font:(UIFont *)font maxLineNum:(NSUInteger)maxLineNum
{
    if ([CustomStringUtils isBlankString:originText]) {
        return originText;
    }
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *trippedContent = [regex stringByReplacingMatchesInString:originText options:NSMatchingReportCompletion range:NSMakeRange(0, [originText length]) withTemplate:@""];
    NSArray *textArray = [self splitTextWithOriginText:trippedContent width:width font:font maxLineNum:maxLineNum];
    NSString *clipedText;
    if ([textArray count] > 0) {
        clipedText = [textArray count] > maxLineNum ? [[textArray subarrayWithRange:NSMakeRange(0, maxLineNum)] componentsJoinedByString:@""] : [textArray componentsJoinedByString:@""];
    } else {
        clipedText = originText;
    }
    
    return clipedText;
}

+ (NSString *)stripSpace:(NSString *)originString
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *trippedContent = [regex stringByReplacingMatchesInString:originString options:NSMatchingReportCompletion range:NSMakeRange(0, [originString length]) withTemplate:@""];
    return trippedContent;
}

+ (UITextView *)setLineHeightForTextView:(UITextView *)currentTextView lineHeight:(CGFloat)lineHeight font:(CGFloat)fontSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineHeight;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
    currentTextView.attributedText = [[NSAttributedString alloc] initWithString:currentTextView.text attributes:attributes];
    return currentTextView;
}

+ (NSString *)md5String:(NSString *)str
{
    if ([self isBlankString:str]) {
        return nil;
    }
    
    const char *value = [str UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

@end
