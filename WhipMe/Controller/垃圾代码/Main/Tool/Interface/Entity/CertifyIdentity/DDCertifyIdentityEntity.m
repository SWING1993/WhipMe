//
//  DDCertifyIdentityEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCertifyIdentityEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDCertifyIdentityIFCode                               = 1032;                                             /**< 身份认证业务码 */
NSString *const DDCertifyIdentityIFVersion                            = @"1.0.0";                                         /**< 身份认证版本号 */

@interface DDCertifyIdentityEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *certifyIdentityRequest;                              /**< 身份认证请求实例 */

@end

@implementation DDCertifyIdentityEntity

DDEntityHeadM(self.certifyIdentityRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDCertifyIdentityIFCode],CodeKey,
                                    DDCertifyIdentityIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.certifyIdentityRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.certifyIdentityRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end