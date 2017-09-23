//
//  LSJPush.m
//  LSJPush
//
//  Created by Steven.Liu on 15/9/17.
//  Copyright (c) 2015年 Steven.Liu. All rights reserved.
//

#import "LSJPush.h"
#import "JPUSHService.h"
#import <UIKit/UIKit.h>

#define JPushAppKey @"e1a4923b594b075aee669437"
#define JPushChannel @"AppStore"
#define JPushIsProduction NO

@interface LSJPush ()

@property (nonatomic,strong) NSMutableArray *listenerM;

@property (nonatomic,copy) void(^ResBlock)(BOOL res, NSSet *tags,NSString *alias);

@end



@implementation LSJPush
HMSingletonM(LSJPush)


/** 注册JPush */
+(void)registerJPush:(NSDictionary *)launchOptions{
    
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey channel:JPushChannel apsForProduction:JPushIsProduction];
    
}



/** 添加监听者 */
+(void)addJPushListener:(id<LSJPushProtocol>)listener{
    
    LSJPush *jpush = [LSJPush sharedLSJPush];
    
    if([jpush.listenerM containsObject:listener]) return;
    
    [jpush.listenerM addObject:listener];
}


/** 移除监听者 */
+(void)removeJPushListener:(id<LSJPushProtocol>)listener{
    
    LSJPush *jpush = [LSJPush sharedLSJPush];
    
    if(![jpush.listenerM containsObject:listener]) return;
    
    [jpush.listenerM removeObject:listener];
}


-(NSMutableArray *)listenerM{
    
    if(_listenerM==nil){
        _listenerM = [NSMutableArray array];
    }
    
    return _listenerM;
}


-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [self handleBadge:[userInfo[@"aps"][@"badge"] integerValue]];
    
    if(self.listenerM.count==0) return;
    
    [self.listenerM enumerateObjectsUsingBlock:^(id<LSJPushProtocol> listener, NSUInteger idx, BOOL *stop) {
        
        if([listener respondsToSelector:@selector(didReceiveRemoteNotification:)]) [listener didReceiveRemoteNotification:userInfo];
    }];
    
}



/** 处理badge */
-(void)handleBadge:(NSInteger)badge{
    
    NSInteger now = badge-1;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [UIApplication sharedApplication].applicationIconBadgeNumber=now;
    [JPUSHService setBadge:now];
}



+(void)setTags:(NSSet *)tags alias:(NSString *)alias resBlock:(void(^)(BOOL res, NSSet *tags,NSString *alias))resBlock{
    
    LSJPush *jpush = [LSJPush sharedLSJPush];

    [JPUSHService setTags:tags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:jpush];
    
    jpush.ResBlock=resBlock;
}


-(void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias{

    if(self.ResBlock != nil) self.ResBlock(iResCode==0,tags,alias);
}


@end
