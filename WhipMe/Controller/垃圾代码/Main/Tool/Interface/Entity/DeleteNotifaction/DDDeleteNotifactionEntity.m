//
//  DDDeleteNotifactionEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/4/20.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDDeleteNotifactionEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDDeleteNotifactionIFCode                               = 1056;                                         /**< 业务码 */
NSString *const DDDeleteNotifactionIFVersion                            = @"1.0.0";                                     /**< 版本号 */

@interface DDDeleteNotifactionEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *deleteRequest;                                 /**< 删除消息通知 */

@end

@implementation DDDeleteNotifactionEntity

DDEntityHeadM(self.deleteRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDDeleteNotifactionIFCode],CodeKey,
                                    DDDeleteNotifactionIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];


    self.deleteRequest           = [[DDRequest alloc] initWithDelegate:self];
    [self.deleteRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
    
}

@end
