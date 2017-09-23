//
//  DDWaitCourierEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/17.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDWaitCourierEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

NSString *const DDWaitCourierOnMQ                                   = @"on";                                            /**< 开启还是关闭 0关闭 1开启*/

#pragma mark Interface Key

@interface DDWaitCourierEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *waitCourier;                               /**< 等待快递员 */

@end

@implementation DDWaitCourierEntity

DDEntityHeadM(self.waitCourier);

- (void)entityWithParam:(NSDictionary *)param {
    NSInteger on        = [[param objectForKey:DDWaitCourierOnMQ] integerValue];
    self.waitCourier    = [[DDRequest alloc] initWithDelegate:self];
    
    if (0 == on) [self.waitCourier socketBindWithType:BIND_TYPE_WAIT_RUSH on:NO];
    else [self.waitCourier socketBindWithType:BIND_TYPE_WAIT_RUSH on:YES];
}

@end

