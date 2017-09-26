//
//  DDNotificationNumEntity.m
//  DDExpressClient
//
//  Created by Sxx on 16/4/29.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDNotificationNumEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDNotificationNumIFCode                             = 1058;                                             /**< 业务码 */
NSString *const DDNotificationNumIFVersion                          = @"1.0.0";                                         /**< 版本号 */

@interface DDNotificationNumEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *notificationNumRequest;                            /**< 通知数量请求 */

@end

@implementation DDNotificationNumEntity

DDEntityHeadM(self.notificationNumRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSNumber    *code            = [NSNumber numberWithInteger:DDNotificationNumIFCode];
    NSString    *version         = DDNotificationNumIFVersion;

    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [ifParam setObject:code forKey:CodeKey];
    [ifParam setObject:version forKey:VersionKey];

    self.notificationNumRequest  = [[DDRequest alloc] initWithDelegate:self];
    [self.notificationNumRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
