//
//  DDInterfaceTool.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDInterfaceTool.h"

@interface DDInterfaceTool ()

@end

@implementation DDInterfaceTool

#pragma mark UserKey

+ (BOOL)configUserkey:(NSString *)userKey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userKey forKey:UserKey];
    
    return [userDefaults synchronize];
}

+ (NSString *)getUserkey {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userKey = [userDefaults stringForKey:UserKey];
    
    if ([userKey isEqualToString:@""]) return nil;
    return userKey;
}

#pragma mark UserId

+ (BOOL)configUserID:(NSInteger)userID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:userID forKey:UserIDKey];
    
    return [userDefaults synchronize];
}

+ (NSInteger)getUserID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger userID = [userDefaults integerForKey:UserIDKey];
    
    return userID;
}

#pragma mark PhoneNumber

+ (BOOL)configPhoneNumber:(NSString *)phoneNumer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:phoneNumer forKey:PhoneNumberKey];
    
    return [userDefaults synchronize];
}

+ (NSString *)getPhoneNumber {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [userDefaults stringForKey:PhoneNumberKey];
    
    if ([phoneNumber isEqualToString:@""]) return nil;
    return phoneNumber;
}

#pragma mark UUID

+ (NSString *)getUUIDString {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

#pragma mark Logined

static NSInteger loginSucced = NO;

+ (void)configLoginSucced:(BOOL)succed {
    loginSucced = succed;
}

+ (BOOL)getLoginSucced {
    return loginSucced;
}

#pragma mark stop

static bool stoped        = NO;

+ (void)configStop:(BOOL)stop {
    stoped = stop;
}

+ (BOOL)getStop {
   return stoped;
}

#pragma mark Company logo

+ (NSString *)logoWithCompanyId:(NSString *)companyId {
    NSString *logoUrl   = [NSString stringWithFormat:@"%@res/images/%@.png", ImageServerAddress, companyId];
    return logoUrl;
}

@end
