//
//  DDPreOrderListEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPreOrderListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDPreOrderListIFCode                                      = 1044;                                       /**< 业务码 */
NSString *const DDPreOrderListIFVersion                                   = @"1.0.0";                                   /**< 版本号 */

@interface DDPreOrderListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *preOrderListRequest;                       /**< 预处理订单 */

@end

@implementation DDPreOrderListEntity

DDEntityHeadM(self.preOrderListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDPreOrderListIFCode],CodeKey,
                                    DDPreOrderListIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    
    self.preOrderListRequest  = [[DDRequest alloc] initWithDelegate:self];
    [self.preOrderListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
