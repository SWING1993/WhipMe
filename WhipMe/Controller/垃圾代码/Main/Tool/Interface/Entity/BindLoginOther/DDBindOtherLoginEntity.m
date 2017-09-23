//
//  DDBindOtherLoginEntity.m
//  DDExpressCourier
//
//  Created by Sxx on 16/5/5.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDBindOtherLoginEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

NSString *const DDBindOtherLoginOnMQ                                = @"on";                                            /**< 开启还是关闭 0关闭 1开启*/

@interface DDBindOtherLoginEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *otherLoginRequest;                                 /**< 监听别处登录请求 */

@end

@implementation DDBindOtherLoginEntity

- (void)dealloc {

}

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

- (void)entityWithParam:(NSDictionary *)param {
    NSInteger on           = [[param objectForKey:DDBindOtherLoginOnMQ] integerValue];
    self.otherLoginRequest = [[DDRequest alloc] initWithDelegate:self];
    
    if (0 == on) {
        [self.otherLoginRequest socketBindWithType:BIND_TYPE_OTHER_LOGIN on:NO];
    } else {
        [self.otherLoginRequest socketBindWithType:BIND_TYPE_OTHER_LOGIN on:YES];
    }
}

- (void)sendResult:(NSDictionary *)result error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(entity:result:error:)]) {
        [self.delegate entity:self result:result error:error];
    }
}

- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error {
    if (![request isEqual:(self.otherLoginRequest)]) return;
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
    
    //置空所有标记
    [DDInterfaceTool configUserkey:@""];
    [DDInterfaceTool configUserID:0];
    [DDInterfaceTool configPhoneNumber:@""];
    [DDInterfaceTool configLoginSucced:NO];
    [DDInterfaceTool configStop:YES];
    
    [self sendResult:result error:nil];
}

@end
