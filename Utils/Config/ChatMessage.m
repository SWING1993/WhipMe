//
//  ChatMessage.m
//  WhipMe
//
//  Created by anve on 16/11/7.
//  Copyright © 2016年 -. All rights reserved.
//

#import "ChatMessage.h"

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
    
    WEAK_SELF
    [JMSGUser loginWithUsername:info.userId password:info.pwdim completionHandler:^(id resultObject, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (error.code == kJMSGErrorHttpUserNotExist) {
            [weakSelf registerJMessage];
        }
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
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }];
}

@end
