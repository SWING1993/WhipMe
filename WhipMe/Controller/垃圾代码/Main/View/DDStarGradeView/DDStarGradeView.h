//
//  DDStarGradeView.h
//  DuDu Courier
//
//  Created by yangg on 16/3/21.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDStarGradeView : UIView

/** 设置进度默认值，范围在0~5之间 */
@property (nonatomic, assign) CGFloat progress;

/** 开始绘制 */
- (void)display;

@end
