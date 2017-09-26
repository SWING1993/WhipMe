//
//  DDOrderListEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDOrderListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDOrderListIFCode                               = 1021;                                             /**< 订单列表业务码 */
NSString *const DDOrderListIFVersion                            = @"1.0.0";                                         /**< 订单列表版本号 */

@interface DDOrderListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *orderListRequest;                              /**< 订单列表请求实例 */

@end

@implementation DDOrderListEntity

DDEntityHeadM(self.orderListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDOrderListIFCode],CodeKey,
                                    DDOrderListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.orderListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.orderListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end