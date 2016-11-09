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
    [[HKHttpSession shareSession].responseSerializer setAcceptableContentTypes:nil];
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
                            @"secret":@"afc0683ebda138c349a15ec93d5ade0c",
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

+ (void)uploadServletToHeader:(NSString *)header Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSString *host_url = @"/headUploadServlet";
    UIImage *img = [UIImage imageWithContentsOfFile:header];
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    NSString *imgName = header.lastPathComponent;
    
//    con.setRequestProperty("accept", "text/xml;text/html");
//    con.setRequestProperty("Content-Type", "text/xml;charset=utf-8");
    NSSet *content_type = [NSSet setWithObjects:@"text/xml",@"application/json", @"charset=utf-8", @"text/html", @"text/json", nil];
    [[HKHttpSession shareSession].responseSerializer setAcceptableContentTypes:content_type];
    [[HKHttpSession shareSession] POST:host_url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imgData name:@"file" fileName:imgName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        success == nil ?: success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed == nil ?: failed(error);
    }];
}

@end
