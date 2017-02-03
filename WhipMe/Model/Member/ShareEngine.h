//
//  ShareEngine.h
//  WhipMe
//
//  Created by anve on 16/11/24.
//  Copyright © 2016年 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiEngineDelegate <NSObject>
@optional
- (void)shareEngineWXApi:(SendAuthResp *)response;

- (void)shareEnginePayment:(PayResp *)response;

@end

@interface WMShareEngine : NSObject <WXApiDelegate>

@property (nonatomic, weak) id<WXApiEngineDelegate> delegate;

+ (WMShareEngine *)sharedInstance;

- (void)registerApp;

- (BOOL)handleOpenURL:(NSURL *)url;

/** 构造SendAuthReq结构体 */
- (void)sendAuthRequest:(id<WXApiEngineDelegate>)delegate;

/** 微信支付 */
- (void)sendWeChatPaymentInfo:(NSDictionary *)info;

/** 微信分享 */
- (void)shareWithScene:(int)scene withImage:(UIImage *)image;
@end
