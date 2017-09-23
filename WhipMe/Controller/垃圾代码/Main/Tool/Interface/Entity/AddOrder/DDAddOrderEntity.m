//
//  DDAddOrderEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDAddOrderEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDAddOrderIFCode                               = 1014;                                             /**< 追加订单业务码 */
NSString *const DDAddOrderIFVersion                            = @"1.0.0";                                         /**< 追加订单版本号 */

@interface DDAddOrderEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *addOrderRequest;                              /**< 追加订单请求实例 */

@end

@implementation DDAddOrderEntity

DDEntityHeadM(self.addOrderRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDAddOrderIFCode],CodeKey,
                                    DDAddOrderIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.addOrderRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.addOrderRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
