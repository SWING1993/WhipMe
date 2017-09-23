//
//  DDEvaluateListEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDEvaluateListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDEvaluateListIFCode                               = 1016;                                             /**< 评价列表业务码 */
NSString *const DDEvaluateListIFVersion                            = @"1.0.0";                                         /**< 评价列表版本号 */

@interface DDEvaluateListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *evaluateListRequest;                              /**< 评价列表请求实例 */

@end

@implementation DDEvaluateListEntity

DDEntityHeadM(self.evaluateListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDEvaluateListIFCode],CodeKey,
                                    DDEvaluateListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.evaluateListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.evaluateListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
