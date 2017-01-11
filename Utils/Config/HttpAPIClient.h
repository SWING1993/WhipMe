//
//  HttpAPIClient.h
//  TrueChoice
//
//  Created by anve on 16/10/18.
//  Copyright © 2016年 sely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^SuccessBlock)(id result);
typedef void (^FailedBlock)(NSError *error);

@interface HttpAPIClient : NSObject

+ (void)APIClientPOST:(NSString *)method params:(NSDictionary *)param Success:(SuccessBlock)success Failed:(FailedBlock)failed;


+ (void)APIWeChatToCode:(NSString *)code Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/** 上传头像 */
+ (void)uploadServletToHeader:(NSString *)header Success:(SuccessBlock)success Failed:(FailedBlock)failed;

+ (void)uploadImageWithMethod:(NSString *)method withImage:(UIImage *)image Success:(SuccessBlock)success Failed:(FailedBlock)failed;
@end
