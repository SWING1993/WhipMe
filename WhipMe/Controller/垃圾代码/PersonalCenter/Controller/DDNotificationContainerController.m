//
//  DDNotificationContainerController.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/5/5.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDNotificationContainerController.h"
#import "DDNotificationController.h"
#import "DDActivityController.h"
#import "DDWebViewController.h"
#import "DDActivity.h"
#import "DDNoHiglightedButton.h"

@interface DDNotificationContainerController () <UIScrollViewDelegate, DDActivityControllerDelegat>

@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) DDNoHiglightedButton *activityButton;
@property (nonatomic, strong) DDNoHiglightedButton *notificationButton;

@property (nonatomic,strong) UIView *bottomLineView;
@end

@implementation DDNotificationContainerController


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KBackground_COLOR;
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"消息" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.activityButton];
    [self.topView addSubview:self.notificationButton];
    [self.topView addSubview:self.bottomLineView];
    
    [self.view addSubview:self.containerScrollView];
    
    
    DDActivityController *activityController = [[DDActivityController alloc] init];
    activityController.view.frame = self.containerScrollView.bounds;
    activityController.delegate = self;
    [self addChildViewController:activityController];
    [self.containerScrollView addSubview:activityController.view];

    DDNotificationController *notificationController = [[DDNotificationController alloc] init];
    notificationController.view.frame = self.containerScrollView.bounds;
    notificationController.view.x = self.view.width;
    [self addChildViewController:notificationController];
    [self.containerScrollView addSubview:notificationController.view];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat navBarH = 64;
    CGFloat topViewH = 44;
    CGFloat topViewW = self.view.width;
    CGFloat lineViewH = 2;
    [self.topView setFrame:CGRectMake(0, navBarH, topViewW, topViewH)];
    [self.activityButton setFrame:CGRectMake(0, 0, topViewW/2, topViewH - lineViewH)];
     [self.notificationButton setFrame:CGRectMake(self.activityButton.right, 0, topViewW/2, topViewH - lineViewH)];
    [self.bottomLineView setFrame:CGRectMake(self.activityButton.selected ? 0 : topViewW/2, topViewH - lineViewH, topViewW/2, lineViewH)];
    
    [self.containerScrollView setFrame:CGRectMake(0, self.topView.bottom, topViewW, self.view.height - navBarH - topViewH)];
}

#pragma mark - Event Method
- (void)onClickLeftItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickTopViewButton:(UIButton *)button
{
    button.selected = YES;
    
    self.activityButton.selected = !(self.notificationButton == button);
    self.notificationButton.selected = !(self.activityButton == button);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.bottomLineView.x = button.x;
        [self.containerScrollView setContentOffset:CGPointMake(button.x*2, 0) animated:YES];
    }];
  
    
}

#pragma mark - DDActivityController Delegate
- (void)activityController:(DDActivityController *)activityController selectCellWithActivity:(DDActivity *)activity
{
    DDWebViewController *webViewController = [[DDWebViewController alloc] init];
    webViewController.URLString = activity.activityUrl;
    webViewController.navTitle = @"活动信息";
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - setter & getter
- (UIScrollView *)containerScrollView
{
    if (_containerScrollView == nil) {
        _containerScrollView = [[UIScrollView alloc] init];
        [_containerScrollView setContentSize:CGSizeMake( self.view.width*2, self.view.height)];
        [_containerScrollView setBackgroundColor:KBackground_COLOR];
        [_containerScrollView setShowsHorizontalScrollIndicator:NO];
        [_containerScrollView setShowsVerticalScrollIndicator:NO];
        [_containerScrollView setScrollEnabled:NO];
        [_containerScrollView setPagingEnabled:YES];
        [_containerScrollView setBounces:NO];
        [_containerScrollView setDelegate:self];
    }
    return _containerScrollView;
}

- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:KBackground_COLOR];
    }
    return _topView;
}

- (UIButton *)activityButton
{
    if (_activityButton == nil) {
        _activityButton = [DDNoHiglightedButton buttonWithType:UIButtonTypeCustom];
        [_activityButton setTitle:@"活动信息" forState:UIControlStateNormal];
        [_activityButton setBackgroundColor:WHITE_COLOR];
        [_activityButton.titleLabel setFont:kTitleFont];
        [_activityButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [_activityButton setTitleColor:DDGreen_Color forState:UIControlStateSelected];
        [_activityButton addTarget:self action:@selector(onClickTopViewButton:) forControlEvents:UIControlEventTouchDown];
        [_activityButton setSelected:YES];

    }
    return _activityButton;
}

- (UIButton *)notificationButton
{
    if (_notificationButton == nil) {
        _notificationButton = [DDNoHiglightedButton buttonWithType:UIButtonTypeCustom];
        [_notificationButton setTitle:@"消息通知" forState:UIControlStateNormal];
        [_notificationButton setBackgroundColor:WHITE_COLOR];
        [_notificationButton.titleLabel setFont:kTitleFont];
        [_notificationButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [_notificationButton setTitleColor:DDGreen_Color forState:UIControlStateSelected];
        [_notificationButton addTarget:self action:@selector(onClickTopViewButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _notificationButton;
}

- (UIView *)bottomLineView
{
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] init];
        [_bottomLineView setBackgroundColor:DDGreen_Color];
    }
    return _bottomLineView;
}

@end
