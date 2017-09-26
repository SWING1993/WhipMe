//
//  DDModifyCommentEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDModifyCommentEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDModifyCommentIFCode                                   = 1049;                                         /**< 业务码 */
NSString *const DDModifyCommentIFVersion                                = @"1.0.0";                                     /**< 版本号 */

@interface DDModifyCommentEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *modifyCommentRequest;                      /**< 修改备注 */

@end

@implementation DDModifyCommentEntity

DDEntityHeadM(self.modifyCommentRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDModifyCommentIFCode],CodeKey,
                                    DDModifyCommentIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];

    self.modifyCommentRequest    = [[DDRequest alloc] initWithDelegate:self];
    [self.modifyCommentRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
