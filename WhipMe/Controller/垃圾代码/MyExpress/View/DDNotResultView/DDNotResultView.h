//
//  DDNotResultView.h
//  DDExpressClient
//
//  Created by yangg on 16/4/12.
//  Copyright © 2016年 NS. All rights reserved.
//
/** 没有数据时的View */

#import <UIKit/UIKit.h>

@class DDNotResultView;
@protocol DDNotResultViewDelegate <NSObject>
@optional
- (void)notResultView:(DDNotResultView *)resultView indexButton:(NSInteger)index;

@end

@interface DDNotResultView : UIView

/** 图片 icon */
@property (nonatomic, strong) UIImage *imageIcon;
/** 文本内容 */
@property (nonatomic, strong) NSString *contentText;
/** 确定按钮 */
@property (nonatomic, strong) NSString *titleButton;

@property (nonatomic, assign) id<DDNotResultViewDelegate> delegate;

@end
