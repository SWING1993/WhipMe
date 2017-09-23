//
//  LSJPush.h
//  LSJPush
//
//  Created by Steven.Liu on 15/9/17.
//  Copyright (c) 2015年 Steven.Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate+JPush.h"
#import "LSJPushSingleton.h"
#import "LSJPushProtocol.h"
#import "JPUSHService.h"
@interface LSJPush : NSObject<LSJPushProtocol>
HMSingletonH(LSJPush)


/** 注册JPush */
+(void)registerJPush:(NSDictionary *)launchOptions;


/** 添加监听者 */
+(void)addJPushListener:(id<LSJPushProtocol>)listener;

/** 移除监听者 */
+(void)removeJPushListener:(id<LSJPushProtocol>)listener;


/** 注册alias、tags */
+(void)setTags:(NSSet *)tags alias:(NSString *)alias resBlock:(void(^)(BOOL res, NSSet *tags,NSString *alias))resBlock;


@end
