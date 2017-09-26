//
//  DDInterface.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/24.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDInterface.h"
#import "DDStartEntity.h"
#import "DDLoginEntity.h"
#import "DDSendCaptchaEntity.h"
#import "DDNearCourierEntity.h"
#import "DDCompanyListEntity.h"
#import "DDSenderInfoEntity.h"
#import "DDPackageListEntity.h"
#import "DDAddAddressEntity.h"
#import "DDAddressListEntity.h"
#import "DDModifyAddressEntity.h"
#import "DDDeleteAddressEntity.h"
#import "DDBudgetCostEntity.h"
#import "DDDeterminOrderEntity.h"
#import "DDAddOrderEntity.h"
#import "DDCancelOrderEntity.h"
#import "DDEvaluateListEntity.h"
#import "DDSubmitEvaluateEntity.h"
#import "DDPayMoneyEntity.h"
#import "DDSubmitComplainEntity.h"
#import "DDCostDetailEntity.h"
#import "DDOrderListEntity.h"
#import "DDDeleteOrderEntity.h"
#import "DDOrderDetailEntity.h"
#import "DDMyWalletEntity.h"
#import "DDCoinListEntity.h"
#import "DDMarketListEntity.h"
#import "DDExchangeCouponEntity.h"
#import "DDExchangeHistoryEntity.h"
#import "DDExchangeCodeEntity.h"
#import "DDSelfInformationEntity.h"
#import "DDAlterInformationEntity.h"
#import "DDCertifyIdentityEntity.h"
#import "DDChangePhoneEntity.h"
#import "DDNotificationListEntity.h"
#import "DDFeedBackEntity.h"
#import "DDRecommendContentEntity.h"
#import "DDPhoneRecommendEntity.h"
#import "DDCouponListEntity.h"
#import "DDPrizeListEntity.h"
#import "DDWaitCourierEntity.h"
#import "DDLogoutEntity.h"
#import "DDPackageInfoEntity.h"
#import "DDCourierInfoEntity.h"
#import "DDGoodsTypeListEntity.h"
#import "DDConfirmBindEntity.h"
#import "DDBindPayEntity.h"
#import "DDPreOrderListEntity.h"
#import "DDStopEntity.h"
#import "DDNeedPositionEntity.h"
#import "DDBindPositionEntity.h"
#import "DDLogisticsEntity.h"
#import "DDExpressListEntity.h"
#import "DDExpressInfomationEntity.h"
#import "DDModifyCommentEntity.h"
#import "DDTotalCompanyEntity.h"
#import "DDEvaluateTagEntity.h"
#import "DDYueInfomationEntity.h"
#import "DDPayParamEntity.h"
#import "DDDeleteExpressEntity.h"
#import "DDDeleteNotifactionEntity.h"
#import "DDNewVersionEntity.h"
#import "DDUploadImageEntity.h"
#import "DDMayCompanyEntity.h"
#import "DDNotificationNumEntity.h"
#import "DDBindOtherLoginEntity.h"
#import "DDActivityListEntity.h"

@interface DDInterface ()<DDEntityDelegate>

@property (nonatomic, assign) INTERFACE_TYPE                                 type;                                      /**< 临时存储type */

@property (nonatomic, strong) DDStartEntity                                 *startEntity;                               /**< 开始实体实例 */
@property (nonatomic, strong) DDLoginEntity                                 *loginEntity;                               /**< 登录实体实例 */
@property (nonatomic, strong) DDSendCaptchaEntity                           *sendCaptchaEntity;                         /**< 发送验证码实体实例 */
@property (nonatomic, strong) DDNearCourierEntity                           *neatCourierEntity;                         /**< 附近快递员实体实例 */
@property (nonatomic, strong) DDCompanyListEntity                           *companyListEntity;                         /**< 快递公司列表实体实例 */
@property (nonatomic, strong) DDSenderInfoEntity                            *senderInfoEntity;                          /**< 寄件信息实体实例 */
@property (nonatomic, strong) DDPackageListEntity                           *packageLsitEntity;                         /**< 包裹列表实体实例 */
@property (nonatomic, strong) DDAddAddressEntity                            *addAddressEntity;                          /**< 增加地址实体实例 */
@property (nonatomic, strong) DDAddressListEntity                           *addressListEntity;                         /**< 地址列表实体实例 */
@property (nonatomic, strong) DDModifyAddressEntity                         *modifyAddressEntity;                       /**< 修改地址实体实例 */
@property (nonatomic, strong) DDDeleteAddressEntity                         *deleteAddressEntity;                       /**< 删除地址实体实例 */
@property (nonatomic, strong) DDBudgetCostEntity                            *budgetCostEntity;                          /**< 预估费用实体实例 */
@property (nonatomic, strong) DDDeterminOrderEntity                         *determinOrderEntity;                       /**< 确定订单实体实例 */
@property (nonatomic, strong) DDAddOrderEntity                              *addOrderEntity;                            /**< 追加订单实体实例 */
@property (nonatomic, strong) DDCancelOrderEntity                           *cancelOrderEntity;                         /**< 删除订单实体实例 */
@property (nonatomic, strong) DDEvaluateListEntity                          *evaluateListEntity;                        /**< 评价列表实体实例 */
@property (nonatomic, strong) DDPayMoneyEntity                              *payMoneyEntity;                            /**< 支付费用实体实例 */
@property (nonatomic, strong) DDSubmitEvaluateEntity                        *submitEvaluateEntity;                      /**< 提交评价实体实例 */
@property (nonatomic, strong) DDCostDetailEntity                            *costDetailEntity;                          /**< 费用详情实体实例 */
@property (nonatomic, strong) DDSubmitComplainEntity                        *submitComplainEntity;                      /**< 投诉信息实体实例 */
@property (nonatomic, strong) DDOrderListEntity                             *orderListEntity;                           /**< 订单列表实体实例 */
@property (nonatomic, strong) DDDeleteOrderEntity                           *deleteOrderEntity;                         /**< 删除订单实体实例 */
@property (nonatomic, strong) DDOrderDetailEntity                           *orderDetailEntity;                         /**< 订单详情实体实例 */
@property (nonatomic, strong) DDMyWalletEntity                              *myWalletEntity;                            /**< 我的钱包实体实例 */
@property (nonatomic, strong) DDCoinListEntity                              *coinListEntity;                            /**< 我的嘟币实体实例 */
@property (nonatomic, strong) DDMarketListEntity                            *marketListEntity;                          /**< 嘟嘟商城实体实例 */
@property (nonatomic, strong) DDExchangeCouponEntity                         *exchangeCouponEntity;                       /**< 兑换优惠券实体实例 */
@property (nonatomic, strong) DDExchangeHistoryEntity                       *exchangeHistoryEntity;                     /**< 兑换历史实体实例 */
@property (nonatomic, strong) DDExchangeCodeEntity                          *exchangeCodeEntity;                        /**< 兑换优惠码实体实例 */
@property (nonatomic, strong) DDSelfInformationEntity                       *selfInformationEntity;                     /**< 个人信息实体实例 */
@property (nonatomic, strong) DDAlterInformationEntity                      *alterInformationEntity;                    /**< 修改信息实体实例 */
@property (nonatomic, strong) DDCertifyIdentityEntity                       *certifyIdentityEntity;                     /**< 身份认证实体实例 */
@property (nonatomic, strong) DDChangePhoneEntity                           *changePhoneEntity;                         /**< 更换手机实体实例 */
@property (nonatomic, strong) DDNotificationListEntity                      *notificationListEntity;                    /**< 通知列表实体实例 */
@property (nonatomic, strong) DDFeedBackEntity                              *feedBackEntity;                            /**< 意见反馈实体实例 */
@property (nonatomic, strong) DDRecommendContentEntity                      *recommendContentEntity;                    /**< 推荐内容实体实例 */
@property (nonatomic, strong) DDPhoneRecommendEntity                        *phoneRecommendEntity;                      /**< 推荐手机实体实例 */
@property (nonatomic, strong) DDCouponListEntity                            *couponListEntity;                          /**< 优惠券列表实体实例 */
@property (nonatomic, strong) DDPrizeListEntity                             *prizeListEntity;                           /**< 奖励明细实体实例 */
@property (nonatomic, strong) DDWaitCourierEntity                           *waitCourierEntity;                         /**< 等待快递员抢单实体实例 */
@property (nonatomic, strong) DDLogoutEntity                                *logoutEntity;                              /**< 退出登录实体 */
@property (nonatomic, strong) DDPackageInfoEntity                           *packageInfoEntity;                         /**< 包裹详细信息实体实例 */
@property (nonatomic, strong) DDCourierInfoEntity                           *courierInfoEntity;                         /**< 快递员信息 */
@property (nonatomic, strong) DDGoodsTypeListEntity                         *goodsTypeListEntity;                       /**< 商品类型数组 */
@property (nonatomic, strong) DDConfirmBindEntity                           *confirmBindEntity;                         /**< 确定收到订单 */
@property (nonatomic, strong) DDBindPayEntity                               *bindPayEntity;                             /**< 监听付款 */
@property (nonatomic, strong) DDPreOrderListEntity                          *preOrderListEntity;                        /**< 预处理订单 */
@property (nonatomic, strong) DDStopEntity                                  *stopEntity;                                /**< 停止实体 */
@property (nonatomic, strong) DDNeedPositionEntity                          *needPositionEntity;                        /**< 需要实时位置 */
@property (nonatomic, strong) DDBindPositionEntity                          *bindPositionEntity;                        /**< 绑定监听快递员实时位置 */
@property (nonatomic, strong) DDLogisticsEntity                             *logisticsEntity;                           /**< 查询物流信息实体 */
@property (nonatomic, strong) DDExpressListEntity                           *expressListEntity;                         /**< 快递列表实体 */
@property (nonatomic, strong) DDExpressInfomationEntity                     *expressInfomationEntity;                   /**< 快递详情实体 */
@property (nonatomic, strong) DDModifyCommentEntity                         *modifyCommentEntity;                       /**< 修改包裹备注实体 */
@property (nonatomic, strong) DDTotalCompanyEntity                          *totalCompanyEntity;                        /**< 全部快递公司 */
@property (nonatomic, strong) DDEvaluateTagEntity                           *evaluateTagEntity;                         /**< 评价标签 */
@property (nonatomic, strong) DDYueInfomationEntity                         *yueInfomationEntity;                       /**< 余额明细 */
@property (nonatomic, strong) DDPayParamEntity                              *payParamEntity;                            /**< 支付参数 */
@property (nonatomic, strong) DDDeleteExpressEntity                         *deleteExpressEntity;                       /**< 删除快递列表 */
@property (nonatomic, strong) DDDeleteNotifactionEntity                     *deleteNotifactionEntity;                   /**< 删除消息通知 */
@property (nonatomic, strong) DDNewVersionEntity                            *neVersionEntity;                           /**< 版本更新 */
@property (nonatomic, strong) DDUploadImageEntity                           *uploadImageEntity;                         /**< 上传图片 */
@property (nonatomic, strong) DDMayCompanyEntity                            *mayCompanyEntity;                          /**< 可能的快递公司 */
@property (nonatomic, strong) DDNotificationNumEntity                       *notificationNumEntity;                     /**< 通知数量 */
@property (nonatomic, strong) DDBindOtherLoginEntity                        *bindOtherLoginEntity;                      /**< 别处登录 */
@property (nonatomic, strong) DDActivityListEntity                          *activityListEntity;                        /**< 活动列表 */

@end

@implementation DDInterface

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (instancetype)initWithDelegate:(id<DDInterfaceDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate   = delegate;
    }
    
    return self;
}

+ (instancetype)interfaceWithDelegate:(id<DDInterfaceDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate];
}

- (void)interfaceWithType:(INTERFACE_TYPE)type param:(NSDictionary *)param {
    self.type = type;
    
    switch (type) {
        case INTERFACE_TYPE_START:
            [self startWithParam:param];
            break;
            
        case INTERFACE_TYPE_LOGIN:
            [self loginWithParam:param];
            break;
            
        case INTERFACE_TYPE_SEND_CAPTCHA:
            [self sendCaptchaWithParam:param];
            break;
            
        case INTERFACE_TYPE_NEAR_COURIER:
            [self nearCourierWithParam:param];
            break;
            
        case INTERFACE_TYPE_COMPANY_LIST:
            [self companyListWithParam:param];
            break;
            
        case INTERFACE_TYPE_SENDER_INFO:
            [self senderInfoWithParam:param];
            break;
            
        case INTERFACE_TYPE_PACKAGE_LIST:
            [self packageListWithParam:param];
            break;
            
        case INTERFACE_TYPE_ADD_ADDRESS:
            [self addAddressWithParam:param];
            break;
            
        case INTERFACE_TYPE_ADDRESS_LIST:
            [self addressListWithPara:param];
            break;
            
        case INTERFACE_TYPE_MODIFY_ADDRESS:
            [self modifyAddressWithParam:param];
            break;
            
        case INTERFACE_TYPE_DELETE_ADDRESS:
            [self deleteAddressWithParam:param];
            break;
        case INTERFACE_TYPE_BUDGET_COST:
            [self budgetCostWithParam:param];
            break;
            
        case INTERFACE_TYPE_DETERMIN_ORDER:
            [self determinOrderWithParam:param];
            break;
            
        case INTERFACE_TYPE_ADD_ORDER:
            [self addOrderWithParam:param];
            break;
            
        case INTERFACE_TYPE_CANCEL_ORDER:
            [self cancelOrderWithParam:param];
            break;
            
        case INTERFACE_TYPE_EVALUATE_LIST:
            [self evaluateListWithParam:param];
            break;
            
        case INTERFACE_TYPE_PAY_MONEY:
            //[self payMoneyWithParam:param];
            break;
            
        case INTERFACE_TYPE_SUBMIT_EVALUATE:
            [self submitEvaluateWithParam:param];
            break;
            
        case INTERFACE_TYPE_COST_DETAIL:
            [self costDetailWithParam:param];
            break;
            
        case INTERFACE_TYPE_SUBMIT_COMPLAIN:
            [self submitComplainWithParam:param];
            break;
            
        case INTERFACE_TYPE_ORDER_LIST:
            [self orderListWithParam:param];
            break;
            
        case INTERFACE_TYPE_DELETE_ORDER:
            [self deleteOrderWithParam:param];
            break;
            
        case INTERFACE_TYPE_ORDER_DETAIL:
            [self orderDetailWithParam:param];
            break;
            
        case INTERFACE_TYPE_MY_WALLET:
            [self myWalletWithParam:param];
            break;
            
        case INTERFACE_TYPE_COIN_LIST:
            [self coinListWithParam:param];
            break;
            
        case INTERFACE_TYPE_MARKET_LIST:
            [self marketListWithParam:param];
            break;
            
        case INTERFACE_TYPE_EXCHANGE_COUPON:
            [self exchangeCouponWithParam:param];
            break;
            
        case INTERFACE_TYPE_EXCHANGE_HISTORY:
            [self exchangeHistoryWithParam:param];
            break;
            
        case INTERFACE_TYPE_EXCHANGE_CODE:
            [self exchangeCodeWithParam:param];
            break;
            
        case INTERFACE_TYPE_SELF_INFORMATION:
            [self selfInformationWithParam:param];
            break;
            
        case INTERFACE_TYPE_ALTER_INFORMATION:
            [self alterInformationWithParam:param];
            break;
            
        case INTERFACE_TYPE_CERTIFY_IDENTITY:
            [self certifyIdentityWithParam:param];
            break;
            
        case INTERFACE_TYPE_CHANGE_PHONE:
            [self changePhoneWithParam:param];
            break;
            
        case INTERFACE_TYPE_NOTIFICATION_LIST:
            [self notificationListWithParam:param];
            break;
            
        case INTERFACE_TYPE_FEED_BACK:
            [self feedBackWithParam:param];
            break;
            
        case INTERFACE_TYPE_RECOMMEND_CONTENT:
            [self recommendContentWithParam:param];
            break;
            
        case INTERFACE_TYPE_PHONE_RECOMMEND:
            [self phoneRecommendWithParam:param];
            break;
            
        case INTERFACE_TYPE_COUPON_LIST:
            [self couponListWithParam:param];
            break;
            
        case INTERFACE_TYPE_PRIZE_LIST:
            [self prizeListWithParam:param];
            break;
            
        case INTERFACE_TYPE_WAIT_COURIER:
            [self waitCourierWithParam:param];
            break;
            
        case INTERFACE_TYPE_LOGOUT:
            [self logoutWithParam:param];
            break;
            
        case INTERFACE_TYPE_PACKAGE_INFO:
            [self packageInfoWithParam:param];
            break;
            
        case INTERFACE_TYPE_COURIIER_INFO:
            [self courierInfoWithParam:param];
            break;
            
        case INTERFACE_TYPE_GOODS_TYPE_LIST:
            [self goodsTypeListWithParam:param];
            break;
            
        case INTERFACE_TYPE_CONFIRM_BIND:
            [self confirmBindWithParam:param];
            break;
            
        case INTERFACE_TYPE_BIND_PAY:
            [self bindPayWithParam:param];
            break;
            
        case INTERFACE_TYPE_PRE_ORDER_LIST:
            [self preOrderListWithParam:param];
            break;
            
        case INTERFACE_TYPE_STOP:
            [self stopWithParam:param];
            break;
            
        case INTERFACE_TYPE_NEED_POSITION:
            [self needPositionWithParam:param];
            break;
            
        case INTERFACE_TYPE_BIND_POSITION:
            [self bindPositionWithParam:param];
            break;
            
        case INTERFACE_TYPE_LOGISTICS:
            [self logisticsWithParam:param];
            break;
            
        case INTERFACE_TYPE_EXPRESS_LIST:
            [self expressListWithParam:param];
            break;
            
        case INTERFACE_TYPE_EXPRESS_INFO:
            [self expressInfoWithParam:param];
            break;
            
        case INTERFACE_TYPE_MODIFY_COMMENT:
            [self modifyCommentWithParam:param];
            break;
            
        case INTERFACE_TYPE_TOTAL_COMPANY:
            [self totalCompanyWithParam:param];
            break;
        
        case INTERFACE_TYPE_EVALUATE_TAG:
            [self evaluateTagWithParam:param];
            break;
            
        case INTERFACE_TYPE_YUE_INFOMSTION:
            [self yueInfomationWithParam:param];
            break;
            
        case INTERFACE_TYPE_PAY_PARAM:
            [self payParamWithParam:param];
            break;
        
        case INTERFACE_TYPE_DELETE_EXPRESS_LIST:
            [self deleteExpressWithParam:param];
            break;
            
        case INTERFACE_TYPE_DELETE_NOTIFACTION:
            [self deleteNotifactionWithParam:param];
            break;
        
        case INTERFACE_TYPE_NEW_VERSION:
            [self neVersionWithParam:param];
            break;
            
        case INTERFACE_TYPE_UPLOAD_IMAGE:
            [self uploadImageWithParam:param];
            break;
        
        case INTERFACE_TYPE_MAY_COMPANY:
            [self mayCompanyWithParam:param];
            break;
            
        case INTERFACE_TYPE_NOTIFICATION_NUM:
            [self notificationNumWithParam:param];
            break;
            
        case INTERFACE_TYPE_BIND_OTHER_LOGIN:
            [self bindOtherLoginWithParam:param];
            break;
            
        case INTERFACE_TYPE_ACTIVITY_LIST:
            [self activityListWithParam:param];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Private Methods

/**
 *  开始请求
 *
 *  @param param 请求参数
 */
- (void)startWithParam:(NSDictionary *)param {
    self.startEntity  = [DDStartEntity instanceWithDelegate:self];
    [self.startEntity entityWithParam:param];
}

/**
 *  登录请求
 *
 *  @param param 请求参数
 */
- (void)loginWithParam:(NSDictionary *)param {
    self.loginEntity = [[DDLoginEntity alloc] initWithDelegate:self];
    [self.loginEntity entityWithParam:param];
    
}

/**
 *  发送验证码请求
 *
 *  @param param 请求参数
 */
- (void)sendCaptchaWithParam:(NSDictionary *)param {
    self.sendCaptchaEntity  = [[DDSendCaptchaEntity alloc] initWithDelegate:self];
    [self.sendCaptchaEntity entityWithParam:param];
}

/**
 *  获取附近快递员请求
 *
 *  @param param 请求参数
 */
- (void)nearCourierWithParam:(NSDictionary *)param {
    self.neatCourierEntity = [[DDNearCourierEntity alloc] initWithDelegate:self];
    [self.neatCourierEntity entityWithParam:param];
}

/**
 *  获取快递公司列表
 *
 *  @param param 请求参数
 */
- (void)companyListWithParam:(NSDictionary *)param {
    self.companyListEntity = [[DDCompanyListEntity alloc] initWithDelegate:self];
    [self.companyListEntity entityWithParam:param];
}

/**
 *  寄件信息请求
 *
 *  @param param 请求参数
 */
- (void)senderInfoWithParam:(NSDictionary *)param {
    self.senderInfoEntity = [[DDSenderInfoEntity alloc] initWithDelegate:self];
    [self.senderInfoEntity entityWithParam:param];
}

/**
 *  包裹列表请求
 *
 *  @param param 请求参数
 */
- (void)packageListWithParam:(NSDictionary *)param {
    self.packageLsitEntity = [[DDPackageListEntity alloc] initWithDelegate:self];
    [self.packageLsitEntity entityWithParam:param];
}

/**
 *  增加地址请求
 *
 *  @param param 请求参数
 */
- (void)addAddressWithParam:(NSDictionary *)param {
    self.addAddressEntity = [[DDAddAddressEntity alloc] initWithDelegate:self];
    [self.addAddressEntity entityWithParam:param];
}

/**
 *  地址列表请求
 *
 *  @param param 请求参数
 */
- (void)addressListWithPara:(NSDictionary *)param {
    self.addressListEntity = [[DDAddressListEntity alloc] initWithDelegate:self];
    [self.addressListEntity entityWithParam:param];
}

/**
 *  修改地址请求
 *
 *  @param param 请求参数
 */
- (void)modifyAddressWithParam:(NSDictionary *)param {
    self.modifyAddressEntity = [[DDModifyAddressEntity alloc] initWithDelegate:self];
    [self.modifyAddressEntity entityWithParam:param];
}

- (void)deleteAddressWithParam:(NSDictionary *)param {
    self.deleteAddressEntity = [[DDDeleteAddressEntity alloc] initWithDelegate:self];
    [self.deleteAddressEntity entityWithParam:param];
}

/**
 *  预估费用请求
 *
 *  @param param 请求参数
 */
- (void)budgetCostWithParam:(NSDictionary *)param {
    self.budgetCostEntity = [[DDBudgetCostEntity alloc] initWithDelegate:self];
    [self.budgetCostEntity entityWithParam:param];
}

/**
 *  确认订单请求
 *
 *  @param param 请求参数
 */
- (void)determinOrderWithParam:(NSDictionary *)param {
    self.determinOrderEntity = [[DDDeterminOrderEntity alloc] initWithDelegate:self];
    [self.determinOrderEntity entityWithParam:param];
}

/**
 *  追加订单请求
 *
 *  @param param 请求参数
 */
- (void)addOrderWithParam:(NSDictionary *)param {
    self.addOrderEntity = [[DDAddOrderEntity alloc] initWithDelegate:self];
    [self.addOrderEntity entityWithParam:param];
}

/**
 *  取消订单请求
 *
 *  @param param 请求参数
 */
- (void)cancelOrderWithParam:(NSDictionary *)param {
    self.cancelOrderEntity = [[DDCancelOrderEntity alloc] initWithDelegate:self];
    [self.cancelOrderEntity entityWithParam:param];
}

/**
 *  评价列表请求
 *
 *  @param param 请求参数
 */
- (void)evaluateListWithParam:(NSDictionary *)param {
    self.evaluateListEntity = [[DDEvaluateListEntity alloc] initWithDelegate:self];
    [self.evaluateListEntity entityWithParam:param];
}

/**
 *  支付费用请求
 *
 *  @param param 请求参数
 */
//- (void)payMoneyWithParam:(NSDictionary *)param {
//    self.payMoneyEntity = [[DDPayMoneyEntity alloc] initWithDelegate:self];
//    [self.payMoneyEntity entityWithParam:param];
//}

/**
 *  提交评价请求
 *
 *  @param param 请求参数
 */
- (void)submitEvaluateWithParam:(NSDictionary *)param {
    self.submitEvaluateEntity = [[DDSubmitEvaluateEntity alloc] initWithDelegate:self];
    [self.submitEvaluateEntity entityWithParam:param];
}

/**
 *   费用详情请求
 *
 *  @param param 请求参数
 */
- (void)costDetailWithParam:(NSDictionary *)param {
    self.costDetailEntity = [[DDCostDetailEntity alloc] initWithDelegate:self];
    [self.costDetailEntity entityWithParam:param];
}

/**
 *  提交投诉请求
 *
 *  @param param 请求参数
 */
- (void)submitComplainWithParam:(NSDictionary *)param {
    self.submitComplainEntity = [[DDSubmitComplainEntity alloc] initWithDelegate:self];
    [self.submitComplainEntity entityWithParam:param];
}

/**
 *  订单列表请求
 *
 *  @param param 请求参数
 */
- (void)orderListWithParam:(NSDictionary *)param {
    self.orderListEntity = [[DDOrderListEntity alloc] initWithDelegate:self];
    [self.orderListEntity entityWithParam:param];
}

/**
 *  删除订单请求
 *
 *  @param param 请求参数
 */
- (void)deleteOrderWithParam:(NSDictionary *)param {
    self.deleteOrderEntity = [[DDDeleteOrderEntity alloc] initWithDelegate:self];
    [self.deleteOrderEntity entityWithParam:param];
}

/**
 *  订单详情请求
 *
 *  @param param 请求参数
 */
- (void)orderDetailWithParam:(NSDictionary *)param {
    self.orderDetailEntity = [[DDOrderDetailEntity alloc] initWithDelegate:self];
    [self.orderDetailEntity entityWithParam:param];
}

/**
 *  我的钱包请求
 *
 *  @param param 请求参数
 */
- (void)myWalletWithParam:(NSDictionary *)param {
    self.myWalletEntity = [[DDMyWalletEntity alloc] initWithDelegate:self];
    [self.myWalletEntity entityWithParam:param];
}

/**
 *  我的嘟币请求
 *
 *  @param param 请求参数
 */
- (void)coinListWithParam:(NSDictionary *)param {
    self.coinListEntity = [[DDCoinListEntity alloc] initWithDelegate:self];
    [self.coinListEntity entityWithParam:param];
}

/**
 *  嘟嘟商城请求
 *
 *  @param param 请求参数
 */
- (void)marketListWithParam:(NSDictionary *)param {
    self.marketListEntity = [[DDMarketListEntity alloc] initWithDelegate:self];
    [self.marketListEntity entityWithParam:param];
}

/**
 *  兑换优惠券请求
 *
 *  @param param 请求参数
 */
- (void)exchangeCouponWithParam:(NSDictionary *)param {
    self.exchangeCouponEntity = [[DDExchangeCouponEntity alloc] initWithDelegate:self];
    [self.exchangeCouponEntity entityWithParam:param];
}

/**
 *  兑换历史请求
 *
 *  @param param 请求参数
 */
- (void)exchangeHistoryWithParam:(NSDictionary *)param {
    self.exchangeHistoryEntity = [[DDExchangeHistoryEntity alloc] initWithDelegate:self];
    [self.exchangeHistoryEntity entityWithParam:param];
}

/**
 *  兑换优惠码请求
 *
 *  @param param 请求参数
 */
- (void)exchangeCodeWithParam:(NSDictionary *)param {
    self.exchangeCodeEntity = [[DDExchangeCodeEntity alloc] initWithDelegate:self];
    [self.exchangeCodeEntity entityWithParam:param];
}

/**
 *  个人信息请求
 *
 *  @param param 请求参数
 */
- (void)selfInformationWithParam:(NSDictionary *)param {
    self.selfInformationEntity = [[DDSelfInformationEntity alloc] initWithDelegate:self];
    [self.selfInformationEntity entityWithParam:param];
}

/**
 *  修改信息请求
 *
 *  @param param 请求参数
 */
- (void)alterInformationWithParam:(NSDictionary *)param {
    self.alterInformationEntity = [[DDAlterInformationEntity alloc] initWithDelegate:self];
    [self.alterInformationEntity entityWithParam:param];
}

/**
 *  身份认证请求
 *
 *  @param param 请求参数
 */
- (void)certifyIdentityWithParam:(NSDictionary *)param {
    self.certifyIdentityEntity = [[DDCertifyIdentityEntity alloc] initWithDelegate:self];
    [self.certifyIdentityEntity entityWithParam:param];
}

/**
 *  更换电话请求
 *
 *  @param param 请求参数
 */
- (void)changePhoneWithParam:(NSDictionary *)param {
    self.changePhoneEntity = [[DDChangePhoneEntity alloc] initWithDelegate:self];
    [self.changePhoneEntity entityWithParam:param];
}

/**
 *  通知列表请求
 *
 *  @param param 请求参数
 */
- (void)notificationListWithParam:(NSDictionary *)param {
    self.notificationListEntity = [[DDNotificationListEntity alloc] initWithDelegate:self];
    [self.notificationListEntity entityWithParam:param];
}

/**
 *  意见反馈请求
 *
 *  @param param 请求参数
 */
- (void)feedBackWithParam:(NSDictionary *)param {
    self.feedBackEntity = [[DDFeedBackEntity alloc] initWithDelegate:self];
    [self.feedBackEntity entityWithParam:param];
}

/**
 *  推荐内容请求
 *
 *  @param param 请求参数
 */
- (void)recommendContentWithParam:(NSDictionary *)param {
    self.recommendContentEntity = [[DDRecommendContentEntity alloc] initWithDelegate:self];
    [self.recommendContentEntity entityWithParam:param];
}

/**
 *  推荐电话请求
 *
 *  @param param 请求参数
 */
- (void)phoneRecommendWithParam:(NSDictionary *)param {
    self.phoneRecommendEntity = [[DDPhoneRecommendEntity alloc] initWithDelegate:self];
    [self.phoneRecommendEntity entityWithParam:param];
}

/**
 *  优惠券列表请求
 *
 *  @param param 请求参数
 */
- (void)couponListWithParam:(NSDictionary *)param {
    self.couponListEntity = [[DDCouponListEntity alloc] initWithDelegate:self];
    [self.couponListEntity entityWithParam:param];
}

/**
 *  奖励列表请求
 *
 *  @param param 请求参数
 */
- (void)prizeListWithParam:(NSDictionary *)param {
    self.prizeListEntity = [[DDPrizeListEntity alloc] initWithDelegate:self];
    [self.prizeListEntity entityWithParam:param];
}

/**
 *  等待快递员抢单
 *
 *  @param param 请求参数
 */
- (void)waitCourierWithParam:(NSDictionary *)param {
    self.waitCourierEntity  = [[DDWaitCourierEntity alloc] initWithDelegate:self];
    [self.waitCourierEntity entityWithParam:param];
}

/**
 *  退出登录实体
 *
 *  @param param 请求参数
 */
- (void)logoutWithParam:(NSDictionary *)param {
    self.logoutEntity   = [[DDLogoutEntity alloc] initWithDelegate:self];
    [self.logoutEntity entityWithParam:param];
}

/**
 *  包裹信息
 *
 *  @param param 请求参数
 */
- (void)packageInfoWithParam:(NSDictionary *)param {
    self.packageInfoEntity = [[DDPackageInfoEntity alloc] initWithDelegate:self];
    [self.packageInfoEntity entityWithParam:param];
}

/**
 *  快递员详情
 *
 *  @param param 请求字典
 */
- (void)courierInfoWithParam:(NSDictionary *)param {
    self.courierInfoEntity = [[DDCourierInfoEntity alloc] initWithDelegate:self];
    [self.courierInfoEntity entityWithParam:param];
}

/**
 *  商品类型数组
 *
 *  @param param 请求参数
 */
- (void)goodsTypeListWithParam:(NSDictionary *)param {
    self.goodsTypeListEntity = [[DDGoodsTypeListEntity alloc] initWithDelegate:self];
    [self.goodsTypeListEntity entityWithParam:param];
}

/**
 *  确认收到监听
 *
 *  @param param 请求参数
 */
- (void)confirmBindWithParam:(NSDictionary *)param {
    self.confirmBindEntity  = [[DDConfirmBindEntity alloc] initWithDelegate:self];
    [self.confirmBindEntity entityWithParam:param];
}

/**
 *  监听付款
 *
 *  @param param 请求参数
 */
- (void)bindPayWithParam:(NSDictionary *)param {
    self.bindPayEntity  = [[DDBindPayEntity alloc] initWithDelegate:self];
    [self.bindPayEntity entityWithParam:param];
}

/**
 *  预处理订单列表
 *
 *  @param param 请求参数
 */
- (void)preOrderListWithParam:(NSDictionary *)param {
    self.preOrderListEntity = [[DDPreOrderListEntity alloc] initWithDelegate:self];
    [self.preOrderListEntity entityWithParam:param];
}

/**
 *  停止
 *
 *  @param param 请求参数
 */
- (void)stopWithParam:(NSDictionary *)param {
    self.stopEntity = [[DDStopEntity alloc] initWithDelegate:self];
    [self.stopEntity entityWithParam:param];
}

/**
 *  需要位置
 *
 *  @param param 请求参数
 */
- (void)needPositionWithParam:(NSDictionary *)param {
    self.needPositionEntity = [[DDNeedPositionEntity alloc] initWithDelegate:self];
    [self.needPositionEntity entityWithParam:param];
}

/**
 *  监听快递员位置
 *
 *  @param param 请求参数
 */
- (void)bindPositionWithParam:(NSDictionary *)param {
    self.bindPositionEntity = [[DDBindPositionEntity alloc] initWithDelegate:self];
    [self.bindPositionEntity entityWithParam:param];
}

/**
 *  查询物流信息
 *
 *  @param param 请求参数
 */
- (void)logisticsWithParam:(NSDictionary *)param {
    self.logisticsEntity = [[DDLogisticsEntity alloc] initWithDelegate:self];
    [self.logisticsEntity entityWithParam:param];
}

/**
 *  快递列表
 *
 *  @param param 请求参数
 */
- (void)expressListWithParam:(NSDictionary *)param {
    self.expressListEntity = [[DDExpressListEntity alloc] initWithDelegate:self];
    [self.expressListEntity entityWithParam:param];
}

/**
 *  快递详情
 *
 *  @param param 请求参数
 */
- (void)expressInfoWithParam:(NSDictionary *)param {
    self.expressInfomationEntity = [[DDExpressInfomationEntity alloc] initWithDelegate:self];
    [self.expressInfomationEntity entityWithParam:param];
}

/**
 *  修改包裹备注
 *
 *  @param param 请求参数
 */
- (void)modifyCommentWithParam:(NSDictionary *)param {
    self.modifyCommentEntity    = [[DDModifyCommentEntity alloc] initWithDelegate:self];
    [self.modifyCommentEntity entityWithParam:param];
}

/**
 *  全部快递公司
 *
 *  @param param 请求参数
 */
- (void)totalCompanyWithParam:(NSDictionary *)param {
    self.totalCompanyEntity = [[DDTotalCompanyEntity alloc] initWithDelegate:self];
    [self.totalCompanyEntity entityWithParam:param];
}

/**
 *  评价标签
 *
 *  @param param 请求参数
 */
- (void)evaluateTagWithParam:(NSDictionary *)param {
    self.evaluateTagEntity = [[DDEvaluateTagEntity alloc] initWithDelegate:self];
    [self.evaluateTagEntity entityWithParam:param];
}

/**
 *  余额明细
 *
 *  @param param 请求参数
 */
- (void)yueInfomationWithParam:(NSDictionary *)param {
    self.yueInfomationEntity = [[DDYueInfomationEntity alloc] initWithDelegate:self];
    [self.yueInfomationEntity entityWithParam:param];
}

/**
 *  支付参数
 *
 *  @param param 请求参数
 */
- (void)payParamWithParam:(NSDictionary *)param {
    self.payParamEntity = [[DDPayParamEntity alloc] initWithDelegate:self];
    [self.payParamEntity entityWithParam:param];
}

/**
 *  删除快递列表
 *
 *  @param param 请求参数
 */
- (void)deleteExpressWithParam:(NSDictionary *)param {
    self.deleteExpressEntity = [[DDDeleteExpressEntity alloc] initWithDelegate:self];
    [self.deleteExpressEntity entityWithParam:param];
}

/**
 *  删除消息通知
 *
 *  @param param 请求参数
 */
- (void)deleteNotifactionWithParam:(NSDictionary *)param {
    self.deleteNotifactionEntity = [[DDDeleteNotifactionEntity alloc] initWithDelegate:self];
    [self.deleteNotifactionEntity entityWithParam:param];
}

/**
 *  版本更新
 *
 *  @param param 请求参数
 */
- (void)neVersionWithParam:(NSDictionary *)param {
    self.neVersionEntity = [[DDNewVersionEntity alloc] initWithDelegate:self];
    [self.neVersionEntity entityWithParam:param];
}

/**
 *  上传图片
 *
 *  @param param 请求参数
 */
- (void)uploadImageWithParam:(NSDictionary *)param {
    self.uploadImageEntity = [[DDUploadImageEntity alloc] initWithDelegate:self];
    [self.uploadImageEntity entityWithParam:param];
}

/**
 *  可能的快递公司
 *
 *  @param param 请求参数
 */
- (void)mayCompanyWithParam:(NSDictionary *)param {
    self.mayCompanyEntity = [[DDMayCompanyEntity alloc] initWithDelegate:self];
    [self.mayCompanyEntity entityWithParam:param];
}

/**
 *  通知数量
 *
 *  @param param 请求参数
 */
- (void)notificationNumWithParam:(NSDictionary *)param {
    self.notificationNumEntity = [[DDNotificationNumEntity alloc] initWithDelegate:self];
    [self.notificationNumEntity entityWithParam:param];
}

/**
 *  监听别处登录
 *
 *  @param param 请求参数
 */
- (void)bindOtherLoginWithParam:(NSDictionary *)param {
    self.bindOtherLoginEntity = [[DDBindOtherLoginEntity alloc] initWithDelegate:self];
    [self.bindOtherLoginEntity entityWithParam:param];
}

/**
 *  活动列表
 *
 *  @param param 请求参数
 */
- (void)activityListWithParam:(NSDictionary *)param {
    self.activityListEntity = [[DDActivityListEntity alloc] initWithDelegate:self];
    [self.activityListEntity entityWithParam:param];
}

#pragma mark -
#pragma mark DDEntityDelegate

- (void)entity:(id<DDEntityProtocol>)entity result:(NSDictionary *)result error:(NSError *)error {
    NSError *resultError            = nil;
    if (error) {
        NSString    *domain         = [NSString stringWithFormat:@"<%li>%@", (long)self.type, error.domain];
        resultError                 = [NSError errorWithDomain:domain code:error.code userInfo:nil];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(interface:result:error:)]) {
        [self.delegate interface:self result:result error:resultError];
    }
}

@end
