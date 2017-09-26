//
//  DDCancelOrderEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCancelOrderEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key


#pragma mark Interface Key

const NSInteger DDCancelOrderIFCode                               = 1015;                                             /**< 取消订单业务码 */
NSString *const DDCancelOrderIFVersion                            = @"1.0.0";                                         /**< 取消订单版本号 */

@interface DDCancelOrderEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *cancelOrderRequest;                              /**< 取消订单请求实例 */

@end

@implementation DDCancelOrderEntity

DDEntityHeadM(self.cancelOrderRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDCancelOrderIFCode],CodeKey,
                                    DDCancelOrderIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.cancelOrderRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.cancelOrderRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
