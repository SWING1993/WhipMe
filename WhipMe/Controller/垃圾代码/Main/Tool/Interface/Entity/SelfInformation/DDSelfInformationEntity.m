//
//  DDSelfInformationEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDSelfInformationEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDSelfInformationIFCode                               = 1030;                                             /**< 个人信息业务码 */
NSString *const DDSelfInformationIFVersion                            = @"1.0.0";                                         /**< 个人信息版本号 */

@interface DDSelfInformationEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *SelfInformationRequest;                              /**< 个人信息请求实例 */

@end

@implementation DDSelfInformationEntity

DDEntityHeadM(self.SelfInformationRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDSelfInformationIFCode],CodeKey,
                                    DDSelfInformationIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.SelfInformationRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.SelfInformationRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end