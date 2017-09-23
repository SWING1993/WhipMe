//
//  LSPay.m
//  LSPay
//
//  Created by Steven on 16/2/7.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "LSPay.h"
#import "LSPay+Alipay.h"
#import "LSPay+WeChat.h"

NSString *const LSPaySuccess = @"订单支付成功";
NSString *const LSPayFailure = @"订单支付失败";
NSString *const LSPayCancel = @"用户中途取消";

@implementation LSPay
HMSingletonM(LSPay)

+(void)handleOpenURL:(NSURL *)url{

    [LSPay aliPayHandleOpenURL:url];
    [LSPay weChatHandleOpenURL:url];
}

+(void)payWithType:(LSPayType)type orderString:(NSString *)orderString completeClosure:(void(^)(NSString *errorMsg))completeClosure
{
    if(type == LSPayTypeAliPay) {
        
        [self payUseAlipayWithorderString:orderString completeClosure:completeClosure];
        
    } else if (type == LSPayTypeWechat) {
        
        [self payUseWeChatWithorderString:orderString completeClosure:completeClosure];
    }
}

@end
