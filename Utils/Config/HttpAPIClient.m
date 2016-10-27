//
//  HttpAPIClient.m
//  TrueChoice
//
//  Created by anve on 16/10/18.
//  Copyright © 2016年 sely. All rights reserved.
//

#import "HttpAPIClient.h"

//http://www.superspv.com/json_dispatch.rpc

static NSString *const baseUrl = @"http://www.superspv.com";

static HKHttpSession *httpSession = nil;
@implementation HKHttpSession

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer   = [AFJSONRequestSerializer serializer];
        self.responseSerializer  = [AFJSONResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = nil;
        
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [self.requestSerializer setTimeoutInterval:7.0];
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return self;
}

+ (HKHttpSession *)shareSession
{
    static dispatch_once_t _dispatch;
    dispatch_once(&_dispatch, ^{
        httpSession = [[HKHttpSession alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    });
    return httpSession;
}

@end

@implementation HttpAPIClient

+ (void)APIClientPOST:(NSString *)method params:(NSDictionary *)param Success:(SuccessBlock)success Failed:(FailedBlock)failed {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (![method isEqualToString:@""] && method != nil) {
        [parameters setObject:method forKey:@"method"];
    }
    if (param) {
        [parameters setObject:param forKey:@"param"];
    }
    
    [HttpAPIClient APIClientParams:parameters Success:success Failed:failed];
}

+ (void)APIClientParams:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSString *host_url = @"/json_dispatch.rpc";
    
    [[HKHttpSession shareSession] POST:host_url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed == nil ?: failed(error);
    }];
}

/**
 1.1 发送短信验证码
 "method":"sendCode",
 "param":{
 "mobile":"手机号"
 }
 */

+ (void)getVerificationCode:(NSString *)mobile Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"method":@"sendCode",@"param":@{@"mobile":mobile}};
    [HttpAPIClient APIClientParams:params Success:success Failed:failed];
}

/**
 1.2 用户登陆
 "method":"login",
 "param":{
 "loginId":"登录ID(手机登录传手机号，微信登录传openId)",
 "code":"手机验证码",
 "loginType":"登录方式(0:手机登陆   1:微信登录)"
 }
 */
+ (void)loginUser:(NSString *)loginId code:(NSString *)aCode loginType:(NSString *)aType Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSDictionary *parameters = @{@"method":@"login",@"param":@{@"loginId":loginId,@"code":aCode,@"loginType":aType}};
    [HttpAPIClient APIClientParams:parameters Success:success Failed:failed];
    
}

/**
 1.3 用户第一次使用微信登录，设置用户昵称
 "method":"addNickname",
 "param":{
 "userId":"21ee4c2266e74f3d812684a3538b20bf",
 "nickname":"用户昵称"
 }
 */
+ (void)loginWeChat:(NSString *)userId nickname:(NSString *)aNickname Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSDictionary *parameters = @{@"method":@"addNickname", @"param":@{@"userId":userId,@"nickname":aNickname}};
    [HttpAPIClient APIClientParams:parameters Success:success Failed:failed];
}
/**
 1.4 手机注册：第1步
 "method":"validateCode",
 "param":{
 "mobile":"15000000000",
 "code":"123456"
 }
 */
+ (void)registerMobile:(NSString *)mobile code:(NSString *)aCode Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSDictionary *parameters = @{@"method":@"validateCode", @"param":@{@"mobile":mobile,@"code":aCode}};
    [HttpAPIClient APIClientParams:parameters Success:success Failed:failed];
}
/**
 1.5 注册：第2步
 "method":"register",
 "param":{
 "mobile":"15000000000",
 "icon":"test.png",
 "nickname":"云淡风轻",
 "sex":"0",
 }
 */
+ (void)registerUser:(NSString *)mobile icon:(NSString *)aIcon nickname:(NSString *)aNickname sex:(NSString *)aSex Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSDictionary *parameters = @{@"method":@"register", @"param":@{@"mobile":mobile, @"icon":aIcon,@"nickname":aNickname,@"sex":aSex}};
    [HttpAPIClient APIClientParams:parameters Success:success Failed:failed];
}

@end
