//
//  DDPayParamEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/4/6.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPayParamEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDPayParamIFCode                                        = 1052;                                         /**< 业务码 */
NSString *const DDPayParamIFVersion                                     = @"1.0.0";                                     /**< 版本号 */

@interface DDPayParamEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *payParamRequest;                               /**< 支付参数 */

@end

@implementation DDPayParamEntity

DDEntityHeadM(self.payParamRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDPayParamIFCode],CodeKey,
                                    DDPayParamIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];

    self.payParamRequest         = [[DDRequest alloc] initWithDelegate:self];
    [self.payParamRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
