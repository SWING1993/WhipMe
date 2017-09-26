//
//  DDPackageListEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/10.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPackageListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDPackageListIFCode                                     = 1007;                                         /**< 获取寄件信息业务码 */
NSString *const DDPackageListIFVersion                                  = @"1.0.0";                                     /**< 获取寄件信息版本号 */


@interface DDPackageListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *packageListRequest;                        /**< 包裹列表 */
@property (nonatomic, strong)   NSNumber                                    *expressType;                               /**< 包裹类型 */

@end

@implementation DDPackageListEntity

DDEntityHeadM(self.packageListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDPackageListIFCode],CodeKey,
                                    DDPackageListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.packageListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.packageListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
    
}

@end