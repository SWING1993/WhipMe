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

@interface HKHttpSession : AFHTTPSessionManager

@end


@interface HttpAPIClient : NSObject

+ (HttpAPIClient *)shareSession;

- (void)APIClientPOST:(NSString *)method params:(NSDictionary *)param Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/** 1.1 发送短信验证码 */
+ (void)getVerificationCode:(NSString *)mobile Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/** 1.2 用户登陆 */
+ (void)loginUser:(NSString *)loginId code:(NSString *)aCode loginType:(NSString *)aType Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/** 1.3 用户第一次使用微信登录，设置用户昵称 */
+ (void)loginWeChat:(NSString *)userId nickname:(NSString *)aNickname Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/** 1.4 手机注册：第1步 */
+ (void)registerMobile:(NSString *)mobile code:(NSString *)aCode Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/** 1.5 注册：第2步 */
+ (void)registerUser:(NSString *)mobile icon:(NSString *)aIcon nickname:(NSString *)aNickname sex:(NSString *)aSex Success:(SuccessBlock)success Failed:(FailedBlock)failed;

@end
