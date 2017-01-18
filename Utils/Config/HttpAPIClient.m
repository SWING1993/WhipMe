//
//  HttpAPIClient.m
//  TrueChoice
//
//  Created by anve on 16/10/18.
//  Copyright © 2016年 sely. All rights reserved.
//

#import "HttpAPIClient.h"

static NSString *const baseUrl = @"http://www.superspv.com";

@implementation HttpAPIClient

+ (void)APIClientPOST:(NSString *)method params:(NSDictionary *)param Success:(SuccessBlock)success Failed:(FailedBlock)failed {
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
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
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

+ (void)uploadImageWithMethod:(NSString *)method withImage:(UIImage *)image Success:(SuccessBlock)success Failed:(FailedBlock)failed {
    if (kStringIsEmpty(method)) {
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    //    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0;
    [manager.responseSerializer setAcceptableContentTypes:nil];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",baseUrl,method];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30];
    request.HTTPMethod = @"POST";
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *boundary = [NSString stringWithFormat:@"%f",interval];
    request.allHTTPHeaderFields = @{
                                    @"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]
                                    };
    // 请求体数据
    NSMutableData *postData = [[NSMutableData alloc]init];
    // 1.
    [postData appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    // 2.
    NSString *contentDisposition = @"Content-Disposition: form-data; name=fieldNameHer; filename=0000000000000.000\r\n";
    [postData appendData:[contentDisposition dataUsingEncoding:NSUTF8StringEncoding]];
    // 3.
    NSString *contentType =  @"Content-Type: application/octet-stream\r\n";
    [postData appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    // 4.
    NSData *imageData = UIImagePNGRepresentation(image);
    [postData appendData:imageData];
    NSLog(@"imageU=%@", imageData);
    // 5.
    NSString *endBoundary = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
    [postData appendData:[endBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"imageU2=%@",postData);
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:postData progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failed == nil ?: failed(error);
            
        } else {
            success == nil ?: success(responseObject);
        }
    }];
    [uploadTask resume];
    
    /*
     write(头边界的字节数组);
     write("Content-Disposition: form-data; name="fieldNameHer"; filename="0000000000000.000"\r\n"的字节数组);
     write("Content-Type: application/octet-stream\r\n"的字节数组);
     write(真正图片的字节数组);
     write(为边界的字节数组);
     */
}

- (void)multiPartPost:(NSDictionary *)dicData{
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.superspv.com/json_dispatch.rpc"];
    NSMutableString *bodyContent = [NSMutableString string];
    
    //POST_BOUNDS的值 = 系统时间戳;
    NSString *post_bounds = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]];
    for(NSString *key in dicData.allKeys) {
        id value = [dicData objectForKey:key];
        [bodyContent appendFormat:@"--%@\r\n",post_bounds];
        [bodyContent appendFormat:@"Content-Disposition: form-data;name=\"file\";filename=\"0000000000000.000\"\r\n"];
        [bodyContent appendFormat:@"Content-Type:application/octet-stream\r\n\r\n"];
        [bodyContent appendFormat:@"%@",value];
    }
    [bodyContent appendFormat:@"\r\n--%@--\r\n",post_bounds];
    
    NSData *bodyData=[bodyContent dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",post_bounds] forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%zd",bodyData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    
    NSLog(@"请求的长度%@",[NSString stringWithFormat:@"%zd",bodyData.length]);
    
    __autoreleasing NSError *error=nil;
    __autoreleasing NSURLResponse *response=nil;
    
    NSLog(@"输出Bdoy中的内容>>\n%@",[[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding]);
    NSData *reciveData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
//    [NSURLSession dataTaskWithRequest: completionHandler];
    if(error) {
        NSLog(@"出现异常%@",error);
    } else {
        NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
        if(httpResponse.statusCode==200) {
            NSLog(@"服务器成功响应!>>%@",[[NSString alloc]initWithData:reciveData encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"服务器返回失败>>%@",[[NSString alloc]initWithData:reciveData encoding:NSUTF8StringEncoding]);
        }
    }
}

@end
