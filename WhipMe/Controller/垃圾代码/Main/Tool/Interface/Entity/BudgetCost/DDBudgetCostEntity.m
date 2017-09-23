//
//  DDBudgetCostEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/14.
//  Copyright © 2016年 NS. All rights reserved.
//


#import "DDBudgetCostEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDBudgetCostIFCode                               = 1012;                                             /**< 预估费用业务码 */
NSString *const DDBudgetCostIFVersion                            = @"1.0.0";                                         /**< 预估费用版本号 */

@interface DDBudgetCostEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *budgetCostRequest;                              /**< 预估费用请求实例 */

@end

@implementation DDBudgetCostEntity

DDEntityHeadM(self.budgetCostRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:DDBudgetCostIFCode],CodeKey,
                                   DDBudgetCostIFVersion,VersionKey,
                                   nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.budgetCostRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.budgetCostRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end