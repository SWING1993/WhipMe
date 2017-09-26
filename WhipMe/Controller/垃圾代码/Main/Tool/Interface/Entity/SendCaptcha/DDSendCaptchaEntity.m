//
//  DDSendCaptchaEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDSendCaptchaEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

/**
 *  验证码类型
 */
typedef NS_ENUM(NSInteger, CAPTCHA_TYPE) {
    CAPTCHA_TYPE_LOGIN                                          = 0x00,                                                 /**< 登录 */
    CAPTCHA_TYPE_REGISTER                                       = 0x01,                                                 /**< 注册 */
    CAPTCHA_TYPE_FORGOT                                         = 0x02,                                                 /**< 忘记密码 */
    CAPTCHA_TYPE_MODIFY_PASSWORD                                = 0X03,                                                 /**< 修改密码 */
    CAPTCHA_TYPE_BIND_PHONE                                     = 0x04,                                                 /**< 绑定手机 */
};

/**
 *  发送验证码类型
 */
typedef NS_ENUM(NSInteger, SEND_CAPTCHA_TYPE) {
    SEND_CAPTCHA_TYPE_HTTP                                      = 0x00,                                                 /**< HTTP发送 */
    SEND_CAPTCHA_TYPE_SOCKET                                    = 0x01,                                                 /**< SOCKET发送 */

};

#pragma mark Model Key

NSString *const DDSendCaptchaPhoneM                             = @"phoneNumber";                                       /**< 手机号码 */
NSString *const DDSendCaptchaTypeM                              = @"type";                                              /**< 验证码类型 1登录 2注册 3忘记密码 4修改密码 5绑定手机 */

#pragma mark Interface Key

const NSInteger DDSendCaptchaHttpIFCode                         = 10001;                                                /**< http发送短信验证码业务码 */
NSString *const DDSendCaptchaHttpIFVersion                      = @"1.0.0";                                             /**< http发送短信验证码版本号 */

const NSInteger DDSendCaptchaSocketIFCode                       = 1002;                                                 /**< socket发送短信验证码业务码 */
NSString *const DDSendCaptchaSocketIFVersion                    = @"1.0.0";                                             /**< socket发送短信验证码版本号 */

NSString *const DDSendCaptchaPhoneIF                            = @"phone";                                             /**< 手机号 Key */
NSString *const DDSendCaptchaTypeIF                             = @"type";                                              /**< 验证码类型 Key */
NSString *const DDSendCaptchaDeviceIdIF                         = @"devId";                                             /**< 设备标示ID Key */

@interface DDSendCaptchaEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                       *httpCaptchaRequest;                    /**< http发送短信验证码实例 */
@property (nonatomic, strong)   DDRequest                                       *socketCaptchaRequest;                  /**< socket发送短信验证码实例 */

@property (nonatomic, strong)   NSString                                        *phoneNumber;                           /**< 手机号 */
@property (nonatomic, assign)   SEND_CAPTCHA_TYPE                                sendCaptchaType;                       /**< 发送验证码类型 */
@property (nonatomic, assign)   CAPTCHA_TYPE                                     captchaType;                           /**< 验证码类型 */

@end

@implementation DDSendCaptchaEntity

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
    NSString            *phone              = [param objectForKey:DDSendCaptchaPhoneM];
    NSInteger            typeInt            = [[param objectForKey:DDSendCaptchaTypeM] integerValue];
    CAPTCHA_TYPE         captchaType        = [self captchaTypeWithInt:typeInt];
    SEND_CAPTCHA_TYPE    sendCaptchaType    = [self sendCaptchaTypeWithCaptchaType:captchaType];
    
    self.phoneNumber                        = phone;
    self.captchaType                        = captchaType;
    self.sendCaptchaType                    = sendCaptchaType;
    
    [self sendCaptcha];
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
 *  获得验证码类型
 *
 *  @param type 验证码类型整型值
 *
 *  @return 验证码类型
 */
- (CAPTCHA_TYPE)captchaTypeWithInt:(NSInteger)type {
    CAPTCHA_TYPE    captchaType     = CAPTCHA_TYPE_LOGIN;
    
    switch (type) {
        case 1:
            captchaType             = CAPTCHA_TYPE_LOGIN;
            break;
            
        case 2:
            captchaType             = CAPTCHA_TYPE_REGISTER;
            break;
            
        case 3:
            captchaType             = CAPTCHA_TYPE_FORGOT;
            break;
            
        case 4:
            captchaType             = CAPTCHA_TYPE_MODIFY_PASSWORD;
            break;
            
        case 5:
            captchaType             = CAPTCHA_TYPE_BIND_PHONE;
            break;
            
        default:
            break;
    }
    
    return captchaType;
}

/**
 *  得到发送验证码类型
 *
 *  @param type 验证码类型
 *
 *  @return 发送验证码类型
 */
- (SEND_CAPTCHA_TYPE)sendCaptchaTypeWithCaptchaType:(CAPTCHA_TYPE)type {
    SEND_CAPTCHA_TYPE   sendCaptchaType     = SEND_CAPTCHA_TYPE_HTTP;
    
    switch (type) {
        case CAPTCHA_TYPE_LOGIN:
            sendCaptchaType                 = SEND_CAPTCHA_TYPE_HTTP;
            break;
            
        case CAPTCHA_TYPE_REGISTER:
            sendCaptchaType                 = SEND_CAPTCHA_TYPE_HTTP;
            break;
            
        case CAPTCHA_TYPE_FORGOT:
            sendCaptchaType                 = SEND_CAPTCHA_TYPE_HTTP;
            break;
            
        case CAPTCHA_TYPE_MODIFY_PASSWORD:
            sendCaptchaType                 = SEND_CAPTCHA_TYPE_SOCKET;
            break;
            
        case CAPTCHA_TYPE_BIND_PHONE:
            sendCaptchaType                 = SEND_CAPTCHA_TYPE_SOCKET;
            break;
            
        default:
            break;
    }
    
    return sendCaptchaType;
}

/**
 *  发送验证码
 */
- (void)sendCaptcha {
    NSString *phone     = self.phoneNumber;
    NSNumber *type      = [self getCaptchaType:self.captchaType];
    NSString *deviceID  = [DDInterfaceTool getUUIDString];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           phone,                       DDSendCaptchaPhoneIF,
                           type,                        DDSendCaptchaTypeIF,
                           deviceID,                    DDSendCaptchaDeviceIdIF,
                           nil];
    
    if (SEND_CAPTCHA_TYPE_HTTP == self.sendCaptchaType) {
        NSNumber *code      = [NSNumber numberWithInteger:DDSendCaptchaHttpIFCode];
        NSString *version   = DDSendCaptchaHttpIFVersion;
        [param setObject:code forKey:CodeKey];
        [param setObject:version forKey:VersionKey];
        
        self.httpCaptchaRequest = [[DDRequest alloc] initWithDelegate:self];
        [self.httpCaptchaRequest httpRequestWithType:HTTP_REQUEST_TYPE_SEND_CAPTCHA param:param];
    }
    
    if (SEND_CAPTCHA_TYPE_SOCKET == self.sendCaptchaType) {
        NSNumber *code      = [NSNumber numberWithInteger:DDSendCaptchaSocketIFCode];
        NSString *version   = DDSendCaptchaSocketIFVersion;
        [param setObject:code forKey:CodeKey];
        [param setObject:version forKey:VersionKey];
        
        self.socketCaptchaRequest = [[DDRequest alloc] initWithDelegate:self];
        [self.socketCaptchaRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:param];
    }
}

/**
 *  获得验证码接口类型
 *
 *  @param captchaType 验证码类型
 *
 *  @return 验证码接口类型
 */
- (NSNumber *)getCaptchaType:(CAPTCHA_TYPE)captchaType {
    NSInteger type                          = 1;
    switch (captchaType) {
        case CAPTCHA_TYPE_LOGIN:
            type                            = 1;
            break;
            
        case CAPTCHA_TYPE_REGISTER:
            type                            = 2;
            break;
            
        case CAPTCHA_TYPE_FORGOT:
            type                            = 3;
            break;
            
        case CAPTCHA_TYPE_MODIFY_PASSWORD:
            type                            = 1;
            break;
            
        case CAPTCHA_TYPE_BIND_PHONE:
            type                            = 2;
            break;
            
        default:
            break;
    }
    
    return [NSNumber numberWithInteger:type];
}

/**
 *  获得Model所用字典
 *
 *  @param result 结果字典
 *
 *  @return model所用字典
 */
- (NSDictionary *)modleWithResult:(NSDictionary *)result {
    NSDictionary    *modelDic       = [[NSDictionary alloc] init];
    return modelDic;
}

#pragma mark -
#pragma mark DDRequestDelegate

- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error {
    if ((![request isEqual:self.httpCaptchaRequest]) && (![request isEqual:self.socketCaptchaRequest])) return;
    
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
    
    [self sendResult:[self modleWithResult:result] error:nil];
}

@end
