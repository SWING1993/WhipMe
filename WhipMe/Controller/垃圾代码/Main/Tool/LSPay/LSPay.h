//
//  LSPay.h
//  LSPay
//
//  Created by Steven on 16/2/7.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSPayConst.h"
#import "LSPaySingleton.h"

extern NSString *const LSPaySuccess;
extern NSString *const LSPayFailure;
extern NSString *const LSPayCancel;

@interface LSPay : NSObject
HMSingletonH(LSPay)

@property (nonatomic,assign) BOOL isRegisterWeChatPay;
@property (nonatomic,copy) void(^CompleteBlock)(NSString *errorMsg);
@property (nonatomic, strong) UIViewController *payController;

+(void)handleOpenURL:(NSURL *)url;

+(void)payWithType:(LSPayType)type orderString:(NSString *)orderString completeClosure:(void(^)(NSString *errorMsg))completeClosure;
@end
