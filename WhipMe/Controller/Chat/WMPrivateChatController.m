//
//  WMPrivateChatController.m
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMPrivateChatController.h"
#import "WMChatListViewController.h"
#import "WMNotificationController.h"
#import "WMFriendsListController.h"

@interface WMPrivateChatController ()

@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) BOOL isPageScrollingFlag;
@property (strong, nonatomic) UIScrollView *buttonContainer;

@property (nonatomic, strong) UIBarButtonItem *rightBarItem;
@end

@implementation WMPrivateChatController

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
    
    self.pageController.navigationItem.rightBarButtonItem = self.rightBarItem;
    
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
    
    if (tempIndex == 0) {
        self.pageController.navigationItem.rightBarButtonItem = self.rightBarItem;
    } else {
        self.pageController.navigationItem.rightBarButtonItem = [UIBarButtonItem new];
    }
    
    self.currentPageIndex = tempIndex;
    [self.pageController setViewControllers:@[[self.viewControllerArray objectAtIndex:tempIndex]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL finished) {
    }];
}

- (void)clickWithRight {
    WMFriendsListController *controller = [WMFriendsListController new];
    controller.hidesBottomBarWhenPushed = YES;

    UIViewController *keyWindow = [[UIApplication sharedApplication].keyWindow rootViewController];
    MainTabBarController *tabBarControl = (MainTabBarController *)keyWindow;
    UINavigationController *currentController = (UINavigationController *)tabBarControl.selectedViewController;
    [currentController pushViewController:controller animated:YES];
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

#pragma mark - set get
- (NSArray<NSString *> *)buttonText {
    if (!_buttonText) {
        _buttonText = [NSArray arrayWithObjects:@"私信",@"通知", nil];
    }
    return _buttonText;
}

- (NSMutableArray<UIViewController *> *)viewControllerArray
{
    if (!_viewControllerArray) {
        _viewControllerArray = [NSMutableArray array];
        [_viewControllerArray addObject:[WMChatListViewController new]];
        [_viewControllerArray addObject:[WMNotificationController new]];
    }
    return _viewControllerArray;
}

- (UIBarButtonItem *)rightBarItem {
    if (!_rightBarItem) {
        _rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"people_care"] style:UIBarButtonItemStylePlain target:self action:@selector(clickWithRight)];
        _rightBarItem.tintColor = [UIColor whiteColor];
    }
    return _rightBarItem;
}

@end
