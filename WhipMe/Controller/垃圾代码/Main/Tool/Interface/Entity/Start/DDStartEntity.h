//
//  DDStartEntity.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDEntityProtocol.h"
#import "InterfaceConstant.h"

@interface DDStartEntity : NSObject<DDEntityProtocol>

@property (nonatomic, weak) id<DDEntityDelegate>                                 delegate;                              /**< 代理 */

/**
 *  获得start单例
 *
 *  @param delegate 代理
 *
 *  @return start单例
 */
+ (instancetype)instanceWithDelegate:(id<DDEntityDelegate>)delegate;

/**
 *  初始化
 *
 *  @param delegate 代理
 *
 *  @return start实例
 */
- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate;

@end
