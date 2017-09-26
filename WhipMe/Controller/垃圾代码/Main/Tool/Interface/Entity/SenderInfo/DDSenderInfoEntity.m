//
//  DDSenderInfoEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/10.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDSenderInfoEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDSenderInfoIFCode                                      = 1005;                                         /**< 获取寄件信息业务码 */
NSString *const DDSenderInfoIFVersion                                   = @"1.0.0";                                     /**< 获取寄件信息版本号 */

@interface DDSenderInfoEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *sendInfoRequset;                           /**< 寄件信息 */

@end

@implementation DDSenderInfoEntity

DDEntityHeadM(self.sendInfoRequset);

- (void)entityWithParam:(NSDictionary *)param {
    self.sendInfoRequset = [[DDRequest alloc] initWithDelegate:self];
    NSNumber        *code           = [NSNumber numberWithInteger:DDSenderInfoIFCode];
    NSString        *version        = DDSenderInfoIFVersion;
    
    NSDictionary    *paramDic       = [NSDictionary dictionaryWithObjectsAndKeys:
                                       code,                CodeKey,
                                       version,             VersionKey,
                                       nil];
    
    [self.sendInfoRequset socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:paramDic];
}

@end
