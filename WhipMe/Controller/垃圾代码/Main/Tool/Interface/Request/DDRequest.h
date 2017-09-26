//
//  DDRequest.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "InterfaceConstant.h"
#import "DDInterfaceTool.h"
#import "DDEncryption.h"

/**
 *  socket请求类型(主要区别不同权限字段情况)
 */
typedef NS_ENUM(NSInteger, SOCKET_REQUEST_TYPE) {
    SOCKET_REQUEST_TYPE_NORMAL                      = 0x00,                                                             /**< 普通请求 */
    SOCKET_REQUEST_TYPE_LOGIN                       = 0x01,                                                             /**< 登录请求 */
    SOCKET_REQUEST_TYPE_AUTOLOGIN                   = 0x02,                                                             /**< 自动登录请求 */
};

/**
 *  HTTP请求类型(主要区别不同的域名的情况)
 */
typedef NS_ENUM(NSInteger, HTTP_REQUEST_TYPE) {
    HTTP_REQUEST_TYPE_FIND_SERVER                   = 0x00,                                                             /**< 获取服务器地址 */
    HTTP_REQUEST_TYPE_SEND_CAPTCHA                  = 0x01,                                                             /**< 发送短信验证码 */
    HTTP_REQUEST_TYPE_AUTH_CAPTCHA                  = 0x02,                                                             /**< 验证短信验证码 */
    HTTP_REQUEST_TYPE_SIGN_UP                       = 0x03,                                                             /**< 注册 */
    HTTP_REQUEST_TYPE_FORGOT_PWD                    = 0x04,                                                             /**< 忘记密码 */
    HTTP_REQUEST_TYPE_NEAR_COURIER                  = 0x05,                                                             /**< 获取附近快递员 */
    HTTP_REQUEST_TYPE_NEW_VERSION                   = 0x06,                                                             /**< 版本更新 */
};

/**
 *  监听类型
 */
typedef NS_ENUM(NSInteger, BIND_TYPE) {
    BIND_TYPE_WAIT_RUSH                             = 0x00,                                                             /**< 抢单 */
    BIND_TYPE_BIND_PAY                              = 0x01,                                                             /**< 监听付款 */
    BIND_TYPE_BIND_POSITION                         = 0x02,                                                             /**< 监听快递员位置 */
    BIND_TYPE_OTHER_LOGIN                           = 0x03,                                                             /**< 监听别处登录 */
};

@protocol DDRequestDelegate;

/**
 *  请求层，封装网络请求部分
 */
@interface DDRequest : NSObject

@property (nonatomic, weak) id<DDRequestDelegate>                                    delegate;                          /**< 代理 */

/**
 *  初始化
 *
 *  @param delegate 代理
 *
 *  @return 请求实例
 */
- (instancetype)initWithDelegate:(id<DDRequestDelegate>)delegate;

/**
 *  http请求
 *
 *  @param type  请求类型
 *  @param param 请求字典
 */
- (void)httpRequestWithType:(HTTP_REQUEST_TYPE)type param:(NSDictionary *)param;

/**
 *  socket请求
 *
 *  @param type  请求类型
 *  @param param 请求字典
 */
- (void)socketRequstWithType:(SOCKET_REQUEST_TYPE)type param:(NSDictionary *)param;

/**
 *  socket通知(只是通知服务器，不会有回应)
 *
 *  @param type  通知类型
 *  @param param 通知字典
 */
- (void)sockeNotifytWithType:(SOCKET_REQUEST_TYPE)type param:(NSDictionary *)param;

/**
 *  绑定监听
 *
 *  @param type 监听类型
 *  @param on   YES 开始监听 NO 关闭监听
 */
- (void)socketBindWithType:(BIND_TYPE)type on:(BOOL)on;

@end


/**
 *  请求代理
 */
@protocol DDRequestDelegate <NSObject>

@optional

/**
 *  请求回应
 *
 *  @param request 请求对象
 *  @param result  结果字典
 *  @param error   错误信息 nil 成功
 */
- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error;

@end

/**
 *  socket请求类型(主要区别不同权限字段情况)
 */
typedef NS_ENUM(NSInteger, CLASS_TYPE) {
    CLASS_TYPE_NSSTRING                             = 0x00,                                                             /**< NSString类型 */
    CLASS_TYPE_NSNUMBER                             = 0x01,                                                             /**< NSNumber类型 */
    CLASS_TYPE_NSARRAY                              = 0x02,                                                             /**< NSSArray类型 */
    CLASS_TYPE_NSDICTIONARY                         = 0x03,                                                             /**< NSDictionay类型 */
};

@interface NSDictionary (Request)

/**
 *  嘟嘟对象
 *
 *  @param aKey key
 *
 *  @return 亿我拍的对象
 */
- (id)ddObjectForKey:(id)aKey classType:(CLASS_TYPE)classType;

@end