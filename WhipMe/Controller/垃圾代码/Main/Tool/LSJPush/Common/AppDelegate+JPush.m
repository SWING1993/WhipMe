//
//  AppDelegate+JPush.m
//  LSJPush
//
//  Created by Steven.Liu on 15/9/17.
//  Copyright (c) 2015年 Steven.Liu. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "JPUSHService.h"
#import "LSJPush.h"

@implementation AppDelegate (JPush)


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    LSJPush *jpush = [LSJPush sharedLSJPush];
    [jpush didReceiveRemoteNotification:userInfo];
}


@end
