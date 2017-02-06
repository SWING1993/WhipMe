//
//  WMUploadFile.m
//  WhipMe
//
//  Created by anve on 17/1/24.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMUploadFile.h"
#import "HttpAPIClient.h"

/** upToken 七牛上传 token */
static NSString *const SG_QiniuUpToken = @"SG_QiniuUpToken";
static NSString *const SG_QiniuUpDomain = @"SG_QiniuUpDomain";
/** upToken 七牛上传 time */
static NSString *const SG_QiniuUpTokenTime = @"SG_QiniuUpTokenTime";

@implementation WMUploadFile


/**
 * 图片上传到七牛
 *  @param data     图片的data
 *  @param backInfo 上传完后的回调函数 info 上下文信息，包括状态码，错误值  key  上传时指定的key，原样返回 resp 上传成功会返回文件信息，失败为nil; 可以通过此值是否为nil 判断上传结果
 *  @param fail     失败
 */
+ (void)upToData:(NSData *)data backInfo:(QNUpCompletionHandler)backInfo fail:(FailedBlock)fail
{
    QNUploadOption *aQNUploadOption = nil;
    
    NSString *strUptoken = [WMUploadFile isNeedRequestToGetUptoken];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone2];
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    if ([strUptoken length] > 0) {
        [upManager putData:data key:[WMUploadFile getFileName] token:strUptoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (resp) {
                backInfo(info, key, resp);
            } else {
                fail(info.error);
            }
        } option:aQNUploadOption];
        
    } else {
        [WMUploadFile getUptoken:^(NSString *upToken) {
            [upManager putData:data key:[WMUploadFile getFileName] token:upToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (resp) {
                    backInfo(info, key, resp);
                } else {
                    fail(info.error);
                }
            } option:aQNUploadOption];
            
        } doLaterFail:^(NSError *error) {
            NSUserDefaults *useDefault = [NSUserDefaults standardUserDefaults];
            [useDefault removeObjectForKey:SG_QiniuUpToken];
            [useDefault removeObjectForKey:SG_QiniuUpTokenTime];
            [useDefault synchronize];
            fail(error);
        }];
    }
}

/** 图片的路径名 */
+ (NSString *)getFileName
{
    NSString *newUuidStr = [[[NSString generateUuidString] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"i/%@/%@/%@/%@",@(components.year),@(components.month),@(components.day),newUuidStr];
}

/** 请求上传七牛Uptoken */
+ (NSString *)isNeedRequestToGetUptoken
{
    NSString *strTime = [[NSUserDefaults standardUserDefaults] objectForKey:SG_QiniuUpTokenTime];
    if ([strTime length] > 0) {
        NSDate *dateNow = [NSDate date];
        NSDate *date    = [NSDate dateWithString:strTime format:@"YYYY-MM-dd HH:mm:ss"];
        
        if ([dateNow compare:date] == NSOrderedAscending) {
            NSString *strUpToken = [[NSUserDefaults standardUserDefaults] objectForKey:SG_QiniuUpToken];
            if ([strUpToken length] > 0) {
                return strUpToken;
            }
        }
    }
    return @"";
}

+ (NSString *)isNeedRequestToGetDomain {
    NSString *strUpToken = [[NSUserDefaults standardUserDefaults] objectForKey:SG_QiniuUpDomain];
    if ([strUpToken length] > 0) {
        return strUpToken;
    } else {
        [WMUploadFile getUptoken:^(NSString *upToken) {
            
        } doLaterFail:^(NSError *error) {
        }];
    }
    return @"";
}

+ (NSString *)kImageBaseUrl:(NSString *)imgPath {
    NSString *strBaseUrl = [WMUploadFile isNeedRequestToGetDomain];
    if ([NSString isBlankString:strBaseUrl] == NO) {
        return [NSString stringWithFormat:@"%@%@",strBaseUrl, imgPath];
    } else {
        return [NSString stringWithFormat:@"http://ok0tksr2d.bkt.clouddn.com/%@",imgPath];
    }
}

+ (void)getUptoken:(void (^ __nonnull) (NSString *upToken))doLaterSuccess doLaterFail:(FailedBlock)doLaterFaill
{
    NSDictionary *params = @{@"bucketName":@"btw-app"};
    [HttpAPIClient getAPIClient:@"/uploadTokenServlet" param:params Success:^(id result) {
        DebugLog(@"____result:%@",result);
        if (result[@"token"]) {
            NSString *domain = [NSString stringWithFormat:@"%@",result[@"domain"]];
            NSString *upToken = [NSString stringWithFormat:@"%@",result[@"token"]];
            NSDate   *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60];
            NSString *strDate = [NSDate stringWithDate:date format:@"YYYY-MM-dd HH:mm:ss"];
            
            NSUserDefaults *useDefault = [NSUserDefaults standardUserDefaults];
            [useDefault setValue:domain forKey:SG_QiniuUpDomain];
            [useDefault setValue:upToken forKey:SG_QiniuUpToken];
            [useDefault setValue:strDate forKey:SG_QiniuUpTokenTime];
            [useDefault synchronize];
            
            doLaterSuccess(upToken);
        } else {
            doLaterFaill(nil);
        }
    } Failed:^(NSError *error) {
        doLaterFaill(error);
    }];
}

@end
