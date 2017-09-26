//
//  DDSubmitEvaluateEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDSubmitEvaluateEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDSubmitEvaluateIFCode                               = 1018;                                             /**< 提交评价业务码 */
NSString *const DDSubmitEvaluateIFVersion                            = @"1.0.0";                                         /**< 提交评价版本号 */


@interface DDSubmitEvaluateEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *submitEvaluateRequest;                              /**< 提交评价请求实例 */

@end

@implementation DDSubmitEvaluateEntity

DDEntityHeadM(self.submitEvaluateRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDSubmitEvaluateIFCode],CodeKey,
                                    DDSubmitEvaluateIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.submitEvaluateRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.submitEvaluateRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end