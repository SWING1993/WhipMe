//
//  DDCostDetailEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCostDetailEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDCostDetailIFCode                               = 1019;                                             /**< 费用详情业务码 */
NSString *const DDCostDetailIFVersion                            = @"1.0.0";                                         /**< 费用详情版本号 */

@interface DDCostDetailEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *costDetailRequest;                              /**< 费用详情请求实例 */

@end

@implementation DDCostDetailEntity

DDEntityHeadM(self.costDetailRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDCostDetailIFCode],CodeKey,
                                    DDCostDetailIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.costDetailRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.costDetailRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end