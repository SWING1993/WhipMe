//
//  DDAddressListEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/11.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDAddressListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDAddressListIFCode                                     = 1009;                                         /**< 地址列表业务码 */
NSString *const DDAddressListIFVersion                                  = @"1.0.0";                                     /**< 地址列表版本号 */


@interface DDAddressListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *addressListRequest;                            /**< 地址列表 */
@property (nonatomic, strong)   NSNumber                                *addressType;                                   /**< 地址类型 */

@end

@implementation DDAddressListEntity

DDEntityHeadM(self.addressListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDAddressListIFCode],CodeKey,
                                    DDAddressListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];

    self.addressListRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.addressListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
    
    
}

@end