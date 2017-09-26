//
//  DDOrderDetailEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDOrderDetailEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDOrderDetailIFCode                               = 1023;                                             /**< 订单详情业务码 */
NSString *const DDOrderDetailIFVersion                            = @"1.0.0";                                         /**< 订单详情版本号 */

@interface DDOrderDetailEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *orderDetailRequest;                              /**< 订单详情请求实例 */

@end

@implementation DDOrderDetailEntity

DDEntityHeadM(self.orderDetailRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDOrderDetailIFCode],CodeKey,
                                    DDOrderDetailIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.orderDetailRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.orderDetailRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end