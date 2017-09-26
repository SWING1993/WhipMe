//
//  DDSendCaptchaEntity.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDEntityProtocol.h"
#import "InterfaceConstant.h"

/**
 *  发送短信验证码接口
 */
@interface DDSendCaptchaEntity : NSObject<DDEntityProtocol>

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
