//
//  ShareSDKUtils.h
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/19.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

#import "ShareMessageItem.h"

@protocol ShareSDKViewDelegate <NSObject>

@optional
- (void)shareMessageSucceed;

@end

@interface ShareSDKUtils : NSObject

@property (nonatomic, weak) id<ShareSDKViewDelegate> shareSDKViewDelegate;

+ (instancetype)shareInstance;

- (void)shareMessageWithPlatformType:(SSDKPlatformType)type shareMessageItem:(ShareMessageItem *)item;

@end
