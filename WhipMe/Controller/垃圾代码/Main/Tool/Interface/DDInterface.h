//
//  DDInterface.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/24.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceConstant.h"
#import "DDInterfaceTool.h"

@protocol DDInterfaceDelegate;

/**
 *  接口层
 */
@interface DDInterface : NSObject

@property (nonatomic, weak) id<DDInterfaceDelegate>                                  delegate;                          /**< 代理 */

/**
 *  初始化
 *
 *  @param delegate 代理
 *
 *  @return 接口层实例
 */
- (instancetype)initWithDelegate:(id<DDInterfaceDelegate>)delegate;

/**
 *  获得接口层实例
 *
 *  @param delegate 代理
 *
 *  @return 接口层实例
 */
+ (instancetype)interfaceWithDelegate:(id<DDInterfaceDelegate>)delegate;

/**
 *  接口请求
 *
 *  @param type  接口类型
 *  @param param 参数字典
 */
- (void)interfaceWithType:(INTERFACE_TYPE)type param:(NSDictionary *)param;

@end

/**
 *  接口层代理
 */
@protocol DDInterfaceDelegate <NSObject>

@optional

/**
 *  接口数据返回
 *
 *  @param interface 接口实例
 *  @param result    结果字典
 *  @param error     错误信息 nil成功
 */
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error;

@end