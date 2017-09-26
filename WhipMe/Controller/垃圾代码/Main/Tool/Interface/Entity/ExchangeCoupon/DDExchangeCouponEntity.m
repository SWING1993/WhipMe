//
//  DDExchangeCouponEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDExchangeCouponEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDExchangeCouponIFCode                               = 1027;                                             /**< 兑换优惠券业务码 */
NSString *const DDExchangeCouponIFVersion                            = @"1.0.0";                                         /**< 兑换优惠券版本号 */


@interface DDExchangeCouponEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *exchangeCouponRequest;                              /**<兑换优惠券请求实例 */

@end

@implementation DDExchangeCouponEntity

DDEntityHeadM(self.exchangeCouponRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDExchangeCouponIFCode],CodeKey,
                                    DDExchangeCouponIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.exchangeCouponRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.exchangeCouponRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end