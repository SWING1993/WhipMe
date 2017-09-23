//
//  InterfaceConstant.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "InterfaceConstant.h"

const NSInteger SuccessCode                     = 200;                                                                  /**< 成功业务码 */

#pragma mark Connect

const float HTTPTimeoutInterval                 = 20.0f;                                                                /**< HTTP请求延时 */

//正式地址
NSString *const HTTPBaseAdress                  = @"http://server.atxiaoge.com/actions/";                               /**< HTTP基本请求地址 */
NSString *const ImageServerAddress              = @"http://res.atxiaoge.com/";                                          /**< 图片服务器域名 */
NSString *const OtherServerAddress              = @"http://api.atxiaoge.com/";                                          /**< 其他无服务器域名（例如图片上传等） */

////测试地址
//NSString *const HTTPBaseAdress                  = @"http://test.server.atxiaoge.com/actions/";                          /**< HTTP基本请求地址 */
//NSString *const ImageServerAddress              = @"http://test.res.atxiaoge.com/";                                     /**< 图片服务器域名 */
//NSString *const OtherServerAddress              = @"http://test.api.atxiaoge.com/";                                     /**< 其他无服务器域名（例如图片上传等） */

const float SOCKETTimeoutInterval               = 20.0;                                                                 /**< SOCKET请求延时 */

#pragma mark Request Base Key

NSString *const CodeKey                         = @"code";                                                              /**< 业务码Key */
NSString *const VersionKey                      = @"ver";                                                               /**< 版本Key */
NSString *const MessageKey                      = @"msg";                                                               /**< 返回信息Key */

#pragma mark UserDefaults

NSString *const UserKey                         = @"userKey";                                                           /**< UserKey */
NSString *const UserIDKey                       = @"userID";                                                            /**< UserID Key */
NSString *const PhoneNumberKey                  = @"phoneNumber";                                                       /**< 手机号 Key*/

#pragma mark ERROR

const NSInteger ErrorNoReachable                = 2000;                                                                 /**< 没有连接网络 */
const NSInteger ErrorNetWorkError               = 2001;                                                                 /**< 网络错误 */
const NSInteger ErrorHostDisConnect             = 2002;                                                                 /**< 服务器断开连接 */

#pragma mark Other

NSString *const Md5Key                          = @"elpsycongrool64april30v";                                           /**< 默认MD5Key */