//
//  HttpAPIClient.m
//  TrueChoice
//
//  Created by anve on 16/10/18.
//  Copyright © 2016年 sely. All rights reserved.
//

#import "HttpAPIClient.h"

NSString *const kBaseUrl = @"http://www.superspv.com";

static NSInteger const kSecondsOut = 10;

@implementation HttpAPIClient

+ (void)APIClientPOST:(NSString *)method params:(NSDictionary *)param Success:(SuccessBlock)success Failed:(void (^)(NSError *error))failed {
    if (kStringIsEmpty(method)) {
        return;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:2];
    [parameters setObject:method forKey:@"method"];
    if (param) {
        [parameters setObject:param forKey:@"param"];
    }
    [HttpAPIClient APIClientParams:parameters Success:success Failed:failed];
}

+ (void)APIClientParams:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *host_url = @"/json_dispatch.rpc";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kSecondsOut;
    [manager.responseSerializer setAcceptableContentTypes:nil];
    [manager POST:host_url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failed == nil ?: failed(error);
    }];
}

+ (void)getAPIClient:(NSString *)get_rul param:(NSDictionary *)param Success:(SuccessBlock)success Failed:(FailedBlock)failed {
    if ([NSString isBlankString:get_rul]) {
        failed == nil ?: failed([NSError errorWithDomain:@"访问地址错误！" code:1001 userInfo:nil]);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = kSecondsOut;
    [manager.responseSerializer setAcceptableContentTypes:nil];
    
    [manager GET:get_rul parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success == nil ?: success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failed == nil ?: failed(error);
    }];
}

+ (void)APIWeChatToCode:(NSString *)code Success:(SuccessBlock)success Failed:(FailedBlock)failed {
    NSString *baseUrl = @"https://api.weixin.qq.com";
    NSString *url = @"/sns/oauth2/access_token";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager.responseSerializer setAcceptableContentTypes:nil];
    NSDictionary *param = @{
                            @"appid":[Define appIDWeChat],
                            @"secret":[Define appSecretWeChat],
                            @"code":code ?: @"",
                            @"grant_type":@"authorization_code"
                            };
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed == nil ?: failed(error);
    }];
}

@end
