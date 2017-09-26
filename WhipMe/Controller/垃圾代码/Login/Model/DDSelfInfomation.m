//
//  DDSelfInfomation.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 NS. All rights reserved.
//

#import "DDSelfInfomation.h"
#import <objc/runtime.h>

@implementation DDSelfInfomation

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)selfInfoWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"headIcon" : @"avatar",
             @"nickName" : @"nick",
             @"birthDay" : @"birthday",
             @"emailAddress" : @"email",
             @"job" : @"job",
             @"sex" : @"sex",
             @"name" : @"name",
             @"idetify" : @"auth",
             @"selfId" : @"userId",
             @"cardNumber" : @"card",
             @"unpassReason" : @"reason",
             };
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([DDSelfInfomation class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    
    free(ivars);
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([DDSelfInfomation class], &count);
        
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            
            // 设置到成员变量身上
            [self setValue:value forKey:key];
        }
        
        free(ivars);
    }
    return self;
}

@end
