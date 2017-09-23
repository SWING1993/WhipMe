//
//  DDExchangeHistoryEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDExchangeHistoryEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDExchangeHistoryIFCode                               = 1028;                                             /**< 优惠券兑换记录业务码 */
NSString *const DDExchangeHistoryIFVersion                            = @"1.0.0";                                         /**< 优惠券兑换记录版本号 */

@interface DDExchangeHistoryEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *exchangeHistoryRequest;                              /**< 优惠券兑换记录请求实例 */

@end

@implementation DDExchangeHistoryEntity

DDEntityHeadM(self.exchangeHistoryRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDExchangeHistoryIFCode],CodeKey,
                                    DDExchangeHistoryIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.exchangeHistoryRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.exchangeHistoryRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end