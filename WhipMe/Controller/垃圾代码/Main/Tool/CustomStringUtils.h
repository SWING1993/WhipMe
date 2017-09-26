//
//  CustomStringUtils.h
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomStringUtils : NSObject

//转换书列表title
+ (NSString *)changetoChinese:(NSString *)words;
//判断string是否为空
+ (BOOL)isBlankString:(NSString *)string;
+ (NSString *)platformString;

//去除HTML标签
+ (NSString *)stripHTML:(NSString *)htmlStr;
//统计字数
+ (int)countWord:(NSString*)s;

//分割字符串
+ (NSArray *)splitTextWithOriginText:(NSString *)text width:(CGFloat)width font:(UIFont *)font maxLineNum:(NSUInteger)maxLineNum;
//获取截取以后的字符a
+ (NSString *)getClipedTextWithOriginText:(NSString *)originText width:(CGFloat)width font:(UIFont *)font maxLineNum:(NSUInteger)maxLineNum;

//获取字体
+ (NSString *)getCustomFontName;
+ (NSString *)getCustomFontChineseName;

+ (UITextView *)setLineHeightForTextView:(UITextView *)currentTextView lineHeight:(CGFloat)lineHeight font:(CGFloat)fontSize;

+ (NSString *)stripSpace:(NSString *)originString;

//转换MD5
+ (NSString *)md5String:(NSString *)str;

@end
