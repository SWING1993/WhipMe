//
//  DDConfirmBindEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/23.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDConfirmBindEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDConfirmBindIFCode                                     = 1043;                                         /**< 确认收到监听业务码 */
NSString *const DDConfirmBindIFVersion                                  = @"1.0.0";                                     /**< 确认收到监听版本号 */

@interface DDConfirmBindEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                       *confirmBindRequest;                    /**< 确认收到订单 */

@end

@implementation DDConfirmBindEntity

DDEntityHeadM(self.confirmBindRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDConfirmBindIFCode],CodeKey,
                                    DDConfirmBindIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    
    self.confirmBindRequest    = [[DDRequest alloc] initWithDelegate:self];
    [self.confirmBindRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
