//
//  NSDate+DateHelper.m
//  FuErDai_01
//
//  Created by ASN on 15/1/20.
//  Copyright (c) 2015年 Mr. Yang. All rights reserved.
//

#import "NSDate+DateHelper.h"

@implementation NSDate (DateHelper)

//获取今天是星期几
- (NSInteger)dayOfWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:self];
    NSInteger y = [offsetComponents year];
    NSInteger m = [offsetComponents month];
    NSInteger d = [offsetComponents day];
    static int t[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    y -= m < 3;
    
    NSInteger result = (y + y/4 - y/100 + y/400 + t[m-1] + d) % 7;
    if (result == 0) {
        result = 7;
    }
    return result;
}

//获取每月有多少天
- (NSInteger)monthOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:self];
    NSInteger y = [offsetComponents year];
    NSInteger m = [offsetComponents month];
    if (m == 2) {
        if (y%4 == 0 && (y%100 != 0 || y%400 == 0))
        {
            return 29;
        }
        return 28;
    }
    if (m == 4 || m == 6 || m == 9 || m == 11)
    {
        return 30;
    }
    return 31;
}

//本周开始时间
- (NSDate *)beginningOfWeek
{
    NSInteger weekday = [self dayOfWeek];
    return  [self addDay:(weekday-1)*-1];
}

//本周结束时间
- (NSDate *)endOfWeek
{
    NSInteger weekday = [self dayOfWeek];
    if (weekday == 7) {
        return self;
    }
    return [self addDay:7-weekday];
}

//日期添加几天
- (NSDate *)addDay:(NSInteger)day
{
    NSTimeInterval interval = 24 * 60 * 60;
    return  [self dateByAddingTimeInterval:day*interval];
}

//日期格式化
- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    [outputFormatter release];
    return timestamp_str;
}

//字符串转换成时间
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Beijing"]];
    NSDate *date = [inputFormatter dateFromString:string];
    [inputFormatter release];
    return date;
}

//时间转换成字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [date stringWithFormat:format];
}

//日期转化成民国时间
- (NSString *)dateToTW:(NSString *)string
{
    NSString *str=[self stringWithFormat:string];
    int y=[[str substringWithRange:NSMakeRange(0, 4)] intValue];
    return [NSString stringWithFormat:@"%d%@",y-1911,[str stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""]];
}

+ (NSString *)stringWithNowDate:(NSDate *)nowDate newDate:(NSDate *)newDate;
{
    if (nil == newDate)
    {
        NSDate *newDate = [NSDate date];
        long dd = (long)[newDate timeIntervalSince1970] - [nowDate timeIntervalSince1970];
        
        NSString *timeString = @"";
        
        if (dd/3600 < 1)
        {
            timeString = [NSString stringWithFormat:@"%ld 分钟", MAX(1, dd/60)];
        }
        else if (dd/3600 >= 1 && dd/86400 < 1)
        {
            timeString = [NSString stringWithFormat:@"%ld 小时前", dd/3600];
        }
        else if (dd/86400 >= 1 && dd/2592000 < 1)
        {
            timeString = [NSString stringWithFormat:@"%ld 天前", dd/86400];
        }
        else
        {
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            comps = [calendar components:unitFlags fromDate:nowDate];
            
            timeString = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year, (long)comps.month, (long)comps.day];
        }
        return timeString;
    }
    else
    {
        long dd = (long)[newDate timeIntervalSince1970] - [nowDate timeIntervalSince1970];
        
        NSString *timeString = @"";
        
        if (dd/3600 < 1)
        {
            timeString = [NSString stringWithFormat:@"%ld 分钟", MAX(1, dd/60)];
        }
        else if (dd/3600 >= 1 && dd/86400 < 1)
        {
            timeString = [NSString stringWithFormat:@"%ld 小时前", dd/3600];
        }
        else if (dd/86400 >= 1 && dd/2592000 < 1)
        {
            timeString = [NSString stringWithFormat:@"%ld 天前", dd/86400];
        }
        else
        {
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            comps = [calendar components:unitFlags fromDate:nowDate];
            
            timeString = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year, (long)comps.month, (long)comps.day];
        }
        return timeString;
    }
}

+ (NSString *)stringWithFormDate:(NSDate *)date
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    NSString *brithDay = [NSString stringWithFormat:@"%ld",(long)[components1 day]];
    NSString *brithHour = [components1 hour] > 9 ? [NSString stringWithFormat:@"%ld",(long)[components1 hour]] : [NSString stringWithFormat:@"0%ld",(long)[components1 hour]];
    NSString *brithMinute = [components1 minute] > 9 ? [NSString stringWithFormat:@"%ld",(long)[components1 minute]] : [NSString stringWithFormat:@"0%ld",(long)[components1 minute]];
    
    NSString *strTime = [NSString stringWithFormat:@"%@日 %@:%@",brithDay, brithHour, brithMinute];
    
    return strTime;
}

+ (NSString *)stringWithComponentDate:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    NSString *brithHour = [components hour] > 9 ? [NSString stringWithFormat:@"%ld",(long)[components hour]] : [NSString stringWithFormat:@"0%ld",(long)[components hour]];
    NSString *brithMinute = [components minute] > 9 ? [NSString stringWithFormat:@"%ld",(long)[components minute]] : [NSString stringWithFormat:@"0%ld",(long)[components minute]];
    
    NSString *strTime = [NSString stringWithFormat:@"%@:%@", brithHour, brithMinute];
    return strTime;
}


@end
