//
//  DDPinwheelTableVeiw.h
//  DuDu Courier
//
//  Created by yangg on 16/3/31.
//  Copyright © 2016年 yangg. All rights reserved.
//
/**
 大风车表格视图，解决左右滑动表格视图（新闻类表格效果）,无下拉刷新
 */

typedef enum {
    DDPinwheelLeftNo = 0,               /** 左边没有 */
    DDPinwheelRightNo = 1,              /** 右边没有 */
    DDPinwheelAboutInterface = 2,       /** 左右都有界面 */
    DDPinwheelOnlyOne                   /** 只有一个 */
} DDPinwheelViewStyle;                  /** 视图类型 */


#import <UIKit/UIKit.h>

@class DDPinwheelTableVeiw;
@protocol DDPinwheelTableVeiwDelegate <NSObject>
@optional
/**
 *  回调当前应显示的视图状态
 *
 *  @param ddPinwheelTableVeiw 视图对象
 *  @param pinwheelIndex       数组下标
 *  @param pinwheelViewStyle   视图类型
 *  @param indexPath           表格cell下标
 */
- (void)pinwheelTableVeiw:(DDPinwheelTableVeiw *)ddPinwheelTableVeiw
        withPinwheelIndex:(NSInteger)pinwheelIndex
                withStyle:(DDPinwheelViewStyle)pinwheelViewStyle
            withIndexPath:(NSIndexPath *)indexPath;

/**
 *  根据显示到第几项返回数组
 *
 *  @param ddPinwheelTableVeiw 视图对象
 *  @param indexPath           数组下标
 *
 *  @return 数组，表格数据
 */
- (NSArray *)pinwheelTableVeiw:(DDPinwheelTableVeiw *)ddPinwheelTableVeiw
             withPinwheelIndex:(NSInteger)pinwheelIndex;

/**
 *  根据显示到第几项 表格刷新加载
 */
- (void)foorterRefreshWithPinwheelTableView;

/**
 *  根据显示到第几项 表格刷新加载
 */
- (void)headerRefreshWithPinwheelTableView;

/**
 *  指定显示到第几项
 *
 *  @param indexPath 数组下标
 *  @param pinwheelViewStyle 视图类型
 */
- (void)selectPinwheelWithPinwheelIndex:(NSInteger)pinwheelIndex
                              withStyle:(DDPinwheelViewStyle)pinwheelViewStyle;
/**
 *  数据为空时，提示按钮对应的事件
 *
 *  @param indexPath         数组下标
 *  @param pinwheelViewStyle 视图类型
 */
- (void)notResultViewWithPinwheelIndex:(NSInteger)pinwheelIndex
                             withStyle:(DDPinwheelViewStyle)pinwheelViewStyle;

@end

@interface DDPinwheelTableVeiw : UIView

/** 总视图数量 */
@property (nonatomic, assign) NSInteger contentNumber;
/** 协议 */
@property (nonatomic, assign) id<DDPinwheelTableVeiwDelegate> pinwheelDelegate;
/** 指定显示到第几项 */
@property (nonatomic, assign) NSInteger selectPinwheelView;

/** 刷新表格 */
- (void)reloadDataDDPinwheelTableVeiw:(DDPinwheelViewStyle)pinwheelViewStyle;

/** 表格数据为空时的提示消息 */
- (void)resultWithImage:(NSString *)imageName withContent:(NSString *)contentText withButtonTitle:(NSString *)titleButton;

/** 结束加载动画 */
- (void)endRefreshingPinwheel;

@end
