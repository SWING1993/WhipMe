//
//  DDInterfaceTool.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceConstant.h"

@interface DDInterfaceTool : NSObject

#pragma mark UserKey

/**
 *  设置userKey
 *
 *  @param userKey userKey
 *
 *  @return YES 设置成功 NO 设置失败
 */
+ (BOOL)configUserkey:(NSString *)userKey;

/**
 *  获取userKey
 *
 *  @return userKey nil 没有userKey
 */
+ (NSString *)getUserkey;

#pragma mark UserId

/**
 *  设置userID
 *
 *  @param userID userID
 *
 *  @return YES 成功 NO 失败
 */
+ (BOOL)configUserID:(NSInteger)userID;

/**
 *  获取userID
 *
 *  @return userID 0 表示不存在
 */
+ (NSInteger)getUserID;

#pragma mark PhoneNumber

/**
 *  设置手机号
 *
 *  @param phoneNumer 手机号
 *
 *  @return YES 成功 NO 失败
 */
+ (BOOL)configPhoneNumber:(NSString *)phoneNumer;

/**
 *  获取手机号
 *
 *  @return 手机号
 */
+ (NSString *)getPhoneNumber;

#pragma mark UUID

/**
 *  获取设备唯一标识
 *
 *  @return UUID
 */
+ (NSString *)getUUIDString;

#pragma mark Logined

/**
 *  设置是否登录成功
 *
 *  @param succed 是否登录成功
 */
+ (void)configLoginSucced:(BOOL)succed;

/**
 *  获取是否登录成功
 *
 *  @return YES 登录成功 NO 登录失败
 */
+ (BOOL)getLoginSucced;

#pragma mark stop

/**
 *  设置停止状态
 *
 *  @param stop 是否停止
 *
 */
+ (void)configStop:(BOOL)stop;

/**
 *  获取停止状态
 *
 *  @return 停止状态
 */
+ (BOOL)getStop;

#pragma mark Company logo

/**
 *  获得快递公司logo地址
 *
 *  @param companyId 快递公司ID
 *
 *  @return 快递公司logo地址
 */
+ (NSString *)logoWithCompanyId:(NSString *)companyId;

@end
