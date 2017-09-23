//
//  DDLogisticsEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/30.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDLogisticsEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDLogisticsIFCode                                       = 1046;                                         /**< 业务码 */
NSString *const DDLogisticsIFVersion                                    = @"1.0.0";                                     /**< 版本号 */

@interface DDLogisticsEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *logisticsRequest;                          /**< 查询物流信息 */

@end

@implementation DDLogisticsEntity

DDEntityHeadM(self.logisticsRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDLogisticsIFCode],CodeKey,
                                    DDLogisticsIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];


    self.logisticsRequest        = [[DDRequest alloc] initWithDelegate:self];
    [self.logisticsRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
    
}

@end
