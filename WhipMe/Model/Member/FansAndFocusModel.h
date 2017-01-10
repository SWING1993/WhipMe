//
//  FansAndFocusModel.h
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FansAndFocusModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *describe;

/** 用户的userId */
@property (nonatomic, copy) NSString *userId;
/** 用户的头像 */
@property (nonatomic, copy) NSString *icon;
/** 正在监督的人数 */
@property (nonatomic, copy) NSString *num;
/** 用户的昵称 */
@property (nonatomic, copy) NSString *nickname;


@end
