//
//  DDTotalCompanyEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDTotalCompanyEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDTotalCompanyIFCode                                    = 1050;                                         /**< 业务码 */
NSString *const DDTotalCompanyIFVersion                                 = @"1.0.0";                                     /**< 版本号 */

@interface DDTotalCompanyEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *totalCompanyRequest;                           /**< 全部快递公司 */

@end

@implementation DDTotalCompanyEntity

DDEntityHeadM(self.totalCompanyRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDTotalCompanyIFCode],CodeKey,
                                    DDTotalCompanyIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];

    self.totalCompanyRequest     = [[DDRequest alloc] initWithDelegate:self];
    [self.totalCompanyRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
