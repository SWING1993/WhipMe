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
    NSLog(@"____________param:%@",parameters);
    
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

+ (void)APIWeChatToCode:(NSString *)code Success:(SuccessBlock)success Failed:(FailedBlock)failed {
    NSString *url = @"https://api.weixin.qq.com";
   
    HKHttpSession *http = [[HKHttpSession alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSDictionary *param = @{@"appid":@"wxeb3bed2276716b91",
                            @"secret":@"66904ed59cbdeffff5410c6b2b447b0e",
                            @"code":code,
                            @"grant_type":@"authorization_code"};
    
    NSLog(@"_________param:%@",param);
    
    [http GET:@"/sns/oauth2/access_token" parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed == nil ?: failed(error);
    }];
}


@end
