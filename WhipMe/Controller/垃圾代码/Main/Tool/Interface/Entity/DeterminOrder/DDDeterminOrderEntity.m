//
//  DDDeterminOrderEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDDeterminOrderEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDDeterminOrderIFCode                               = 1013;                                             /**< 确认订单业务码 */
NSString *const DDDeterminOrderIFVersion                            = @"1.0.0";                                         /**< 确认订单版本号 */

@interface DDDeterminOrderEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *determinOrderRequest;                              /**< 确认订单请求实例 */

@end

@implementation DDDeterminOrderEntity

DDEntityHeadM(self.determinOrderRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDDeterminOrderIFCode],CodeKey,
                                    DDDeterminOrderIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.determinOrderRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.determinOrderRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
