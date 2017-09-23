//
//  DDYueInfomationEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/4/6.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDYueInfomationEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDYueInfomationIFCode                               = 1054;                                             /**< 业务码 */
NSString *const DDYueInfomationIFVersion                            = @"1.0.0";                                         /**< 版本号 */

@interface DDYueInfomationEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *yueInfomationRequest;                              /**< 余额明细 */

@end

@implementation DDYueInfomationEntity

DDEntityHeadM(self.yueInfomationRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDYueInfomationIFCode],CodeKey,
                                    DDYueInfomationIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];

    self.yueInfomationRequest    = [[DDRequest alloc] initWithDelegate:self];
    [self.yueInfomationRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
