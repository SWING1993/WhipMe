//
//  DDSubmitComplainEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDSubmitComplainEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDSubmitComplainIFCode                               = 1020;                                             /**< 投诉建议业务码 */
NSString *const DDSubmitComplainIFVersion                            = @"1.0.0";                                         /**< 投诉建议版本号 */

@interface DDSubmitComplainEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *submitComplainRequest;                              /**< 投诉建议请求实例 */

@end

@implementation DDSubmitComplainEntity

DDEntityHeadM(self.submitComplainRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDSubmitComplainIFCode],CodeKey,
                                    DDSubmitComplainIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.submitComplainRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.submitComplainRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end