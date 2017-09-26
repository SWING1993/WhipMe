//
//  LSPay+Alipay.m
//  LSPay
//
//  Created by Steven on 16/2/7.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "LSPay+Alipay.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation LSPay (Alipay)

+(void)aliPayHandleOpenURL:(NSURL *)url{

    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
    }
}

+(void)payUseAlipayWithorderString:(NSString *)orderString completeClosure:(void(^)(NSString *errorMsg))completeClosure
{
    LSPay *pay = [LSPay sharedLSPay];
    pay.CompleteBlock = completeClosure;
    
    NSString *appScheme = @"atxiaoge";
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSString *strMsg = @"";
        switch([[resultDic objectForKey:@"resultStatus"] integerValue])
        {
            case 9000:strMsg = LSPaySuccess;break;
            case 8000:strMsg = @"正在处理中";break;
            case 4000:strMsg = LSPayFailure;break;
            case 6001:strMsg = LSPayCancel;break;
            case 6002:strMsg = @"网络连接错误";break;
            default:strMsg = @"未知错误";
        }
        
        pay.CompleteBlock(strMsg);
    }];
}
@end
