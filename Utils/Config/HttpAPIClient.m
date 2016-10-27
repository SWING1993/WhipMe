//
//  HttpAPIClient.m
//  TrueChoice
//
//  Created by anve on 16/10/18.
//  Copyright © 2016年 sely. All rights reserved.
//

#import "HttpAPIClient.h"

//http://www.superspv.com/json_dispatch.rpc

//static NSString *const baseUrl = @"http://www.superspv.com";

static HttpAPIClient *apiClient = nil;

@implementation HKHttpSession
- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
//        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//        [self.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        
        self.requestSerializer   = [AFHTTPRequestSerializer serializer];
        self.responseSerializer  = [AFJSONResponseSerializer serializer];
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [self.requestSerializer setTimeoutInterval:7.0];
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        self.responseSerializer.acceptableContentTypes =nil;
//        [NSSet setWithObject:@"text/html"];
        
        
//        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [self.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

@end

@implementation HttpAPIClient

+ (HttpAPIClient *)shareSession {
    static dispatch_once_t _dispatch;
    dispatch_once(&_dispatch, ^{
        apiClient = [HttpAPIClient new];
    });
    return apiClient;
}


- (void)APIClientPOST:(NSString *)method params:(NSDictionary *)param Success:(SuccessBlock)success Failed:(FailedBlock)failed {

    NSURL *baseUrl = [NSURL URLWithString:@"http://www.superspv.com"];
    NSString * url = @"/json_dispatch.rpc";

    HKHttpSession *session = [[HKHttpSession alloc] initWithBaseURL:baseUrl];

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:method forKey:@"method"];
    [parameters setObject:param forKey:@"param"];
//    parameters.
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    [session POST:url parameters:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed == nil ?: failed(error);
        NSLog(@"error = %@",error.userInfo);
    }];
}


///**
// 1.1 发送短信验证码
// "method":"sendCode",
// "param":{
// "mobile":"手机号"
// }
// */
//
//+ (void)getVerificationCode:(NSString *)mobile Success:(SuccessBlock)success Failed:(FailedBlock)failed
//{
//    NSDictionary *params = @{@"method":@"sendCode",@"param":@{@"mobile":mobile}};
//    [HttpAPIClient APIClientPOST:nil params:params Success:success Failed:failed];
//}
//
///**
// 1.2 用户登陆
// "method":"login",
// "param":{
// "loginId":"登录ID(手机登录传手机号，微信登录传openId)",
// "code":"手机验证码",
// "loginType":"登录方式(0:手机登陆   1:微信登录)"
// }
// */
//+ (void)loginUser:(NSString *)loginId code:(NSString *)aCode loginType:(NSString *)aType Success:(SuccessBlock)success Failed:(FailedBlock)failed
//{
//    NSDictionary *parameters = @{@"method":@"login",@"param":@{@"loginId":loginId,@"code":aCode,@"loginType":aType}};
//    DebugLog(@"1.2 用户登陆: %@",parameters);
//    [HttpAPIClient APIClientPOST:nil params:parameters Success:success Failed:failed];
//    
//}
//
///**
// 1.3 用户第一次使用微信登录，设置用户昵称
// "method":"addNickname",
// "param":{
// "userId":"21ee4c2266e74f3d812684a3538b20bf",
// "nickname":"用户昵称"
// }
// */
//+ (void)loginWeChat:(NSString *)userId nickname:(NSString *)aNickname Success:(SuccessBlock)success Failed:(FailedBlock)failed
//{
//    NSDictionary *parameters = @{@"method":@"addNickname", @"param":@{@"userId":userId,@"nickname":aNickname}};
//    DebugLog(@"1.3 用户第一次使用微信登录，设置用户昵称: %@",parameters);
//    [HttpAPIClient APIClientPOST:nil params:parameters Success:success Failed:failed];
//}
///**
// 1.4 手机注册：第1步
// "method":"validateCode",
// "param":{
// "mobile":"15000000000",
// "code":"123456"
// }
// */
//+ (void)registerMobile:(NSString *)mobile code:(NSString *)aCode Success:(SuccessBlock)success Failed:(FailedBlock)failed
//{
//    NSDictionary *parameters = @{@"method":@"validateCode", @"param":@{@"mobile":mobile,@"code":aCode}};
//    DebugLog(@"1.4 手机注册：第1步: %@",parameters);
//    [HttpAPIClient APIClientPOST:nil params:parameters Success:success Failed:failed];
//}
///**
// 1.5 注册：第2步
// "method":"register",
// "param":{
// "mobile":"15000000000",
// "icon":"test.png",
// "nickname":"云淡风轻",
// "sex":"0",
// }
// */
//+ (void)registerUser:(NSString *)mobile icon:(NSString *)aIcon nickname:(NSString *)aNickname sex:(NSString *)aSex Success:(SuccessBlock)success Failed:(FailedBlock)failed
//{
//    NSDictionary *parameters = @{@"method":@"register", @"param":@{@"mobile":mobile, @"icon":aIcon,@"nickname":aNickname,@"sex":aSex}};
//    DebugLog(@"1.5 注册：第2步: %@",parameters);
//    [HttpAPIClient APIClientPOST:nil params:parameters Success:success Failed:failed];
//}

@end
