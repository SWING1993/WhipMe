//
//  DDBackgroundRectangleView.h
//  DuDu Courier
//
//  Created by yangg on 16/4/1.
//  Copyright © 2016年 yangg. All rights reserved.
//
/**
 二维码／条形码 扫描的灰黑阴影视图
 */


#import <UIKit/UIKit.h>

@interface DDBackgroundRectangleView : UIView


/** 设置透明度 */
@property (nonatomic, assign) CGFloat alphaRectangle;
/** 设置中心内容视图 */
@property (nonatomic, assign) CGRect currentFrame;



@end
