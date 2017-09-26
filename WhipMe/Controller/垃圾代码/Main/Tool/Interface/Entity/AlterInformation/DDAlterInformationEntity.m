//
//  DDAlterInformationEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDAlterInformationEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDAlterInformationIFCode                               = 1031;                                             /**< 修改信息业务码 */
NSString *const DDAlterInformationIFVersion                            = @"1.0.0";                                         /**< 修改信息版本号 */

@interface DDAlterInformationEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *alterInformationRequest;                              /**< 修改信息请求实例 */

@end

@implementation DDAlterInformationEntity

DDEntityHeadM(self.alterInformationRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDAlterInformationIFCode],CodeKey,
                                    DDAlterInformationIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.alterInformationRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.alterInformationRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end