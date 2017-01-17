//
//  ChatMessage.h
//  WhipMe
//
//  Created by anve on 16/11/7.
//  Copyright © 2016年 -. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>

@interface ChatMessage : NSObject

+ (ChatMessage *)shareChat;

- (void)loginJMessage;

- (void)registerJMessage;

- (void)registerJMessage:(NSString *)username pwd:(NSString *)password;

@end
