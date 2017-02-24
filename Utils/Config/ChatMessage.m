//
//  ChatMessage.m
//  WhipMe
//
//  Created by anve on 16/11/7.
//  Copyright © 2016年 -. All rights reserved.
//

#import "ChatMessage.h"
#import <SDWebImage/SDWebImagePrefetcher.h>

static ChatMessage *_chatObj = nil;
@implementation ChatMessage

+ (ChatMessage *)shareChat {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _chatObj = [[ChatMessage alloc] init];
    });
    return _chatObj;
}

- (void)loginJMessage
{
    UserManager *info = [UserManager shared];
    if ([NSString isBlankString:info.userId] || [NSString isBlankString:info.pwdim]) {
        return;
    }
    
    JMSGUser *jUser = [JMSGUser myInfo];
    if ([NSString isBlankString:jUser.username] == NO) {
        if ([NSString isBlankString:jUser.nickname]) {
            [self updateJUserInfo];
        }
        return;
    }
    
    [JPUSHService setAlias:info.userId callbackSelector:nil object:nil];
    
    WEAK_SELF
    [JMSGUser loginWithUsername:info.userId password:info.pwdim completionHandler:^(id resultObject, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (error.code == kJMSGErrorHttpUserNotExist || error.code == kJMSGErrorTcpUserNotRegistered) {
            [weakSelf registerJMessage];
        } else if (error.code == kJMSGErrorTcpUserPasswordError) {
            [weakSelf updateLoginPwd];
        }
        if (error == nil) {
            [weakSelf updateJUserInfo];
        }
    }];
}

- (void)updateJUserInfo {
    UserManager *info = [UserManager shared];
    if ([NSString isBlankString:info.nickname] == NO) {
        [JMSGUser updateMyInfoWithParameter:info.nickname userFieldType:kJMSGUserFieldsNickname completionHandler:^(id resultObject, NSError *error) {
        }];
    }
    if ([NSString isBlankString:info.icon] == NO) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:info.icon] options:SDWebImageDownloaderLowPriority|SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (data) {
                [JMSGUser updateMyInfoWithParameter:data userFieldType:kJMSGUserFieldsAvatar completionHandler:^(id resultObject, NSError *error) {
                }];
            }
        }];
    }
    [JMSGUser updateMyInfoWithParameter:[NSNumber numberWithBool:info.sex] userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
    }];
}

- (void)updateLoginPwd {
    UserManager *info = [UserManager shared];
    if ([NSString isBlankString:info.pwdim]) {
        return;
    }
    [JMSGUser loginWithUsername:info.userId password:@"123456" completionHandler:^(id resultObject, NSError *error) {
        [JMSGUser updateMyPasswordWithNewPassword:info.pwdim oldPassword:@"123456" completionHandler:^(id resultObject, NSError *error) {
            
        }];
    }];
    
}

- (void)registerJMessage
{
    UserManager *info = [UserManager shared];
    if ([NSString isBlankString:info.userId] || [NSString isBlankString:info.pwdim]) {
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    WEAK_SELF
    [JMSGUser registerWithUsername:info.userId password:info.pwdim completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            [weakSelf loginJMessage];
            [weakSelf imResultJMessage];
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }];
}

- (void)imResultJMessage {
    UserManager *info = [UserManager shared];
    if ([NSString isBlankString:info.userId] || [NSString isBlankString:info.pwdim]) {
        return;
    }
    
    NSDictionary *param = @{@"userId":info.userId,@"frontend":@"ios"};
    [HttpAPIClient APIClientPOST:@"imResult" params:param Success:^(id result) {
        
    } Failed:^(NSError *error) {
        
    }];
}


@end
