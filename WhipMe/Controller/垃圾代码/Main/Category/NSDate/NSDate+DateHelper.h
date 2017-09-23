//
//  NSDate+DateHelper.h
//  FuErDai_01
//
//  Created by ASN on 15/1/20.
//  Copyright (c) 2015年 Mr. Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateHelper)

// 获取今天是星期几
- (NSInteger)dayOfWeek;

// 获取每月有多少天
- (NSInteger)monthOfDay;

// 本周开始时间
- (NSDate *)beginningOfWeek;

// 本周结束时间
- (NSDate *)endOfWeek;

// 日期添加几天
- (NSDate *)addDay:(NSInteger)day;

// 日期格式化
- (NSString *)stringWithFormat:(NSString *)format;

// 字符串转换成时间
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

// 时间转换成字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;

// 日期转化成民国时间
- (NSString *)dateToTW:(NSString *)string;

// 计算上报时间差
+ (NSString *)stringWithNowDate:(NSDate *)nowDate newDate:(NSDate *)newDate;

+ (NSString *)stringWithFormDate:(NSDate *)date;

+ (NSString *)stringWithComponentDate:(NSDate *)date;


@end
