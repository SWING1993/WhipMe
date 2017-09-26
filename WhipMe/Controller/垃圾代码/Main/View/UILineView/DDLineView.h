//
//  DDLineView.h
//  DDExpressClient
//
//  Created by yangg on 16/3/8.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDLineView : UIImageView

/**
 * lineLength:      虚线的宽度
 * lineSpacing:     虚线的间距
 * lineColor:       虚线的颜色
 */
- (void)drawDashLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
