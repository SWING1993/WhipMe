//
//  DDMarketListEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDMarketListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDMarketListIFCode                               = 1026;                                             /**< 商城业务码 */
NSString *const DDMarketListIFVersion                            = @"1.0.0";                                         /**< 商城版本号 */

@interface DDMarketListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *marketListRequest;                              /**< 商城请求实例 */

@end

@implementation DDMarketListEntity

DDEntityHeadM(self.marketListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDMarketListIFCode],CodeKey,
                                    DDMarketListIFVersion,VersionKey,
                                    nil];
    
    //[ifParam addEntriesFromDictionary:param];
    
    self.marketListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.marketListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end