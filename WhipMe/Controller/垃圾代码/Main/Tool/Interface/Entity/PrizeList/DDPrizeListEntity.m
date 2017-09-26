//
//  DDPrizeListEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPrizeListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDPrizeListIFCode                               = 1038;                                             /**< 奖励信息列表业务码 */
NSString *const DDPrizeListIFVersion                            = @"1.0.0";                                         /**< 奖励信息列表版本号 */

@interface DDPrizeListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *PrizeListRequest;                              /**< 奖励信息列表请求实例 */

@end

@implementation DDPrizeListEntity

DDEntityHeadM(self.PrizeListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDPrizeListIFCode],CodeKey,
                                    DDPrizeListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.PrizeListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.PrizeListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end