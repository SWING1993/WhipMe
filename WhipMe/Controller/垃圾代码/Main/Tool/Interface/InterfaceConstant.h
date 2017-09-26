//
//  InterfaceConstant.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/7.
//  Copyright © 2016年 NS. All rights reserved.
//
//  接口层常量

#import <Foundation/Foundation.h>

#ifndef InterfaceConstant_h
#define InterfaceConstant_h

extern const NSInteger SuccessCode;                                                                                     /**< 成功业务码 */

#pragma mark Connect

extern const float HTTPTimeoutInterval;                                                                                 /**< HTTP请求延时 */

extern NSString *const HTTPBaseAdress;                                                                                  /**< HTTP基本请求地址 */
extern NSString *const ImageServerAddress;                                                                              /**< 图片服务器域名 */
extern NSString *const OtherServerAddress;                                                                              /**< 其他无服务器域名（例如图片上传等） */

extern const float SOCKETTimeoutInterval;                                                                               /**< SOCKET请求延时 */

#pragma mark Request Base Key

extern NSString *const CodeKey;                                                                                         /**< 业务码Key */
extern NSString *const VersionKey;                                                                                      /**< 版本号Key */
extern NSString *const MessageKey;                                                                                      /**< 返回信息Key */

#pragma mark UserDefaults

extern NSString *const UserKey;                                                                                         /**< UserKey */
extern NSString *const UserIDKey;                                                                                       /**< UserID Key */
extern NSString *const PhoneNumberKey;                                                                                  /**< 手机号 Key*/

#pragma mark ERROR

extern const NSInteger ErrorNoReachable;                                                                                /**< 没有连接网络 */
extern const NSInteger ErrorNetWorkError;                                                                               /**< 网络错误 */
extern const NSInteger ErrorHostDisConnect;                                                                             /**< 服务器断开连接 */

#pragma mark Other

extern NSString *const Md5Key;                                                                                          /**< 未登录前md5所用Key */

/**
 *  接口类型
 */
typedef NS_ENUM(NSInteger, INTERFACE_TYPE) {
    INTERFACE_TYPE_START                            = 0x000,                                                            /**< 开始 */
    INTERFACE_TYPE_LOGIN                            = 0x001,                                                            /**< 登录 */
    INTERFACE_TYPE_SEND_CAPTCHA                     = 0x002,                                                            /**< 发送验证码 */
    INTERFACE_TYPE_NEAR_COURIER                     = 0x003,                                                            /**< 附近快递员 */
    INTERFACE_TYPE_COMPANY_LIST                     = 0x004,                                                            /**< 快递公司列表 */
    INTERFACE_TYPE_SENDER_INFO                      = 0x005,                                                            /**< 寄件信息 */
    INTERFACE_TYPE_PACKAGE_LIST                     = 0x006,                                                            /**< 包裹列表 */
    INTERFACE_TYPE_ADD_ADDRESS                      = 0x007,                                                            /**< 增加地址 */
    INTERFACE_TYPE_ADDRESS_LIST                     = 0x008,                                                            /**< 地址列表 */
    INTERFACE_TYPE_MODIFY_ADDRESS                   = 0x009,                                                            /**< 修改地址 */
    INTERFACE_TYPE_DELETE_ADDRESS                   = 0x010,                                                            /**< 删除地址 */
    INTERFACE_TYPE_BUDGET_COST                      = 0x011,                                                            /**< 预估费用 */
    INTERFACE_TYPE_DETERMIN_ORDER                   = 0x012,                                                            /**< 确定订单 */
    INTERFACE_TYPE_ADD_ORDER                        = 0x013,                                                            /**< 追单    */
    INTERFACE_TYPE_CANCEL_ORDER                     = 0x014,                                                            /**< 取消订单 */
    INTERFACE_TYPE_EVALUATE_LIST                    = 0x015,                                                            /**< 评价列表 */
    INTERFACE_TYPE_PAY_MONEY                        = 0x016,                                                            /**< 支付费用（弃用） */
    INTERFACE_TYPE_SUBMIT_EVALUATE                  = 0x017,                                                            /**< 提交评价 */
    INTERFACE_TYPE_COST_DETAIL                      = 0x018,                                                            /**< 费用明细 */
    INTERFACE_TYPE_SUBMIT_COMPLAIN                  = 0x019,                                                            /**< 提交投诉 */
    INTERFACE_TYPE_ORDER_LIST                       = 0x020,                                                            /**< 订单列表 */
    INTERFACE_TYPE_DELETE_ORDER                     = 0x021,                                                            /**< 删除订单 */
    INTERFACE_TYPE_ORDER_DETAIL                     = 0x022,                                                            /**< 订单详情 */
    INTERFACE_TYPE_MY_WALLET                        = 0x023,                                                            /**< 我的钱包 */
    INTERFACE_TYPE_COIN_LIST                        = 0x024,                                                            /**< 我的嘟币（弃用） */
    INTERFACE_TYPE_MARKET_LIST                      = 0x025,                                                            /**< 嘟嘟商城（弃用） */
    INTERFACE_TYPE_EXCHANGE_COUPON                  = 0x026,                                                            /**< 兑换优惠券 */
    INTERFACE_TYPE_EXCHANGE_HISTORY                 = 0x027,                                                            /**< 兑换记录 */
    INTERFACE_TYPE_EXCHANGE_CODE                    = 0x028,                                                            /**< 兑换优惠码 */
    INTERFACE_TYPE_SELF_INFORMATION                 = 0x029,                                                            /**< 个人信息 */
    INTERFACE_TYPE_ALTER_INFORMATION                = 0x030,                                                            /**< 修改信息 */
    INTERFACE_TYPE_CERTIFY_IDENTITY                 = 0x031,                                                            /**< 身份认证 */
    INTERFACE_TYPE_CHANGE_PHONE                     = 0x032,                                                            /**< 更换手机 */
    INTERFACE_TYPE_NOTIFICATION_LIST                = 0x033,                                                            /**< 通知列表 */
    INTERFACE_TYPE_FEED_BACK                        = 0x034,                                                            /**< 意见反馈 */
    INTERFACE_TYPE_RECOMMEND_CONTENT                = 0x035,                                                            /**< 推荐内容（弃用） */
    INTERFACE_TYPE_PHONE_RECOMMEND                  = 0x036,                                                            /**< 手机推荐（弃用） */
    INTERFACE_TYPE_COUPON_LIST                      = 0x037,                                                            /**< 优惠券列表 */
    INTERFACE_TYPE_PRIZE_LIST                       = 0x038,                                                            /**< 奖励明细（弃用） */
    INTERFACE_TYPE_WAIT_COURIER                     = 0x039,                                                            /**< 等待快递员抢单 */
    INTERFACE_TYPE_LOGOUT                           = 0x040,                                                            /**< 退出登录 */
    INTERFACE_TYPE_PACKAGE_INFO                     = 0x041,                                                            /**< 包裹详情 */
    INTERFACE_TYPE_COURIIER_INFO                    = 0x042,                                                            /**< 快递员信息 */
    INTERFACE_TYPE_GOODS_TYPE_LIST                  = 0x043,                                                            /**< 物品类型列表 */
    INTERFACE_TYPE_CONFIRM_BIND                     = 0x044,                                                            /**< 确定收到监听 */
    INTERFACE_TYPE_BIND_PAY                         = 0x045,                                                            /**< 监听付款 */
    INTERFACE_TYPE_PRE_ORDER_LIST                   = 0x046,                                                            /**< 预处理订单列表 */
    INTERFACE_TYPE_STOP                             = 0x047,                                                            /**< 停止(程序进入后台是调用，断开网络) */
    INTERFACE_TYPE_NEED_POSITION                    = 0x048,                                                            /**< 需要快递员的实时位置 */
    INTERFACE_TYPE_BIND_POSITION                    = 0x049,                                                            /**< 监听快递员的实时位置 */
    INTERFACE_TYPE_LOGISTICS                        = 0x050,                                                            /**< 查询物流信息 */
    INTERFACE_TYPE_EXPRESS_LIST                     = 0x051,                                                            /**< 快递列表 */
    INTERFACE_TYPE_EXPRESS_INFO                     = 0x052,                                                            /**< 快递详情（弃用） */
    INTERFACE_TYPE_MODIFY_COMMENT                   = 0x053,                                                            /**< 修改包裹备注 */
    INTERFACE_TYPE_TOTAL_COMPANY                    = 0x054,                                                            /**< 所有快递公司 */
    INTERFACE_TYPE_EVALUATE_TAG                     = 0x055,                                                            /**< 评价标签列表 */
    INTERFACE_TYPE_YUE_INFOMSTION                   = 0x056,                                                            /**< 余额明细 */
    INTERFACE_TYPE_PAY_PARAM                        = 0x057,                                                            /**< 支付参数 */
    INTERFACE_TYPE_DELETE_EXPRESS_LIST              = 0x058,                                                            /**< 删除快递列表 */
    INTERFACE_TYPE_DELETE_NOTIFACTION               = 0x059,                                                            /**< 删除通知消息 */
    INTERFACE_TYPE_NEW_VERSION                      = 0x060,                                                            /**< 版本更新 */
    INTERFACE_TYPE_UPLOAD_IMAGE                     = 0x061,                                                            /**< 上传图片 */
    INTERFACE_TYPE_MAY_COMPANY                      = 0x062,                                                            /**< 可能的快递公司 */
    INTERFACE_TYPE_NOTIFICATION_NUM                 = 0x063,                                                            /**< 通知数量 */
    INTERFACE_TYPE_BIND_OTHER_LOGIN                 = 0x064,                                                            /**< 监听别处登录 */
    INTERFACE_TYPE_ACTIVITY_LIST                    = 0x065,                                                            /**< 活动列表 */
};


#endif /* InterfaceConstant_h */
