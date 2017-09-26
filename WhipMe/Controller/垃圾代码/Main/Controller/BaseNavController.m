//
//  BaseNavController.m
//  NavigationBarDemo
//
//  Created by JC_CP3 on 15/7/21.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "BaseNavController.h"
#import "DDRootViewController.h"
#import <objc/runtime.h>

static const CGFloat backGestureOffsetToBackValue = 80;
static const CGFloat shadowViewAlphaValue = 0.3f;

static const char *assoKeyPanGesture = "panGestureKey";
static const char *assoKeyStartPanPoint = "startPanPointKey";
static const char *assoKeyEnableGesture = "enableGestureKey";

@interface BaseNavController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate> {
    
    
}

@end

@implementation BaseNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - UINavigaionControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    /* if rootViewController, set delegate nil */
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    UIViewController *currentVC = [self topViewController];
    ((DDRootViewController *)currentVC).shadowView.alpha = shadowViewAlphaValue;
    ((DDRootViewController *)currentVC).shadowView.hidden = YES;
    
    int count = (int)[self.viewControllers count];
    if (count > 1) {
        UIViewController *preVC = [self.viewControllers objectAtIndex:count - 2];
        ((DDRootViewController *)preVC).shadowView.alpha = shadowViewAlphaValue;
        ((DDRootViewController *)currentVC).shadowView.hidden = YES;
    }
    
}

/* 实现UINavigationController 手势滑动 */
- (BOOL)enableBackGesture
{
    NSNumber *enableGestureNum = objc_getAssociatedObject(self, assoKeyEnableGesture);
    if (enableGestureNum) {
        return [enableGestureNum boolValue];
    }
    return false;
}

- (void)setEnableBackGesture:(BOOL)enableBackGesture
{
    NSNumber *enableGestureNum = [NSNumber numberWithBool:enableBackGesture];
    objc_setAssociatedObject(self, assoKeyEnableGesture, enableGestureNum, OBJC_ASSOCIATION_RETAIN);
    if (enableBackGesture) {
        [self.view addGestureRecognizer:[self panGestureRecognizer]];
    } else {
        [self.view removeGestureRecognizer:[self panGestureRecognizer]];
    }
}

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, assoKeyPanGesture);
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToBack:)];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [panGestureRecognizer setDelegate:self];
        objc_setAssociatedObject(self, assoKeyPanGesture, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN);
    }
    return panGestureRecognizer;
}

- (void)setStartPanPoint:(CGPoint)point
{
    NSValue *startPanPointValue = [NSValue valueWithCGPoint:point];
    objc_setAssociatedObject(self, assoKeyStartPanPoint, startPanPointValue, OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)startPanPoint
{
    NSValue *startPanPointValue = objc_getAssociatedObject(self, assoKeyStartPanPoint);
    if (!startPanPointValue) {
        return CGPointZero;
    }
    return [startPanPointValue CGPointValue];
}

- (void)panToBack:(UIPanGestureRecognizer*)pan
{
    UIView *currentView = self.topViewController.view;
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self setStartPanPoint:currentView.frame.origin];
        CGPoint velocity = [pan velocityInView:self.view];
        if(velocity.x != 0){
            [self willShowPreViewController];
        }
        return;
    }
    CGPoint currentPostion = [pan translationInView:self.view];
    CGFloat xoffset = [self startPanPoint].x + currentPostion.x;
    CGFloat yoffset = [self startPanPoint].y + currentPostion.y;
    if (xoffset > 0) {
        //向右滑
    } else if (xoffset < 0) {
        //向左滑
        xoffset = 0;
    }
    if (!CGPointEqualToPoint(CGPointMake(xoffset, yoffset), currentView.frame.origin)) {
        [self layoutCurrentViewWithOffset:UIOffsetMake(xoffset, yoffset)];
    }
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (currentView.frame.origin.x == 0) {
            
        } else {
            if (currentView.frame.origin.x < backGestureOffsetToBackValue) {
                [self hidePreViewController];
            } else {
                [self showPreViewController];
            }
        }
    }
}

- (void)willShowPreViewController
{
    NSInteger count = self.viewControllers.count;
    if (count > 1) {
        UIViewController *currentVC = [self topViewController];
        UIViewController *preVC = [self.viewControllers objectAtIndex:count - 2];
        [currentVC.view.superview insertSubview:preVC.view belowSubview:currentVC.view];
    }
}

- (void)showPreViewController
{
    NSInteger count = self.viewControllers.count;
    if (count > 1) {
        UIView *currentView = self.topViewController.view;
        NSTimeInterval animatedTime = 0;
        CGFloat viewWidth = CGRectGetWidth(self.view.frame);
        animatedTime = ABS(viewWidth - currentView.frame.origin.x) / viewWidth * 0.35;
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:animatedTime animations:^{
            [self layoutCurrentViewWithOffset:UIOffsetMake(viewWidth, 0)];
        } completion:^(BOOL finished) {
            [self popViewControllerAnimated:false];
        }];
    }
}

- (void)hidePreViewController
{
    NSInteger count = self.viewControllers.count;
    if (count > 1) {
        UIViewController *preVC = [self.viewControllers objectAtIndex:count - 2];
        UIView *currentView = self.topViewController.view;
        NSTimeInterval animatedTime = 0;
        CGFloat viewWidth = CGRectGetWidth(self.view.frame);
        animatedTime = ABS(viewWidth - currentView.frame.origin.x) / viewWidth * 0.35;
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:animatedTime animations:^{
            [self layoutCurrentViewWithOffset:UIOffsetMake(0, 0)];
        } completion:^(BOOL finished) {
            ((DDRootViewController *)preVC).shadowView.hidden = YES;
            ((DDRootViewController *)preVC).shadowView.alpha = shadowViewAlphaValue;
            [preVC.view removeFromSuperview];
        }];
    }
}

- (void)layoutCurrentViewWithOffset:(UIOffset)offset
{
    NSInteger count = self.viewControllers.count;
    if (count > 1) {
        UIViewController *currentVC = [self topViewController];
        UIViewController *preVC = [self.viewControllers objectAtIndex:count - 2];
        CGFloat viewWidth = CGRectGetWidth(self.view.frame);
        CGFloat viewHeight = CGRectGetHeight(self.view.frame);
        [currentVC.view setFrame:CGRectMake(offset.horizontal, self.view.bounds.origin.y, viewWidth, viewHeight)];
        ((DDRootViewController *)preVC).shadowView.hidden = NO;
        
        CGFloat currentOffsetPercent = (MainScreenWidth - offset.horizontal) / MainScreenWidth;
        ((DDRootViewController *)preVC).shadowView.alpha = shadowViewAlphaValue * currentOffsetPercent;
        
        [preVC.view setFrame:CGRectMake(offset.horizontal / 2 - viewWidth / 2, self.view.bounds.origin.y, viewWidth, viewHeight)];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        if ([panGesture velocityInView:self.view].x < 600 && ABS(translation.x) / ABS(translation.y) > 1) {
            return YES;
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
        if (scrollView.contentOffset.x <= 0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Orientation Delegate
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
