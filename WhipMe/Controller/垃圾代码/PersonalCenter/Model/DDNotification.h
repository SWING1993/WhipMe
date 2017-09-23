//
//  DDNotification.h
//  DDExpressClient
//
//  Created by SongGang on 2/29/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  通知类型
 */
typedef NS_ENUM(NSInteger, NOTIFIACION_TYPE) {
    NOTIFIACION_TYPE_EXPRESS                            = 0x01,                                                         /**< 快递消息 */
    NOTIFIACION_TYPE_SYSTEM                             = 0x02,                                                         /**< 系统消息 */
    NOTIFIACION_TYPE_ACTIVE                             = 0x03,                                                         /**< 活动消息 */
};


/**
 *  通知模型
 */
@interface DDNotification : NSObject

@property (nonatomic, copy, readonly)       NSString                                    *messageId;                     /**< 消息ID */
@property (nonatomic, copy, readonly)       NSString                                    *title;                         /**< 标题 */
@property (nonatomic, copy, readonly)       NSString                                    *content;                       /**< 内容 */
@property (nonatomic, copy, readonly)       NSString                                    *time;                          /**< 时间 */
@property (nonatomic, assign, readonly)     NOTIFIACION_TYPE                             type;                          /**< 消息类型 */
@property (nonatomic, copy, readonly)       NSString                                    *activeUrl;                     /**< 活动URL */
@property (nonatomic, copy, readonly)       NSString                                    *expressNum;                    /**< 快递单号 */
@property (nonatomic, copy, readonly)       NSString                                    *companyId;                     /**< 快递公司ID */

/**
 *  初始化
 *
 *  @param dictionary 数据字典
 *
 *  @return 通知模型实体
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
