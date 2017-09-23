//
//  DDSelfInfomation.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 NS. All rights reserved.
//

/**
    个人信息详情
 */

#import <Foundation/Foundation.h>

@interface DDSelfInfomation : NSObject

/** 姓名 */
@property (nonatomic ,copy) NSString *name;

/** ID号 */
@property (nonatomic ,copy) NSString *selfId;

/** 昵称 */
@property (nonatomic ,copy) NSString *nickName;

/** 邮箱 */
@property (nonatomic ,copy) NSString *emailAddress;

/** 电话号码 */
@property (nonatomic ,copy) NSString *phoneNumber;

/** 生日 */
@property (nonatomic ,copy) NSString *birthDay;

/** 性别 */
@property (nonatomic ,copy) NSString *sex;

/** 工作 */
@property (nonatomic ,copy) NSString *job;

/** 认证状态 0 待审核 1 审核中 2审核通过 3审核不通过 */
@property (nonatomic ,copy) NSString *idetify;

/**  身份证号  */
@property (nonatomic, strong) NSString *cardNumber;

/**  未通过认证的理由  */
@property (nonatomic, strong) NSString *unpassReason;

/** 头像 */
@property (nonatomic, copy) NSString *headIcon;

- (instancetype)initWithDict: (NSDictionary *)dict;

+ (instancetype)selfInfoWithDict: (NSDictionary *)dict;

@end
