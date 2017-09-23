//
//  DDPernalListHeadView.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/24.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    个人信息列表菜单头部 View
 */

#import <UIKit/UIKit.h>
#import "Constant.h"
@class DDSelfInfomation;

@protocol DDPersonalListHeadDelegate <NSObject>
/** 个人中心头部View代理方法 */
- (void)personalListHeadDidClick;

@end

@interface DDPersonalListHeadView : UIView

/** 个人中心头部代理 */
@property (nonatomic, weak) id<DDPersonalListHeadDelegate> delegate;

- (void)updateUserInfo;

@end
