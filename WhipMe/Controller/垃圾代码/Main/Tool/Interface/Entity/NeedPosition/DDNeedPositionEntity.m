//
//  DDNeedPositionEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/28.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDNeedPositionEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDNeedPositionIFCode                            = 1045;                                                 /**< 业务码 */
NSString *const DDNeedPositionIFVersion                         = @"1.0.0";                                             /**< 版本号 */

@interface DDNeedPositionEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *needPositionRequest;                           /**< 需要位置 */

@end

@implementation DDNeedPositionEntity

DDEntityHeadM(self.needPositionRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDNeedPositionIFCode]   ,CodeKey,
                                    DDNeedPositionIFVersion                             ,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    self.needPositionRequest  = [[DDRequest alloc] initWithDelegate:self];
    [self.needPositionRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
