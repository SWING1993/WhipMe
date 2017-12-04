//
//  HttpAPIClient.m
//  TrueChoice
//
//  Created by anve on 16/10/18.
//  Copyright © 2016年 sely. All rights reserved.
//

#import "HttpAPIClient.h"
#import <XHLaunchAd/XHLaunchAd.h>

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


+ (void)startIndexSuccess:(SuccessBlock)success Failed:(FailedBlock)failed {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://r.xdhedu.cn"]];
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer   = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer  = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    [manager POST:@"/indexs" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        id data = [result mj_JSONObject];
        DebugLog(@"success:%@",data);
        success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        DebugLog(@"error:%@",error);
        failed(error);
    }];
}

+ (void)setupXHLaunchAd {
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 3.5f;
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    NSString *urlStr = @"http://www.kayouxiang.com/q/images/adver.jpg";
    imageAdconfiguration.imageNameOrURLString = urlStr;
    //广告点击打开链接
    //    imageAdconfiguration.openURLString = [configM mj_JSONString];
    //allowReturn 添加跳过按钮
    //    imageAdconfiguration.customSkipView = [self customSkipViewAllowReturn:YES];
    
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    //缓存机制(仅对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageOnlyLoad;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}


@end
