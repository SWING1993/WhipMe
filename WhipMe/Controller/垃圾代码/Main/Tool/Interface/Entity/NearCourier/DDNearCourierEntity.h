//
//  DDNearCourierEntity.h
//  DDExpressClient
//
//  Created by EWPSxx on 3/9/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDEntityProtocol.h"
#import "InterfaceConstant.h"

/**
 *  附近快递员实体
 */
@interface DDNearCourierEntity : NSObject<DDEntityProtocol>

@property (nonatomic, weak) id<DDEntityDelegate>                                     delegate;                          /**< 代理 */

/**
 *  初始化
 *
 *  @param delegate 代理
 *
 *  @return 登录实体层实例
 */
- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate;

@end
