//
//  DDWaitForCourierView.h
//  DDForCourierClient
//
//  Created by Jadyn on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
 等待快递员取件
 */

#import <UIKit/UIKit.h>


typedef enum {
    DDWaitForCourierViewStyleNone = 0,                 //默认展开状态展示
    DDWaitForCourierViewStyleContracted = 1            //收缩状态显示
} DDWaitForCourierViewStyle;

@class DDWaitForCourierView,DDCourierDetail;
@protocol DDWaitForCourierViewDelegate <NSObject>
@optional
/** 弹出取消订单界面 */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickCancelBtn:(DDCourierDetail *)courierDetail;
/**<  跳转到快递员主页  */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickCourierDetailBtn:(DDCourierDetail *)courierDetail;

/**<  追单(参数传是否为同一个快递员)  */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickSendAgainBtn:(DDCourierDetail *)courierDetail andIsSameCourier:(BOOL)isSame;

/** 拨打电话 */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickPhoneCallBtn:(DDCourierDetail *)courierDetail;

/** 返回订单列表按钮点击事件 */
- (void)waitForCourierView:(DDWaitForCourierView *)waitForCourierView didClickbackToOrderListBtn:(DDCourierDetail *)courierDetail;
@end



@interface DDWaitForCourierView : UIView
/**
 *  实例方法
 *  @param delegate 协议
 *  @param style    视图类型
 */
- (instancetype)initWithDelegate:(id<DDWaitForCourierViewDelegate>)delegate withStyle:(DDWaitForCourierViewStyle)style;

/** 快递员详细信息模型 */
@property (nonatomic ,strong) DDCourierDetail *courierDetail;
/** 代理 */
@property (nonatomic, assign) id<DDWaitForCourierViewDelegate> delegate;



/** 视图显示 */
- (void)show;

/** 视图的删除方法 */
- (void)dismissAlert;


@end
