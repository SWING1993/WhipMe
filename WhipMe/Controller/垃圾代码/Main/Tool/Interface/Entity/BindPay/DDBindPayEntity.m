//
//  DDBindPayEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDBindPayEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

NSString *const DDBindPayOnMQ                                       = @"on";                                            /**< 开启还是关闭 0关闭 1开启*/

@interface DDBindPayEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *bindPay;                                       /**< 监听付款 */

@end

@implementation DDBindPayEntity

DDEntityHeadM(self.bindPay);

- (void)entityWithParam:(NSDictionary *)param {
    NSInteger on        = [[param objectForKey:DDBindPayOnMQ] integerValue];
    self.bindPay    = [[DDRequest alloc] initWithDelegate:self];
    
    if (0 == on) [self.bindPay socketBindWithType:BIND_TYPE_BIND_PAY on:NO];
    else [self.bindPay socketBindWithType:BIND_TYPE_BIND_PAY on:YES];
}

@end
