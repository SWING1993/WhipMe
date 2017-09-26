//
//  DDLoginEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDLoginEntity.h"
#import "DDInterfaceTool.h"
#import "DDConnect.h"
#import "DDRequest.h"


#pragma mark Model Key

NSString *const DDLoginPhoneNumberM                             = @"phoneNumber";                                       /**< 手机号码 */
NSString *const DDLoginCheckNumberM                             = @"checkNumber";                                       /**< 验证码 */

NSString *const DDLoginUserIDM                                  = @"selfId";                                            /**< 用户IDKey */
NSString *const DDLoginAvatarM                                  = @"headIcon";                                          /**< 头像Key */
NSString *const DDLoginNameM                                    = @"name";                                              /**< 名字Key */
NSString *const DDLoginNickM                                    = @"nickName";                                          /**< 昵称Key */
NSString *const DDLoginEmailM                                   = @"emailAddress";                                      /**< 邮件Key */
NSString *const DDLoginBrithdayM                                = @"birthDay";                                          /**< 生日Key */
NSString *const DDLoginSexM                                     = @"sex";                                               /**< 性别Key */
NSString *const DDLoginJobM                                     = @"job";                                               /**< 工作Key */
NSString *const DDLoginAuthM                                    = @"idetify";                                           /**< 认证Key */
NSString *const DDLoginPhoneM                                   = @"phoneNumber";                                       /**< 手机号Key */

#pragma mark Interface Key

const NSInteger DDLoginLoginIFCode                              = 1000;                                                 /**< 登录接口业务码 */
NSString *const DDLoginLoginIFVersion                           = @"1.0.0";                                             /**< 登录接口版本号 */

NSString *const DDLoginPhoneIF                                  = @"phone";                                             /**< 手机号 Key */
NSString *const DDLoginCaptchaIF                                = @"captcha";                                           /**< 验证码 Key */
NSString *const DDLoginDeviceIdIF                               = @"devId";                                             /**< 设备标示ID Key */
NSString *const DDLoginDevTypeIF                                = @"devType";                                           /**< 设备类型 */

NSString *const DDLoginUserKeyIF                                = @"userKey";                                           /**< UserKey */
NSString *const DDLoginUserIdIF                                 = @"userId";                                            /**< UserIDKey */
NSString *const DDLoginAvatarIF                                 = @"avatar";                                            /**< 头像Key */
NSString *const DDLoginNameIF                                   = @"name";                                              /**< 名字Key */
NSString *const DDLoginNickIF                                   = @"nick";                                              /**< 昵称Key */
NSString *const DDLoginEmailIF                                  = @"email";                                             /**< 邮件Key */
NSString *const DDLoginBrithdayIF                               = @"birthday";                                          /**< 生日Key */
NSString *const DDLoginSexIF                                    = @"sex";                                               /**< 性别Key */
NSString *const DDLoginJobIF                                    = @"job";                                               /**< 工作Key */
NSString *const DDLoginAuthIF                                   = @"auth";                                              /**< 认证Key */


@interface DDLoginEntity ()<DDRequestDelegate, DDConnectDelegate>

@property (nonatomic, strong)   DDConnect                                           *connect;                           /**< 连接nss实例 */
@property (nonatomic, strong)   DDRequest                                           *loginRequest;                      /**< 登录请求实例 */

@property (nonatomic, strong)   NSString                                            *phoneNumber;                       /**< 手机号 */
@property (nonatomic, strong)   NSString                                            *captcha;                           /**< 验证码 */

@end

@implementation DDLoginEntity

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)entityWithParam:(NSDictionary *)param {
    //临时保存手机号和验证码
    NSString *phoneNumber   = [param objectForKey:DDLoginPhoneNumberM];
    NSString *captcha       = [param objectForKey:DDLoginCheckNumberM];
    self.phoneNumber        = phoneNumber;
    self.captcha            = captcha;
    
    self.connect = [[DDConnect alloc] initWithDelegate:self];
    [self.connect connect];
}

#pragma mark -
#pragma mark Private Methods

/**
 *  回调前面结果
 *
 *  @param result 结果字典
 *  @param error  错误信息
 */
- (void)sendResult:(NSDictionary *)result error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(entity:result:error:)]) {
        [self.delegate entity:self result:result error:error];
    }
}

/**
 *  登录
 */
- (void)login {
    self.loginRequest  = [[DDRequest alloc] initWithDelegate:self];
    
    NSNumber *code      = [NSNumber numberWithInteger:DDLoginLoginIFCode];
    NSString *version   = DDLoginLoginIFVersion;
    NSString *phone     = self.phoneNumber;
    NSString *captcha   = self.captcha;
    NSString *deviceID  = [DDInterfaceTool getUUIDString];
    NSNumber *devType   = [NSNumber numberWithInteger:1];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           code,                        CodeKey,
                           version,                     VersionKey,
                           phone,                       DDLoginPhoneIF,
                           captcha,                     DDLoginCaptchaIF,
                           deviceID,                    DDLoginDeviceIdIF,
                           devType,                     DDLoginDevTypeIF,
                           nil];
    
    [self.loginRequest socketRequstWithType:SOCKET_REQUEST_TYPE_LOGIN param:param];
}

/**
 *  获得Model所用字典
 *
 *  @param result 结果字典
 *
 *  @return model所用字典
 */
- (NSDictionary *)modleWithResult:(NSDictionary *)result {
//    NSString        *selfId         = [[result ddObjectForKey:DDLoginUserIdIF classType:CLASS_TYPE_NSSTRING] stringValue];
//    NSString        *headIcon       = [result ddObjectForKey:DDLoginAvatarIF classType:CLASS_TYPE_NSSTRING];
//    NSString        *name           = [result ddObjectForKey:DDLoginNameIF classType:CLASS_TYPE_NSSTRING];
//    NSString        *nickName       = [result ddObjectForKey:DDLoginNickIF classType:CLASS_TYPE_NSSTRING];
//    NSString        *emailAddress   = [result ddObjectForKey:DDLoginEmailIF classType:CLASS_TYPE_NSSTRING];
//    NSString        *birthDay       = [result ddObjectForKey:DDLoginBrithdayIF classType:CLASS_TYPE_NSSTRING];
//    NSString        *sex            = [result ddObjectForKey:DDLoginSexIF classType:CLASS_TYPE_NSSTRING];
//    NSString        *job            = [result ddObjectForKey:DDLoginJobIF classType:CLASS_TYPE_NSSTRING];
//    NSString        *idetify        = [result ddObjectForKey:DDLoginAuthIF classType:CLASS_TYPE_NSSTRING];
//    NSString        *phoneNum       = self.phoneNumber;
//    
//    NSDictionary    *modelDic       = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       selfId,          DDLoginUserIDM,
//                                       headIcon,        DDLoginAvatarM,
//                                       name,            DDLoginNameM,
//                                       nickName,        DDLoginNickM,
//                                       emailAddress,    DDLoginEmailM,
//                                       birthDay,        DDLoginBrithdayM,
//                                       sex,             DDLoginSexM,
//                                       job,             DDLoginJobM,
//                                       idetify,         DDLoginAuthM,
//                                       phoneNum,        DDLoginPhoneM,
//                                       nil];
//    return modelDic;
    return result;
}

/**
 *  登录成功保存信息
 *
 *  @param result 结果字典
 */
- (void)successSaveWithResult:(NSDictionary *)result {
    NSString *userKey   = [result ddObjectForKey:DDLoginUserKeyIF classType:CLASS_TYPE_NSSTRING];
    NSInteger userId    = [[result ddObjectForKey:DDLoginUserIdIF classType:CLASS_TYPE_NSNUMBER] integerValue];
    NSString *phone     = self.phoneNumber;
    
    [DDInterfaceTool configUserkey:userKey];
    [DDInterfaceTool configUserID:userId];
    [DDInterfaceTool configPhoneNumber:phone];
    [DDInterfaceTool configLoginSucced:YES];
}

#pragma mark -
#pragma mark DDRequestDelegate

- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error {
    if (![request isEqual:self.loginRequest]) return;
    
    if (error) {
        [self sendResult:nil error:error];
        return;
    }
    
    NSInteger    code       = [[result ddObjectForKey:CodeKey classType:CLASS_TYPE_NSNUMBER] integerValue];
    NSString    *message    = [result ddObjectForKey:MessageKey classType:CLASS_TYPE_NSSTRING];
    if (code != SuccessCode) {
        NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
        [self sendResult:nil error:error];
        return;
    }
    
    [self successSaveWithResult:result];
    [self sendResult:[self modleWithResult:result] error:nil];
}

#pragma mark -
#pragma mark DDConnectDelegate

- (void)connect:(DDConnect *)connect connnetStatus:(SOCKET_STATUS)status {
    if (![connect isEqual:self.connect]) return;
    
    if (SOCKET_STATUS_CONNECTED == status) [self login];
}

- (void)connect:(DDConnect *)connect connnetingStatus:(CONNECTING_STATUS)status {
    if (status == CONNECTING_STATUS_CONNECTING) {
        [self login];
    } else if (status == CONNECTING_STATUS_NOREACHABLE) {
        NSError *error = [NSError errorWithDomain:@"网络不可用" code:ErrorNoReachable userInfo:nil];
        [self sendResult:nil error:error];
    } else if (status == CONNECTING_STATUS_NOHOST) {
        NSError *error = [NSError errorWithDomain:@"网络错误" code:ErrorNetWorkError userInfo:nil];
        [self sendResult:nil error:error];
    } else if (status == CONNECTING_STATUS_TIMEOUT) {
        NSError *error = [NSError errorWithDomain:@"连接超时" code:ErrorNetWorkError userInfo:nil];
        [self sendResult:nil error:error];
    }
}

@end
