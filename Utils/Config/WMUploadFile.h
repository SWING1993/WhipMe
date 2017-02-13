//
//  WMUploadFile.h
//  WhipMe
//
//  Created by anve on 17/1/24.
//  Copyright © 2017年 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <Qiniu/QiniuSDK.h>

@class HttpAPIClient;
@interface WMUploadFile : NSObject

+ (void)upToData:(NSData *)data backInfo:(QNUpCompletionHandler)backInfo fail:(void (^)(NSError *error))fail;

+ (NSString *)isNeedRequestToGetDomain;

+ (NSString *)kImageBaseUrl:(NSString *)imgPath;

+ (void)removeQiniuUpKey;

@end
