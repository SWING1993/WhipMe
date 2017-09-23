//
//  LSPay+WeChart.h
//  LSPay
//
//  Created by Steven on 16/2/7.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "LSPay.h"

@interface LSPay (WeChat)

+(void)weChatHandleOpenURL:(NSURL *)url;

+(void)payUseWeChatWithorderString:(NSString *)orderString completeClosure:(void(^)(NSString *errorMsg))completeClosure;

@end
