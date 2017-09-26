//
//  DDLocalUserInfoUtils.m
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/23.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDLocalUserInfoUtils.h"
#import "Constant.h"

@implementation DDLocalUserInfoUtils

+ (void)setLocalUserInfo:(NSDictionary *)jsonDic
{
    if (jsonDic && ![jsonDic isKindOfClass:[NSNull class]]) {
        [UserDefaults removeObjectForKey:@"localUserInfo"];
        
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithCapacity:10];
        [localUserInfo setObject:[jsonDic objectForKey:@"auth"] ?: @"" forKey:@"auth"];
        [localUserInfo setObject:[jsonDic objectForKey:@"userId"] ?: @"" forKey:@"userId"];
        [localUserInfo setObject:[jsonDic objectForKey:@"avatar"] ?: @"" forKey:@"avatar"];
        [localUserInfo setObject:[jsonDic objectForKey:@"birthday"] ?: @"" forKey:@"birthday"];
        [localUserInfo setObject:[jsonDic objectForKey:@"email"] ?: @"" forKey:@"email"];
        [localUserInfo setObject:[jsonDic objectForKey:@"job"] ?: @"" forKey:@"job"];
        [localUserInfo setObject:[jsonDic objectForKey:@"name"] ?: @"" forKey:@"name"];
        [localUserInfo setObject:[jsonDic objectForKey:@"phone"] ?: @"" forKey:@"phone"];
        [localUserInfo setObject:[jsonDic objectForKey:@"sex"] ?: @"" forKey:@"sex"];
        [localUserInfo setObject:[jsonDic objectForKey:@"userKey"] ?: @"" forKey:@"userKey"];
        [localUserInfo setObject:[jsonDic objectForKey:@"nick"] ?: @"" forKey:@"nick"];
        [localUserInfo setObject:[jsonDic objectForKey:@"card"] ?: @"" forKey:@"card"];
        [localUserInfo setObject:[jsonDic objectForKey:@"htel"] ?: @"" forKey:@"htel"];
        [localUserInfo setObject:[jsonDic objectForKey:@"reason"] ?: @"" forKey:@"reason"];
        [localUserInfo setObject:@(1) forKey:@"autoLogin"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}


+ (void)updateUserBirthday:(NSString *)birthday
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:birthday forKey:@"birthday"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserBirthday
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"name"] : nil;
}

+ (void)updateUserNickName:(NSString *)nickName
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:nickName forKey:@"nick"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserNickName
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"nick"] : nil;
}

+ (void)updateUserEmail:(NSString *)email
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:email forKey:@"email"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserEmail
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"email"] : nil;
}


+ (void)updateUserJob:(NSString *)userJob
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:userJob forKey:@"job"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserJob
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"job"] : nil;
}

+ (void)updateUserPhone:(NSString *)userPhone
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:userPhone forKey:@"phone"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserPhone
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"phone"] : nil;
}

+ (void)updateUserSex:(NSString *)sex
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:sex forKey:@"sex"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserSex
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"sex"] : nil;
}


+ (void)updateUserAutoLogin:(BOOL)autoLogin
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:@(autoLogin) forKey:@"autoLogin"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (BOOL)userIsAutoLogin
{
    if (LocalUserInfo) {
        return [[LocalUserInfo objectForKey:@"autoLogin"] boolValue];
    }
    
    return NO;
}

+ (void)updateUserName:(NSString *)userName
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:userName forKey:@"name"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserName
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"name"] : nil;
}

+ (void)updateUserAvatar:(NSString *)userAvatar
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:userAvatar forKey:@"avatar"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserAvatar
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"avatar"] : nil;
}

+ (void)updateUserAuth:(NSString *)auth
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:auth forKey:@"auth"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }
}

+ (NSString *)getUserAuth
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"auth"] : nil;
}

+ (NSString *)getUserId
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"userId"] : nil;
}

+ (void)updateUserId:(NSString *)userId
{
    if (LocalUserInfo) {
        NSMutableDictionary *localUserInfo = [[NSMutableDictionary alloc] initWithDictionary:LocalUserInfo];
        [localUserInfo setObject:userId forKey:@"userId"];
        
        [UserDefaults setObject:localUserInfo forKey:@"localUserInfo"];
        [UserDefaults synchronize];
    }

}

+ (BOOL)userLoggedIn
{
    if (LocalUserInfo && [LocalUserInfo objectForKey:@"userId"] && [LocalUserInfo objectForKey:@"autoLogin"] && [[LocalUserInfo objectForKey:@"autoLogin"] boolValue]) {
        return YES;
    }
    return NO;
}

+ (void)removeLocalUserInfo
{
    [UserDefaults removeObjectForKey:@"localUserInfo"];
    [UserDefaults synchronize];
}

+ (NSString *)getCardId
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"card"] : nil;
}

+ (NSString *)getReason
{
    return LocalUserInfo ? [LocalUserInfo objectForKey:@"reason"] : nil;
}

@end
