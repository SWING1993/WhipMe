//
//  DDCoinListEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCoinListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDCoinListIFCode                               = 1025;                                             /**< 嘟币业务码 */
NSString *const DDCoinListIFVersion                            = @"1.0.0";                                         /**< 嘟币版本号 */

@interface DDCoinListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *coinListRequest;                              /**< 嘟币请求实例 */

@end

@implementation DDCoinListEntity

DDEntityHeadM(self.coinListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDCoinListIFCode],CodeKey,
                                    DDCoinListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.coinListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.coinListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end