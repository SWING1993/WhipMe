//
//  ChatMessage.m
//  WhipMe
//
//  Created by anve on 16/11/7.
//  Copyright © 2016年 -. All rights reserved.
//

#import "ChatMessage.h"

static NSString *const password = @"123456";
static ChatMessage *_chatObj = nil;
@implementation ChatMessage

+ (ChatMessage *)shareChat {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _chatObj = [[ChatMessage alloc] init];
    });
    return _chatObj;
}

- (void)loginJMessage:(NSString *)username
{
    if ([NSString isBlankString:username]) {
        return;
    }
    [JMSGUser loginWithUsername:username password:password completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"login JMessage is success");
        } else {
            NSLog(@"login JMessage is fail");
        }
    }];
}

- (void)registerJMessage:(NSString *)username
{
    if ([NSString isBlankString:username]) {
        return;
    }
     __weak typeof(self) weakSelf = self;
    [JMSGUser registerWithUsername:username password:password completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSLog(@"register JMessage is success");
            [weakSelf loginJMessage:username];
        } else {
            NSLog(@"register JMessage is fail");
        }
    }];
}

@end
