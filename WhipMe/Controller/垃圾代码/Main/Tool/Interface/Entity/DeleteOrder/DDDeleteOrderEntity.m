//
//  DDDeleteOrderEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDDeleteOrderEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDDeleteOrderIFCode                               = 1022;                                             /**< 删除订单业务码 */
NSString *const DDDeleteOrderIFVersion                            = @"1.0.0";                                         /**< 删除订单版本号 */

@interface DDDeleteOrderEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *deleteOrderRequest;                              /**< 删除订单请求实例 */

@end

@implementation DDDeleteOrderEntity

DDEntityHeadM(self.deleteOrderRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDDeleteOrderIFCode],CodeKey,
                                    DDDeleteOrderIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.deleteOrderRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.deleteOrderRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end