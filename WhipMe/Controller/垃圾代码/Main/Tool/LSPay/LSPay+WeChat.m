//
//  LSPay+WeChart.m
//  LSPay
//
//  Created by Steven on 16/2/7.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "LSPay+WeChat.h"
#import "WXApi.h"

@interface LSPay ()<WXApiDelegate>

@end

@implementation LSPay (WeChart)

+(void)weChatHandleOpenURL:(NSURL *)url{

    [WXApi handleOpenURL:url delegate:[LSPay sharedLSPay]];
}

+(void)payUseWeChatWithorderString:(NSString *)orderString completeClosure:(void(^)(NSString *errorMsg))completeClosure
{
    LSPay *pay = [LSPay sharedLSPay];
    
    if(!pay.isRegisterWeChatPay){
        
        pay.isRegisterWeChatPay = YES;
        
        [WXApi registerApp:LSPay_WeChat_AppID withDescription:@"LSPay_App"];
    }
    pay.CompleteBlock = completeClosure;
    
    NSDictionary *orderDict = [NSJSONSerialization JSONObjectWithData:[orderString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
   
    PayReq *request = [[PayReq alloc] init];
    request.openID = [orderDict objectForKey:@"appid"];
    request.partnerId = [orderDict objectForKey:@"partnerid"];
    request.prepayId= [orderDict objectForKey:@"prepayid"];
    request.package = [orderDict objectForKey:@"package"];
    request.nonceStr= [orderDict objectForKey:@"noncestr"];
    request.timeStamp = (UInt32)[[orderDict objectForKey:@"timestamp"] integerValue] ;
    request.sign = [orderDict objectForKey:@"sign"];
    [WXApi sendReq:request];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = LSPaySuccess;
                
                break;
            case WXErrCodeUserCancel:
                strMsg = LSPayCancel;
               
                break;
            default:
                strMsg = [NSString stringWithFormat:@"%@ retcode = %d, retstr = %@",LSPayFailure, resp.errCode,resp.errStr];
               
                break;
        }
        
        LSPay *pay = [LSPay sharedLSPay];
        pay.CompleteBlock(strMsg);
    }
    
}

@end
