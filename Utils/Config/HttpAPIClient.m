//
//  HttpAPIClient.m
//  TrueChoice
//
//  Created by anve on 16/10/18.
//  Copyright © 2016年 sely. All rights reserved.
//

#import "HttpAPIClient.h"

static NSString *const baseUrl = @"http://www.superspv.com";

static HKHttpSession *httpSession = nil;
@implementation HKHttpSession

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer   = [AFJSONRequestSerializer serializer];
        self.responseSerializer  = [AFJSONResponseSerializer serializer];
        
        [self.responseSerializer setAcceptableContentTypes:nil];
        
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
//        [[PLeakSniffer sharedInstance] installLeakSniffer];
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
    DebugLog(@"______param:%@",parameters);
    
    [HttpAPIClient APIClientParams:parameters Success:success Failed:failed];
}

+ (void)APIClientParams:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *host_url = @"/json_dispatch.rpc";
    HKHttpSession *http = [[HKHttpSession shareSession] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    [http.responseSerializer setAcceptableContentTypes:nil];
    [http POST:host_url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        failed == nil ?: failed(error);
    }];
}

+ (void)APIWeChatToCode:(NSString *)code Success:(SuccessBlock)success Failed:(FailedBlock)failed {
    NSString *url = @"https://api.weixin.qq.com";
   
    HKHttpSession *http = [[HKHttpSession alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSDictionary *param = @{@"appid":[Define appIDWeChat],
                            @"secret":[Define appSecretWeChat],
                            @"code":code ?: @"",
                            @"grant_type":@"authorization_code"};
    
    [http GET:@"/sns/oauth2/access_token" parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed == nil ?: failed(error);
    }];
}

+ (void)uploadServletToHeader:(NSString *)header Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSString *host_url = @"/headUploadServlet";
    HKHttpSession *http = [[HKHttpSession shareSession] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    [http.responseSerializer setAcceptableContentTypes:nil];
//    http.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                         @"text/html",
//                                                         @"image/jpeg",
//                                                         @"image/png",
//                                                         @"application/octet-stream",
//                                                         @"text/json",
//                                                         nil];
    [http POST:host_url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *img = [UIImage imageWithContentsOfFile:header];
        NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
        NSString *imgName = header.lastPathComponent;
        
        [formData appendPartWithFileData:imgData name:@"image" fileName:imgName mimeType:@"image.jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed == nil ?: failed(error);
    }];
}

@end
