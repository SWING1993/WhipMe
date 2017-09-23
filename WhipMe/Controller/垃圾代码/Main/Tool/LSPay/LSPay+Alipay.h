//
//  LSPay+Alipay.h
//  LSPay
//
//  Created by Steven on 16/2/7.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "LSPay.h"

@interface LSPay (Alipay)


+(void)aliPayHandleOpenURL:(NSURL *)url;

+(void)payUseAlipayWithorderString:(NSString *)orderString completeClosure:(void(^)(NSString *errorMsg))completeClosure;

@end
