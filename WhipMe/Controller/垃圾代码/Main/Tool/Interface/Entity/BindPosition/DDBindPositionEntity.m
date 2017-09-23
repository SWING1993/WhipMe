//
//  DDBindPositionEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/29.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDBindPositionEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

NSString *const DDBindPositionOnMQ                                  = @"on";                                            /**< 开启还是关闭 0 关闭 1 开启 */

@interface DDBindPositionEntity ()<DDRequestDelegate>

@property (nonatomic, strong) DDRequest                             *bindPositionRequset;                               /**< 绑定快递员位置 */

@end

@implementation DDBindPositionEntity

DDEntityHeadM(self.bindPositionRequset);

- (void)entityWithParam:(NSDictionary *)param {
    NSInteger on             = [[param objectForKey:DDBindPositionOnMQ] integerValue];
    self.bindPositionRequset = [[DDRequest alloc] initWithDelegate:self];

    if (0 == on) [self.bindPositionRequset socketBindWithType:BIND_TYPE_BIND_POSITION on:NO];
    else [self.bindPositionRequset socketBindWithType:BIND_TYPE_BIND_POSITION on:YES];
}

@end
