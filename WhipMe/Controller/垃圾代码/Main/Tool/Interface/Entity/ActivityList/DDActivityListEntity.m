//
//  DDActivityListEntity.m
//  DDExpressCourier
//
//  Created by EWPSxx on 16/4/5.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDActivityListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDActivityListIFCode                                        = 1059;                                     /**< 业务码 */
NSString *const DDActivityListIFVersion                                     = @"1.0.0";                                 /**< 版本号 */

@interface DDActivityListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *activityListRequest;                       /**< 活动列表 */

@end

@implementation DDActivityListEntity

DDEntityHeadM(self.activityListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSNumber    *code            = [NSNumber numberWithInteger:DDActivityListIFCode];
    NSString    *version         = DDActivityListIFVersion;

    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [ifParam setObject:code forKey:CodeKey];
    [ifParam setObject:version forKey:VersionKey];

    self.activityListRequest     = [[DDRequest alloc] initWithDelegate:self];
    [self.activityListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
