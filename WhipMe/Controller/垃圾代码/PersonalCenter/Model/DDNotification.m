//
//  DDNotification.m
//  DDExpressClient
//
//  Created by SongGang on 2/29/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDNotification.h"
#import "DDRequest.h"
#import "NSDate+DateHelper.h"

@interface DDNotification ()

@property (nonatomic, copy, readwrite)     NSString                                    *messageId;                      /**< 消息ID */
@property (nonatomic, copy, readwrite)     NSString                                    *title;                          /**< 标题 */
@property (nonatomic, copy, readwrite)     NSString                                    *content;                        /**< 内容 */
@property (nonatomic, copy, readwrite)     NSString                                    *time;                           /**< 时间 */
@property (nonatomic, assign, readwrite)   NOTIFIACION_TYPE                             type;                           /**< 消息类型 */
@property (nonatomic, copy, readwrite)     NSString                                    *activeUrl;                      /**< 活动URL */
@property (nonatomic, copy, readwrite)     NSString                                    *expressNum;                     /**< 快递单号 */
@property (nonatomic, copy, readwrite)     NSString                                    *companyId;                      /**< 快递公司ID */

@end

@implementation DDNotification

#pragma mark -
#pragma mark Pucblic Methods

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.messageId      = [dictionary ddObjectForKey:@"msgId" classType:CLASS_TYPE_NSSTRING];
        self.title          = [dictionary ddObjectForKey:@"title" classType:CLASS_TYPE_NSSTRING];
        self.content        = [dictionary ddObjectForKey:@"message" classType:CLASS_TYPE_NSSTRING];
        self.time           = [self timeWithDictionary:dictionary];
        self.type           = [self typeWithDictionary:dictionary];
        self.activeUrl      = [dictionary ddObjectForKey:@"url" classType:CLASS_TYPE_NSSTRING];
        self.expressNum     = [dictionary ddObjectForKey:@"expNum" classType:CLASS_TYPE_NSSTRING];
        self.companyId      = [dictionary ddObjectForKey:@"corId" classType:CLASS_TYPE_NSSTRING];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Methods

/**
 *  获得时间字符串
 *
 *  @param dictionary 数据字典
 *
 *  @return 时间字符串
 */
- (NSString *)timeWithDictionary:(NSDictionary *)dictionary {
    NSString    *intervalString = [dictionary ddObjectForKey:@"date" classType:CLASS_TYPE_NSSTRING];
    long long    interval       = [intervalString longLongValue]/1000;
    NSDate      *date           = [[NSDate alloc] initWithTimeIntervalSince1970:interval];
    NSString    *time           = [date stringWithFormat:@"MM-dd HH:mm"];
    
    return time;
}

/**
 *  获得通知类型
 *
 *  @param dictionary 数据字典
 *
 *  @return 通知类型
 */
- (NOTIFIACION_TYPE)typeWithDictionary:(NSDictionary *)dictionary {
    NSInteger            typeInteger    = [[dictionary ddObjectForKey:@"type" classType:CLASS_TYPE_NSNUMBER] integerValue];
    NOTIFIACION_TYPE     type           = NOTIFIACION_TYPE_EXPRESS;
    
    switch (typeInteger) {
        case 1:
            type = NOTIFIACION_TYPE_EXPRESS;
            break;
            
        case 2:
            type = NOTIFIACION_TYPE_SYSTEM;
            break;
            
        case 3:
            type = NOTIFIACION_TYPE_ACTIVE;
            break;
            
        default:
            break;
    }
    
    return type;
}

@end
