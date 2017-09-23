//
//  DDNetInstance.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "Pomelo.h"
#import "InterfaceConstant.h"

/**
 *  长连接连接情况
 */
typedef NS_ENUM(NSInteger, SOCKET_STATUS) {
    SOCKET_STATUS_DISCONNECT                    = 0x00,                                                                 /**< 长连接断开 */
    SOCKET_STATUS_CONNECTED                     = 0x01,                                                                 /**< 长连接连接中 */
};

/**
 *  网络单例
 */
@interface DDNetInstance : NSObject

@property (nonatomic, readonly) Pomelo                                      *pomelo;                                    /**< pomelo实例 */
@property (nonatomic, readonly) AFHTTPSessionManager                        *requestManager;                            /**< AFNetworking Manager */
@property (nonatomic, readonly) SOCKET_STATUS                                socketStatus;                              /**< 长连接连接状态 */

/**
 *  获得网络单例
 *
 *  @return 网络单例
 */
+ (instancetype)netInstance;

@end
