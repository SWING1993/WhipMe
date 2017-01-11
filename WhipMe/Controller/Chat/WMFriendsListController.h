//
//  WMFriendsListController.h
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WMFriendsListStyle) {
    WMFriendsListStyleNone = 0,
    WMFriendsListStyleAddFriend,
};

@interface WMFriendsListController : UIViewController

@property (nonatomic, assign) WMFriendsListStyle controlStyle;

- (instancetype)initWithStyle:(WMFriendsListStyle)style;

@end
