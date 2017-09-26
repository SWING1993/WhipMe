//
//  DDCourierAnnotation.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierCoordinate.h"

@implementation DDCourierCoordinate

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
