//
//  LSPayConst.h
//  LSPay
//
//  Created by Steven on 16/2/7.
//  Copyright © 2016年 Steven. All rights reserved.
//

#ifndef LSPayConst_h
#define LSPayConst_h


/*
 *  使用说明
 
 1.申请支付宝、微信支付
 
 2.下载对应SDK，如果SDK没有 更新直接使用当前SDK
 
 3.$(PROJECT_DIR)/$(TARGET_NAME)/Frameworks/LSPay/Lib/Alipay
 
 4.解决编译错误：
    .CoreMotion.framework
    .SystemConfiguration.framework
    .CoreTelephony.framework
    .libz.tbd
    .libsqlite3.tbd
    .mm
 
 5.应用跳转
 应用需要在“Info.plist”中将要使用的URL Schemes（跳转程序）列为白名单，
 注：如果项目中第三方分享用的是友盟，在注册的时候要把友盟注册放在微信注册的前面执行。如下：
    <key>LSApplicationQueriesSchemes</key>
    <array>
     <string>weixin</string>
    </array>
 
 6.填写Scheme
   对于支付宝，填写自己的app的scheme，如：Yeah
   对于微信支付，填写微信AppId
 
 7.请补充填写以下配置信息
 
 */

typedef NS_ENUM(NSInteger,LSPayType){
    
    /** 支付宝 */
    LSPayTypeAliPay = 1,
    
    /** 微信支付 */
    LSPayTypeWechat = 2,
    
    /** ApplePay */
    LSPayTypeApplePay = 3
    
};

/*
 *  支付宝重要信息定义
 */

/** partner */
#define LSPay_Alipay_Partner @""

/** seller */
#define LSPay_Alipay_Seller @""

/** privateKey：PKCS8格式的私钥 */
#define LSPay_Alipay_PrivateKey @""

/** notifyURL */
#define LSPay_Alipay_NotifyURL @""

/** appScheme */
#define LSPay_Alipay_AppScheme @"atxiaoge"


/*
 *  微信支付重要信息定义
 */

/** 微信开发平台：AppID */
#define LSPay_WeChat_AppID @"wxf4b7b89aa7b673bf"

/** 微信开发平台：AppSecret */
#define LSPay_WeChat_AppSecret @""

/** 微信支付商号 */
#define LSPay_WeChat_Mch_id @""

/** notifyURL */
#define LSPay_WeChat_NotifyURL LSPay_Alipay_NotifyURL

/** API_PartnerKey */
#define LSPay_WeChat_API_PartnerKey @""

/** ApplePay merchantIdentifier */
#define LSPay_ApplePay_MerchantIdentifier @"merchant.com.Steven.LSUtility"

#endif
/* LSPayConst_h */
