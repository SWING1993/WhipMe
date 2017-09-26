//
//  DDPhoneRecommendEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPhoneRecommendEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDPhoneRecommendIFCode                               = 1037;                                             /**< 手机号推荐业务码 */
NSString *const DDPhoneRecommendIFVersion                            = @"1.0.0";                                         /**< 手机号推荐版本号 */

@interface DDPhoneRecommendEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *phoneRecommendRequest;                              /**< 手机号推荐请求实例 */

@end

@implementation DDPhoneRecommendEntity

DDEntityHeadM(self.phoneRecommendRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDPhoneRecommendIFCode],CodeKey,
                                    DDPhoneRecommendIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.phoneRecommendRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.phoneRecommendRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end