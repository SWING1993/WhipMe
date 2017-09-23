//
//  DDCompanyListEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 3/10/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDCompanyListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDCompanyListIFCode                                     = 1004;                                         /**< 获取快递公司列表业务码 */
NSString *const DDCompanyListIFVersion                                  = @"1.0.0";                                     /**< 获取快递公司列表版本号 */

@interface DDCompanyListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *companyListRequest;                        /**< 快递公司列表 */

@end

@implementation DDCompanyListEntity

DDEntityHeadM(self.companyListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    self.companyListRequest = [[DDRequest alloc] initWithDelegate:self];
    NSNumber        *code           = [NSNumber numberWithInteger:DDCompanyListIFCode];
    NSString        *version        = DDCompanyListIFVersion;
    
    NSDictionary    *paramDic       = [NSDictionary dictionaryWithObjectsAndKeys:
                                       code,                CodeKey,
                                       version,             VersionKey,
                                       nil];
    
    [self.companyListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:paramDic];
}

@end
