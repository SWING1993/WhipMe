//
//  UIScrollView+AllowPanGestureEventPass.m
//  CoExistOfScrollViewAndBackGesture
//
//  Created by 乐星宇 on 14-5-1.
//  Copyright (c) 2014年 Lxy. All rights reserved.
//

#import "UIScrollView+AllowPanGestureEventPass.h"

@implementation UIScrollView (AllowPanGestureEventPass)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    CGPoint offset = self.contentOffset;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && offset.x == 0.00)
    {
        return YES;
    }
    else
    {
        return  NO;
    }
}



@end
