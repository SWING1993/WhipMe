//
//  DDExchangeCodeEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDExchangeCodeEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDExchangeCodeIFCode                               = 1029;                                             /**< 兑换优惠码业务码 */
NSString *const DDExchangeCodeIFVersion                            = @"1.0.0";                                         /**< 兑换优惠码版本号 */

@interface DDExchangeCodeEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *ExchangeCodeRequest;                              /**< 兑换优惠码请求实例 */

@end

@implementation DDExchangeCodeEntity

DDEntityHeadM(self.ExchangeCodeRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDExchangeCodeIFCode],CodeKey,
                                    DDExchangeCodeIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.ExchangeCodeRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.ExchangeCodeRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end