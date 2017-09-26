//
//  DDConnect.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceConstant.h"
#import "DDNetInstance.h"

/**
 *  连接错误类型
 */
typedef NS_ENUM(NSInteger, CONNECTING_STATUS) {
    CONNECTING_STATUS_CONNECTING                    = 0x00,                                                             /**< 正在连接中 */
    CONNECTING_STATUS_NOREACHABLE                   = 0x01,                                                             /**< 网络不可用 */
    CONNECTING_STATUS_NOHOST                        = 0x02,                                                             /**< 获取服务器地址失败 */
    CONNECTING_STATUS_TIMEOUT                       = 0x03,                                                             /**< 连接超时 */
};

@protocol DDConnectDelegate;

/**
 *  长连接连接管理
 */
@interface DDConnect : NSObject

@property (nonatomic, weak)     id<DDConnectDelegate>                        delegate;                                  /**< 代理 */
@property (nonatomic, readonly) CONNECTING_STATUS                            connectingStatus;                          /**< 连接服务器时状态 */
@property (nonatomic, readonly) SOCKET_STATUS                                socketStatus;                              /**< 长连接连接状态 */

/**
 *  初始化
 *
 *  @param delegate 代理
 *
 *  @return 长连接连接管理实例
 */
- (instancetype)initWithDelegate:(id<DDConnectDelegate>)delegate;

/**
 *  连接服务器
 */
- (void)connect;

/**
 *  断开与服务器的连接
 */
- (void)disConnnect;

@end


/**
 *  长连接连接管理代理
 */
@protocol DDConnectDelegate <NSObject>

@optional

/**
 *  连接服务器时的状态
 *
 *  @param connect 长连接管理实例
 *  @param status  连接服务器时的状态
 */
- (void)connect:(DDConnect *)connect connnetingStatus:(CONNECTING_STATUS)status;

/**
 *  长连接的连接状态改变
 *
 *  @param connect 长连接管理实例
 *  @param status  长连接连接状态
 */
- (void)connect:(DDConnect *)connect connnetStatus:(SOCKET_STATUS)status;

@end