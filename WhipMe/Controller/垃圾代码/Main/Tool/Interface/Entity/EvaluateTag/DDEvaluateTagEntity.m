//
//  DDEvaluateTagEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDEvaluateTagEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDEvaluateTagIFCode                                     = 1051;                                         /**< 业务码 */
NSString *const DDEvaluateTagIFVersion                                  = @"1.0.0";                                     /**< 版本号 */

@interface DDEvaluateTagEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *evaluateTagRequest;                            /**< 评价标签 */

@end

@implementation DDEvaluateTagEntity

DDEntityHeadM(self.evaluateTagRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDEvaluateTagIFCode],CodeKey,
                                    DDEvaluateTagIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];

    self.evaluateTagRequest      = [[DDRequest alloc] initWithDelegate:self];
    [self.evaluateTagRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
