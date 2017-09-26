//
//  DDWaitCourierRushOrderView.h
//  DDExpressClient
//
//  Created by Jadyn on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    等待快递员抢单
 */

#import <UIKit/UIKit.h>

@class DDWaitCourierRushOrderView;
@protocol DDWaitCourierRushOrderViewDelegate <NSObject>
@optional
/** 弹出取消订单界面 */
- (void)waitCourierRushOrderView:(DDWaitCourierRushOrderView *)waitCourierRushOrderView cancelWithTime:(BOOL)timeOver;

@end

@interface DDWaitCourierRushOrderView : UIView

- (instancetype)initWithDelegate:(id<DDWaitCourierRushOrderViewDelegate>)delegate;

/** 弹窗按钮代理*/
@property (nonatomic, assign) id<DDWaitCourierRushOrderViewDelegate> delegate;


/** 刷新计时器 */
- (void)reloadCountDownView:(BOOL)clearPersistence;

/** 视图显示 */
- (void)show;

/** 视图的删除方法 */
- (void)dismissAlert;

@end
