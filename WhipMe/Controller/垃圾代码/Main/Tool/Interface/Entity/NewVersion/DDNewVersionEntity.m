//
//  DDNewVersionEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/4/21.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDNewVersionEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDNewVersionIFCode                                      = 10006;                                        /**< 业务码 */
NSString *const DDNewVersionIFVersion                                   = @"1.0.0";                                     /**< 版本号 */

@interface DDNewVersionEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *neVersionRequest;                              /**< 版本更新 */

@end

@implementation DDNewVersionEntity

DDEntityHeadM(self.neVersionRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSNumber    *code            = [NSNumber numberWithInteger:DDNewVersionIFCode];
    NSString    *version         = DDNewVersionIFVersion;
    
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [ifParam setObject:code forKey:CodeKey];
    [ifParam setObject:version forKey:VersionKey];
    
    self.neVersionRequest     = [[DDRequest alloc] initWithDelegate:self];
    [self.neVersionRequest httpRequestWithType:HTTP_REQUEST_TYPE_NEW_VERSION param:ifParam];
}

@end
