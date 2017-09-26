//
//  DDExpressListEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDExpressListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDExpressListIFCode                                 = 1047;                                             /**< 业务码 */
NSString *const DDExpressListIFVersion                              = @"1.0.0";                                         /**< 版本号 */

@interface DDExpressListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *expressListRequest;                                /**< 快递列表 */

@end

@implementation DDExpressListEntity

DDEntityHeadM(self.expressListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDExpressListIFCode],CodeKey,
                                    DDExpressListIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];


    self.expressListRequest      = [[DDRequest alloc] initWithDelegate:self];
    [self.expressListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
    
}

@end
