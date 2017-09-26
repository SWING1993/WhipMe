//
//  DDMayCompanyEntity.m
//  DDExpressClient
//
//  Created by Sxx on 16/4/26.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDMayCompanyEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDMayCompanyIFCode                                          = 1057;                                     /**< 业务码 */
NSString *const DDMayCompanyIFVersion                                       = @"1.0.0";                                 /**< 版本号 */

@interface DDMayCompanyEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *mayCompanyRequest;                         /**< 可能快递公司 */

@end

@implementation DDMayCompanyEntity

DDEntityHeadM(self.mayCompanyRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSNumber    *code            = [NSNumber numberWithInteger:DDMayCompanyIFCode];
    NSString    *version         = DDMayCompanyIFVersion;

    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [ifParam setObject:code forKey:CodeKey];
    [ifParam setObject:version forKey:VersionKey];

    self.mayCompanyRequest       = [[DDRequest alloc] initWithDelegate:self];
    [self.mayCompanyRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
