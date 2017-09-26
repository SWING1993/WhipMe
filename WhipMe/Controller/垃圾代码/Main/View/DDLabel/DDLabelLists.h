//
//  DDLabelLists.h
//  DDExpressClient
//
//  Created by yangg on 16/3/9.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DDLabelLists;
@protocol DDLabelListsDelegate <NSObject>
@optional
- (void)ddLabelLists:(DDLabelLists *)labelList index:(NSInteger)buttonIndex withSelect:(BOOL)isSelect;

@end

/**
 定义一个显示多个标签的视图
 */
@interface DDLabelLists : UIView
{
    UIView *view;
    NSMutableArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
    BOOL labelBorderColor;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, assign) id<DDLabelListsDelegate> delegate;

/** 设置标签的背景色 */
- (void)setLabelBackgroundColor:(UIColor *)color;
/** 设置标签的背景色／绿 */
- (void)setLabelBorderColor:(BOOL)color;

/** 显示的标签间隙为统一大小，不超过父视图 */
- (void)setItemLabels:(NSMutableArray *)array;

/** 显示的标签不换行，不超过父视图 */
- (void)setDetailTags:(NSMutableArray *)array;

/** 开始绘制标签 */
- (void)display;

/** 返回标签所占的视图区域大小 */
- (CGSize)fittedSize;

/** 选择所有项 */
- (void)selectedWithAllItems:(BOOL)flag;

- (void)selectedWithIndexItems:(NSInteger)index;

@end
