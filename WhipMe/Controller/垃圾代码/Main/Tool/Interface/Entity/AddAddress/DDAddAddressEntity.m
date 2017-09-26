//
//  DDAddAddressEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/11.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDAddAddressEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDAddAddressIFCode                                      = 1008;                                         /**< 增加地址业务码 */
NSString *const DDAddAddressIFVersion                                   = @"1.0.0";                                     /**< 增加地址版本号 */

@interface DDAddAddressEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *addAddressRequest;                             /**< 增加地址 */

@end

@implementation DDAddAddressEntity

DDEntityHeadM(self.addAddressRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDAddAddressIFCode],CodeKey,
                                    DDAddAddressIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    
    self.addAddressRequest  = [[DDRequest alloc] initWithDelegate:self];
    [self.addAddressRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
    
}

@end
