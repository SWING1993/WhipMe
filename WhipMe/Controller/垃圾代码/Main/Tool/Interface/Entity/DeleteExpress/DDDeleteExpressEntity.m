//
//  DDDeleteExpressEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/4/11.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDDeleteExpressEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDDeleteExpressIFCode                               = 1055;                                             /**< 业务码 */
NSString *const DDDeleteExpressIFVersion                            = @"1.0.0";                                         /**< 版本号 */

@interface DDDeleteExpressEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                           *deleteExpressRequest;                              /**< 删除快递列表 */

@end

@implementation DDDeleteExpressEntity

DDEntityHeadM(self.deleteExpressRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDDeleteExpressIFCode],CodeKey,
                                    DDDeleteExpressIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];

    self.deleteExpressRequest    = [[DDRequest alloc] initWithDelegate:self];
    [self.deleteExpressRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
