//
//  DDChangePhoneEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDChangePhoneEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDChangePhoneIFCode                               = 1033;                                               /**< 更换手机号业务码 */
NSString *const DDChangePhoneIFVersion                            = @"1.0.0";                                           /**< 身更换手机号版本号 */

@interface DDChangePhoneEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *changePhoneRequest;                                /**< 更换手机号请求实例 */
@property (nonatomic, strong)   NSString                            *phone;                                             /**< 临时存储手机号 */

@end

@implementation DDChangePhoneEntity

- (void)entityWithParam:(NSDictionary *)param {
    self.phone  = [param objectForKey:@"phone"];
    
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDChangePhoneIFCode],CodeKey,
                                    DDChangePhoneIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.changePhoneRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.changePhoneRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

- (void)dealloc { }

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)sendResult:(NSDictionary *)result error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(entity:result:error:)]) {
        [self.delegate entity:self result:result error:error];
    }
}

- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error {
    if (![request isEqual:(self.changePhoneRequest)]) return;
    if (error) {
        [self sendResult:nil error:error];
        return;
    }
    NSInteger    code       = [[result objectForKey:CodeKey] integerValue];
    NSString    *message    = [result objectForKey:MessageKey];
    if (code != SuccessCode) {
        NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
        [self sendResult:nil error:error];
        return;
    }
    
    [DDInterfaceTool configPhoneNumber:self.phone];
    [self sendResult:result error:nil];
}

@end