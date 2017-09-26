//
//  DDFeedBackEntity.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDFeedBackEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

#pragma mark Model Key

#pragma mark Interface Key

const NSInteger DDFeedBackIFCode                               = 1035;                                             /**< 意见反馈业务码 */
NSString *const DDFeedBackIFVersion                            = @"1.0.0";                                         /**< 意见反馈版本号 */

@interface DDFeedBackEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *feedBackRequest;                              /**< 意见反馈请求实例 */

@end

@implementation DDFeedBackEntity

DDEntityHeadM(self.feedBackRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDFeedBackIFCode],CodeKey,
                                    DDFeedBackIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.feedBackRequest   = [[DDRequest alloc] initWithDelegate:self];
    [self.feedBackRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end