//
//  DDDeleteAddressEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/12.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDDeleteAddressEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDDeleteAddressIFCode                               = 1011;                                             /**< 删除地址业务码 */
NSString *const DDDeleteAddressIFVersion                            = @"1.0.0";                                         /**< 删除地址版本号 */

@interface DDDeleteAddressEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *deleteAddressRequest;                              /**< 删除地址请求实例 */

@end

@implementation DDDeleteAddressEntity

DDEntityHeadM(self.deleteAddressRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDDeleteAddressIFCode],CodeKey,
                                    DDDeleteAddressIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    NSLog(@"%@",ifParam);
    
    self.deleteAddressRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.deleteAddressRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end