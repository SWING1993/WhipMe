//
//  DDPackageInfoEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/22.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPackageInfoEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDPackageInfoIFCode                                     = 1040;                                         /**< 包裹信息业务码 */
NSString *const DDPackageInfoIFVersion                                  = @"1.0.0";                                     /**< 包裹信息版本号 */

@interface DDPackageInfoEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *packageInfoRequest;                            /**< 包裹详情 */

@end

@implementation DDPackageInfoEntity

DDEntityHeadM(self.packageInfoRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDPackageInfoIFCode],CodeKey,
                                    DDPackageInfoIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    
    self.packageInfoRequest  = [[DDRequest alloc] initWithDelegate:self];
    [self.packageInfoRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
