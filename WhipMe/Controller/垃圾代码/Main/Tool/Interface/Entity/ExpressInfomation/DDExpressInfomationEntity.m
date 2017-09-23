//
//  DDExpressInfomationEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDExpressInfomationEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDExpressInfomationIFCode                                   = 1048;                                     /**< 业务码 */
NSString *const DDExpressInfomationIFVersion                                = @"1.0.0";                                 /**< 版本号 */

@interface DDExpressInfomationEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *expressInfomationRequest;                  /**< 快递列表 */

@end

@implementation DDExpressInfomationEntity

DDEntityHeadM(self.expressInfomationRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam  = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDExpressInfomationIFCode],CodeKey,
                                    DDExpressInfomationIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];


    self.expressInfomationRequest = [[DDRequest alloc] initWithDelegate:self];
    [self.expressInfomationRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
