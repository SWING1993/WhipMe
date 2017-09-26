//
//  DDCourierEvaluate.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/2.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierEvaluate.h"

@implementation DDCourierEvaluate

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"evaluateDate" : @"date",
             @"evaluateContent" : @"content",
             @"evaluateGrade" : @"star"
             };
}

+ (NSString *)timeWithTimeInterval:(NSString *)interval
{
    interval = [interval substringToIndex:10];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

@end
