//
//  DDNotificationListEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDNotificationListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDNotificationListIFCode                               = 1034;                                             /**< 通知列表业务码 */
NSString *const DDNotificationListIFVersion                            = @"1.0.0";                                         /**< 通知列表版本号 */

@interface DDNotificationListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *notificationListRequest;                              /**< 通知列表请求实例 */

@end

@implementation DDNotificationListEntity

DDEntityHeadM(self.notificationListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDNotificationListIFCode],CodeKey,
                                    DDNotificationListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.notificationListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.notificationListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end