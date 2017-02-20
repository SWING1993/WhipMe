//
//  WMMangerPageController.m
//  WhipMe
//
//  Created by youye on 17/2/20.
//  Copyright © 2017年 -. All rights reserved.
//  管理员登陆后展示

#import "WMMangerPageController.h"
#import "WMGrabOrderController.h"
#import "WMSuperviseController.h"

@interface WMMangerPageController ()

@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) BOOL isPageScrollingFlag;
@property (strong, nonatomic) UIScrollView *buttonContainer;

@property (nonatomic, strong) UIBarButtonItem *rightBarItem;

@end

@implementation WMMangerPageController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.barTintColor = [Define kColorNavigation];
        self.navigationBar.translucent = NO;
        self.currentPageIndex = 0;
        self.isPageScrollingFlag = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Define kColorBackGround]];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.pageController) {
        [self setup];
    }
    self.currentPageIndex = self.currentPageIndex;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.currentPageIndex == 0) {
        DDPostNotification(kAllConversationsNotification);
    }
}

- (void)dealloc {
    self.pageController.dataSource = nil;
    self.pageController.delegate = nil;
    DebugLog(@"%@",NSStringFromClass(self.class));
}

#pragma mark - setup view
- (void)setup {
    
    _pageController = (UIPageViewController *)self.topViewController;
    _pageController.delegate = self;
    _pageController.dataSource = nil;
    [_pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageController.navigationItem.leftBarButtonItem = self.rightBarItem;
    
    _navigationView = [[UISegmentedControl alloc] initWithItems:self.buttonText];
    _navigationView.frame = CGRectMake(0, 0, 132.0, 30.0);
    _navigationView.backgroundColor = [Define kColorNavigation];
    _navigationView.layer.cornerRadius = 30.0/2.0;
    _navigationView.layer.masksToBounds = true;
    _navigationView.layer.borderColor = [UIColor whiteColor].CGColor;
    _navigationView.layer.borderWidth = 1.0;
    _navigationView.tintColor = [UIColor whiteColor];
    _navigationView.selectedSegmentIndex = 0;
    [_navigationView addTarget:self action:@selector(clickWithNavItem:) forControlEvents:UIControlEventValueChanged];
    self.pageController.navigationController.navigationBar.topItem.titleView = self.navigationView;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Action
- (void)clickWithNavItem:(UISegmentedControl *)sender {
    DebugLog(@"_____index:%ld",(long)sender.selectedSegmentIndex);
    NSInteger tempIndex = sender.selectedSegmentIndex;
    self.currentPageIndex = tempIndex;
    [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:tempIndex]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL finished) {
                                 }];
}

#pragma mark - PageViewController Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfController:viewController];
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    index--;
    return [self.viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [self.viewControllerArray count]) {
        return nil;
    }
    return [self.viewControllerArray objectAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
    }
}

- (NSInteger)indexOfController:(UIViewController *)viewController {
    for (int i = 0; i<[self.viewControllerArray count]; i++) {
        if (viewController == [self.viewControllerArray objectAtIndex:i]) {
            return i;
        }
    }
    return NSNotFound;
}

- (void)clickWithRight {  
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - set get
- (NSArray<NSString *> *)buttonText {
    if (!_buttonText) {
        _buttonText = [NSArray arrayWithObjects:@"抢单",@"监督", nil];
    }
    return _buttonText;
}

- (NSMutableArray<UIViewController *> *)viewControllerArray
{
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
        [_viewControllerArray addObject:[WMGrabOrderController new]];
        [_viewControllerArray addObject:[WMSuperviseController new]];
    }
    return _viewControllerArray;
}

- (UIBarButtonItem *)rightBarItem {
    if (!_rightBarItem) {
        _rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickWithRight)];
        _rightBarItem.tintColor = [UIColor whiteColor];
    }
    return _rightBarItem;
}

@end
