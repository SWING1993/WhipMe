//
//  DDCourierInfoEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/22.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierInfoEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDCourierInfoIFCode                                     = 1041;                                         /**< 包裹信息业务码 */
NSString *const DDCourierInfoIFVersion                                  = @"1.0.0";                                     /**< 包裹信息版本号 */

@interface DDCourierInfoEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *courierInfoRequest;                            /**< 快递员信息 */

@end

@implementation DDCourierInfoEntity

DDEntityHeadM(self.courierInfoRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDCourierInfoIFCode],CodeKey,
                                    DDCourierInfoIFVersion,VersionKey,
                                    nil];
    
    [ifParam addEntriesFromDictionary:param];
    
    
    self.courierInfoRequest  = [[DDRequest alloc] initWithDelegate:self];
    [self.courierInfoRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
