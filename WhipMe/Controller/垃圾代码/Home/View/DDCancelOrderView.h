//
//  DDCancelOrderView.h
//  DDExpressClient
//
//  Created by Jadyn on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    取消订单
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DDCancelOrderViewStyle) {
    DDCancelOrderViewStyleWaitCourier = 0,          /**取消等待快递员－抢单*/
    DDCancelOrderViewStyleWaitExpress = 1          /**取消等待快递员－取件*/
};

typedef enum {
    DDCancelOrderViewButtonCancel = 0,              /** 取消订单按钮 */
    DDCancelOrderViewButtonContinue = 1,            /** 继续等待按钮 */
    DDCancelOrderViewButtonConfirmCancel = 2        /** 返回首页 */
} DDCancelOrderViewButton;


/** 取消订单弹窗的协议事件 */
@class DDCancelOrderView;
@protocol DDCancelOrderViewDelegate <NSObject>
@optional
- (void)cancelOrderView:(DDCancelOrderView *)cancelOrderView withButtonIndex:(DDCancelOrderViewButton)indexButton;

@end



@interface DDCancelOrderView : UIView
/**
 *  实例方法
 *  @param delegate 协议
 *  @param style    视图类型
 */
- (instancetype)initWithDelegate:(id<DDCancelOrderViewDelegate>)delegate withStyle:(DDCancelOrderViewStyle)style;

/** 代理方法 */
@property (nonatomic, assign) id<DDCancelOrderViewDelegate> delegate;



/** 视图显示 */
- (void)show;

/** 视图的删除方法 */
- (void)dismissAlert;

@end
