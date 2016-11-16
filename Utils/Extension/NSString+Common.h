//
//  NSString+Common.h
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-31.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Common)
+ (NSString *)userAgentStr;

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;
- (NSString *)md5Str;
- (NSString*)sha1Str;
- (NSURL *)urlImageWithCodePathResize:(CGFloat)width crop:(BOOL)needCrop;
- (NSURL *)urlImageWithCodePathResizeToView:(UIView *)view;


+ (NSString *)handelRef:(NSString *)ref path:(NSString *)path;


- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte;

- (NSString *)trimWhitespace;
- (BOOL)isEmpty;
- (BOOL)isEmptyOrListening;
//判断是否为整形
- (BOOL)isPureInt;
//判断是否为浮点形
- (BOOL)isPureFloat;
/** 判断是非包涵汉字 (true-包含， false-不包含)*/
- (BOOL)isChineseNo;
/** 判断是否是手机号码或者邮箱 */
- (BOOL)isPhoneNo;
- (BOOL)isEmail;

- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

//转换拼音
- (NSString *)transformToPinyin;

//是否包含语音解析的图标
- (BOOL)hasListenChar;

/** 获取随机的UUID 字符串 */
+ (NSString *)generateUuidString;

/**
 *  是否包含字符串
 *
 *  @param str 字符串
 *
 *  @return yes-包含 no-不包含
 */
- (BOOL)isIncludeString:(NSString *)str;

- (NSString *)getTopicString;


- (NSString *)stringToTrimWhiteSpace ;

// 是否包含特殊字符
- (BOOL)isIncludeSpecialCharact;

// 是否包含emoji表情
- (BOOL)stringContainsEmoji;

// 去除首尾空格和换行
- (NSString *)removeLinefeedandSpace;

//是否只包含数字，小数点
-(BOOL)isOnlyhasNumberAndpointWithString:(NSString *)string;

@end
