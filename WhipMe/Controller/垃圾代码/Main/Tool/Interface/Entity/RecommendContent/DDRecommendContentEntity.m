//
//  DDRecommendContentEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDRecommendContentEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDRecommendContentIFCode                               = 1036;                                             /**< 推荐内容业务码 */
NSString *const DDRecommendContentIFVersion                            = @"1.0.0";                                         /**< 推荐内容版本号 */

@interface DDRecommendContentEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *recommendContentRequest;                              /**< 推荐内容请求实例 */

@end

@implementation DDRecommendContentEntity

DDEntityHeadM(self.recommendContentRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDRecommendContentIFCode],CodeKey,
                                    DDRecommendContentIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.recommendContentRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.recommendContentRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end