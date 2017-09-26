//
//  DDLogoutEntity.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/18.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDEntityProtocol.h"
#import "InterfaceConstant.h"

/**
 *  退出登录
 */
@interface DDLogoutEntity : NSObject<DDEntityProtocol>

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
