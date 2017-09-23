//
//  DDLocalUserInfoUtils.h
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/23.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDLocalUserInfoUtils : NSObject

+ (void)setLocalUserInfo:(NSDictionary *)jsonDic;

+ (void)updateUserAutoLogin:(BOOL)autoLogin;

+ (NSString *)getUserName;
+ (void)updateUserName:(NSString *)userName;

+ (NSString *)getUserNickName;
+ (void)updateUserNickName:(NSString *)nickName;

+ (NSString *)getUserAvatar;
+ (void)updateUserAvatar:(NSString *)userAvatar;

+ (NSString *)getUserJob;
+ (void)updateUserJob:(NSString *)userJob;

+ (void)updateUserBirthday:(NSString *)birthday;
+ (NSString *)getUserBirthday;

+ (void)updateUserEmail:(NSString *)email;
+ (NSString *)getUserEmail;

+ (void)updateUserPhone:(NSString *)userPhone;
+ (NSString *)getUserPhone;

+ (void)updateUserSex:(NSString *)sex;
+ (NSString *)getUserSex;

+ (void)updateUserAuth:(NSString *)auth;
+ (NSString *)getUserAuth;

+ (void)updateUserId:(NSString *)userId;
+ (NSString *)getUserId;

+ (BOOL)userLoggedIn;

+ (void)removeLocalUserInfo;

+ (NSString *)getCardId;

+ (NSString *)getReason;
@end
