//
//  DDCouponListEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCouponListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDCouponListIFCode                               = 1038;                                             /**< 优惠券信息列表业务码 */
NSString *const DDCouponListIFVersion                            = @"1.0.0";                                         /**< 优惠券信息列表版本号 */

@interface DDCouponListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *CouponListRequest;                              /**< 优惠券信息列表请求实例 */

@end

@implementation DDCouponListEntity

DDEntityHeadM(self.CouponListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDCouponListIFCode],CodeKey,
                                    DDCouponListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.CouponListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.CouponListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end