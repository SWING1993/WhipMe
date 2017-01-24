//
//  HttpAPIClient.h
//  TrueChoice
//
//  Created by anve on 16/10/18.
//  Copyright © 2016年 sely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "WMUploadFile.h"

typedef void (^SuccessBlock)(id result);
typedef void (^FailedBlock)(NSError *error);

@interface HttpAPIClient : NSObject

+ (void)APIClientPOST:(NSString *)method params:(NSDictionary *)param Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/** get请求 get_rul：地址， param：请求参数 */
+ (void)getAPIClient:(NSString *)get_rul param:(NSDictionary *)param Success:(SuccessBlock)success Failed:(FailedBlock)failed;

+ (void)APIWeChatToCode:(NSString *)code Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/** 上传头像 */
+ (void)uploadImageWithMethod:(NSString *)method withImage:(UIImage *)image Success:(SuccessBlock)success Failed:(FailedBlock)failed;

@end
