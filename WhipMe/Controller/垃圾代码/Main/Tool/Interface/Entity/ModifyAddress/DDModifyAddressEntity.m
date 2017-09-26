//
//  DDModifyAddressEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/11.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDModifyAddressEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDModifyAddressIFCode                                       = 1010;                                     /**< 修改地址业务码 */
NSString *const DDModifyAddressIFVersion                                    = @"1.0.0";                                 /**< 修改地址版本号 */

@interface DDModifyAddressEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *modifyAddressRequest;                      /**< 修改地址请求 */

@end

@implementation DDModifyAddressEntity

DDEntityHeadM(self.modifyAddressRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDModifyAddressIFCode],CodeKey,
                                    DDModifyAddressIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    NSLog(@"%@",ifParam);
    
    self.modifyAddressRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.modifyAddressRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end

