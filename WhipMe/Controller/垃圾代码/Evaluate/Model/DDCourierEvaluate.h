//
//  DDCourierEvaluate.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/2.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCourierEvaluate : NSObject

/** 快递员编号 */
@property (nonatomic,copy)  NSString * courierID;
/** 评价日期 */
@property (nonatomic,copy)  NSString * evaluateDate;
/** 评价内容 */
@property (nonatomic,copy)  NSArray * evaluateContent;
/** 评价等级 */
@property (nonatomic,copy)  NSString * evaluateGrade;

+ (NSString *)timeWithTimeInterval:(NSString *)interval;

@end
