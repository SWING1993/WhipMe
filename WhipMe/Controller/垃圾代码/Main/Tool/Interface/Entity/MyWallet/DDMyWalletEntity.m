//
//  DDMyWalletEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDMyWalletEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDMyWalletIFCode                               = 1024;                                             /**< 我的钱包业务码 */
NSString *const DDMyWalletIFVersion                            = @"1.0.0";                                         /**< 我的钱包版本号 */

@interface DDMyWalletEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *myWalletRequest;                              /**< 我的钱包请求实例 */

@end

@implementation DDMyWalletEntity

DDEntityHeadM(self.myWalletRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDMyWalletIFCode],CodeKey,
                                    DDMyWalletIFVersion,VersionKey,
                                    nil];
    
    //[ifParam addEntriesFromDictionary:param];
    
    self.myWalletRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.myWalletRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end