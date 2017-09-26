//
//  AppPageViewController.m
//  YouShaQi
//
//  Created by JC_CP3 on 14-4-8.
//  Copyright (c) 2014年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "AppPageViewController.h"
#import "ChildPageViewController.h"
#import "ShareSDKUtils.h"

static const NSInteger totalPageCount = 4;

@interface AppPageViewController () <ShareSDKViewDelegate, ChildPageViewDelegate, UIScrollViewDelegate> {
    UIPageViewController *pageController;
    UIImageView *pageControlImage;
    ShareSDKUtils *shareSDKUtils;
    
    UIPageControl *_currentPageControl;
    UIView *_startbgView;
    
    BOOL _isScrollView;
}

@end

@implementation AppPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = RGBCOLOR(172, 211, 59);
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    shareSDKUtils = [[ShareSDKUtils alloc] init];
    shareSDKUtils.shareSDKViewDelegate = self;
    
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageController.view.backgroundColor = [UIColor clearColor];
    pageController.dataSource = self;
    pageController.delegate = self;
    pageController.view.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(self.view.bounds) + 40);
    
    ChildPageViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    if ([viewControllers count] > 0) {
        [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];        
    }
    
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
    
    pageControlImage = [[UIImageView alloc] initWithImage:[self createPageControlImageWithIndex:0]];
    pageControlImage.center = CGPointMake(MainScreenWidth / 2, CGRectGetHeight(self.view.bounds) - 40);
    [self.view addSubview:pageControlImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)createPageControlImageWithIndex:(NSInteger)index
{
    CGSize imgSize = CGSizeMake(totalPageCount * 6 + (totalPageCount - 1) * 10, 6);
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, [[UIScreen mainScreen] scale]);
    
    UIImage *unselected = [self makeRoundedImageWithColor:RGBCOLOR(255, 255, 255) radius:3];
    UIImage *selected = [self makeRoundedImageWithColor:RGBACOLOR(255, 255, 255, 0.34f) radius:3];
 
    CGFloat space = 16;
    for (int i = 0; i < totalPageCount; i++) {
        if (i == index) {
            [selected drawAtPoint:CGPointMake(i * space, 0)];
        } else {
            [unselected drawAtPoint:CGPointMake(i * space, 0)];
        }
    }
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)makeRoundedImageWithColor:(UIColor *)imageColor radius:(float)radius;
{
    UIImage *image = [self createImageFromColor:imageColor width:radius * 2 height:radius * 2];
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id)image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

//自定义颜色
- (UIImage *)createImageFromColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (ChildPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    ChildPageViewController *childViewController = [[ChildPageViewController alloc] init];
    childViewController.childPageViewDelegate = self;
    childViewController.pageIndex = index;
    
    return childViewController;
}

#pragma mark - LoggedView
- (void)hideLoginView
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         pageController.view.frame = CGRectMake(-CGRectGetWidth(pageController.view.frame), CGRectGetMinX(pageController.view.frame), CGRectGetWidth(pageController.view.frame), CGRectGetHeight(pageController.view.frame));
                     }
                     completion:^(BOOL finished){
                         [pageController.view removeFromSuperview];
                         [pageController removeFromParentViewController];
                         pageController = nil;
                     }];
}


- (void)enterAppView:(UIButton *)btn
{
    if (btn) {
        btn.selected = YES;
    }
    
    [UserDefaults setBool:YES forKey:@"AppPageViewShowed_1"];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.view.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             if ([self.appPageViewDelegate respondsToSelector:@selector(AppPageViewDidDismissed)]) {
                                 [self.appPageViewDelegate AppPageViewDidDismissed];
                             }
                         }
                     }
     ];
}

#pragma mark - PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        NSInteger pageIndex = [(ChildPageViewController *)[pageViewController.viewControllers firstObject] pageIndex];
        [self setPageViewControllerBackgroundColor:pageIndex];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(ChildPageViewController *)viewController pageIndex];
    if (index == 0) {
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(ChildPageViewController *)viewController pageIndex];
    
    index++;
    if (index == 4) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (void)setPageViewControllerBackgroundColor:(NSInteger)pageIndex
{
    switch (pageIndex) {
        case 0:
            self.view.backgroundColor = RGBCOLOR(172, 211, 59);
            break;
        case 1:
            self.view.backgroundColor = RGBCOLOR(79, 190, 255);
            break;
        case 2:
            self.view.backgroundColor = RGBCOLOR(255, 218, 43);
            break;
            
        default:
            self.view.backgroundColor = RGBCOLOR(172, 211, 59);
            break;
    }
    pageControlImage.image = [self createPageControlImageWithIndex:pageIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return totalPageCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - ShareSDKUtils Delegate
- (void)loginSucceed
{
    [self enterAppView:nil];
}

/* 设置程序启动页 */
-(void)commonStart{
    
    _currentPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(MainScreenWidth/2-39/2, MainScreenHeight - 52, 39, 37)];
    
    _startbgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView *backgroundImageView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_start_bg.png"]];
    backgroundImageView_.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [_startbgView addSubview:backgroundImageView_];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunched"])
    {
        UIScrollView *startScrollView_ = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        startScrollView_.delegate = self;
        startScrollView_.bounces = NO;
        startScrollView_.showsHorizontalScrollIndicator = NO;
        startScrollView_.showsVerticalScrollIndicator = NO;
        
        
        //界面1
        UIImageView *_startImageViewOne = [[UIImageView alloc] init];
        CGRect rect1;
        UIImage *starImage1;
        if (DEVICE_IS_IPHONE5) {
            starImage1 = [UIImage imageNamed:@"引导页1ip5.png"];
            rect1 = CGRectMake(0, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        }else if(DEVICE_IS_IPHONE4){
            starImage1 = [UIImage imageNamed:@"引导页1ip4.png"];
            rect1 = CGRectMake(0, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        }else if (DEVICE_IS_IPHONE6){
            starImage1 = [UIImage imageNamed:@"引导页1ip6.png"];
            rect1 = CGRectMake(0, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            
        }else{
            
            starImage1 = [UIImage imageNamed:@"引导页1ip6大.png"];
            rect1 = CGRectMake(0, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            
        }
        _startImageViewOne.image = starImage1;
        _startImageViewOne.frame = rect1;
        [startScrollView_ addSubview:_startImageViewOne];
        
        //界面2
        UIImageView *_startImageViewTow = [[UIImageView alloc] init];
        CGRect rect2;
        UIImage *starImage2;
        if (DEVICE_IS_IPHONE5) {
            starImage2 = [UIImage imageNamed:@"引导页2ip5.png"];
            rect2 = CGRectMake(MainScreenWidth, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        }else if(DEVICE_IS_IPHONE4){
            starImage2 = [UIImage imageNamed:@"引导页2ip4.png"];
            rect2 = CGRectMake(MainScreenWidth, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        }else if (DEVICE_IS_IPHONE6){
            
            starImage2 = [UIImage imageNamed:@"引导页2ip6.png"];
            rect2 = CGRectMake(MainScreenWidth, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            
        }else{
            
            //iphone6 plus
            starImage2 = [UIImage imageNamed:@"引导页2ip6大.png"];
            rect2 = CGRectMake(MainScreenWidth, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            
        }
        _startImageViewTow.image = starImage2;
        _startImageViewTow.frame = rect2;
        [startScrollView_ addSubview:_startImageViewTow];
        
        //界面3
        UIImageView *_startImageViewThree = [[UIImageView alloc] init];
        CGRect rect3;
        UIImage *starImage3;
        if (DEVICE_IS_IPHONE5) {
            starImage3 = [UIImage imageNamed:@"引导页3ip5.png"];
            rect3 = CGRectMake(MainScreenWidth*2, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        }else if(DEVICE_IS_IPHONE4){
            starImage3 = [UIImage imageNamed:@"引导页3ip4.png"];
            rect3 = CGRectMake(MainScreenWidth*2, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        }else if (DEVICE_IS_IPHONE6) {
            starImage3 = [UIImage imageNamed:@"引导页3ip6.png"];
            rect3 = CGRectMake(MainScreenWidth*2, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            
        }else{
            
            starImage3 = [UIImage imageNamed:@"引导页3ip6大.png"];
            rect3 = CGRectMake(MainScreenWidth*2, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            
        }
        
        
        _startImageViewThree.image = starImage3;
        _startImageViewThree.frame = rect3;
        [startScrollView_ addSubview:_startImageViewThree];
        
        //界面4
        UIImageView *_startImageViewFour= [[UIImageView alloc] init];
        CGRect rect4;
        UIImage *starImage4;
        if (DEVICE_IS_IPHONE5) {
            starImage4 = [UIImage imageNamed:@"引导页4ip5.png"];
            rect4 = CGRectMake(MainScreenWidth*3, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        }else if(DEVICE_IS_IPHONE4){
            starImage4 = [UIImage imageNamed:@"引导页4ip4.png"];
            rect4 = CGRectMake(MainScreenWidth*3, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        }else if (DEVICE_IS_IPHONE6){
            starImage4 = [UIImage imageNamed:@"引导页4ip6.png"];
            rect4 = CGRectMake(MainScreenWidth*3, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            
        }else{
            
            //plus
            starImage4 = [UIImage imageNamed:@"引导页4ip6大.png"];
            rect4 = CGRectMake(MainScreenWidth*3, 0.0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
            
        }
        _startImageViewFour.image = starImage4;
        _startImageViewFour.frame = rect4;
        [startScrollView_ addSubview:_startImageViewFour];
        
        
        UIButton *startbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [startbtn setImage:[UIImage imageNamed:@"立即按下.png"] forState:UIControlStateNormal];
        //        [startbtn setImage:[UIImage imageNamed:@"立即体验按下.png"] forState:UIControlStateHighlighted];
        startbtn.backgroundColor = [UIColor clearColor];
        [startbtn addTarget:self action:@selector(startapp:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rectBtnStar;
        if (DEVICE_IS_IPHONE5) {
            
            rectBtnStar = CGRectMake(MainScreenWidth*3 + 96, MainScreenWidth-63-41.5, 128,41.5);
            
        }else if(DEVICE_IS_IPHONE4){
            
            rectBtnStar = CGRectMake(MainScreenWidth*3 + 96, MainScreenWidth-31-41.5, 128,41.5);
            
        }else if (DEVICE_IS_IPHONE6){
            
            rectBtnStar = CGRectMake(MainScreenWidth*3 +((MainScreenWidth-128)/2), MainScreenHeight-63-41.5-25, 128,41.5);
            
            
        }else if (DEVICE_IS_IPHONE6PLUS) {
            
            rectBtnStar = CGRectMake(MainScreenWidth*3 + ((MainScreenWidth-128)/2), MainScreenHeight-63-41.5-25,128,41.5);
            
        }
        
        startbtn.frame = rectBtnStar;
        [startScrollView_ addSubview:startbtn];
        
        [startScrollView_ setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width*5, [UIScreen mainScreen].bounds.size.height)];
        [startScrollView_ setPagingEnabled:YES];//分页拖动显示
        _currentPageControl.numberOfPages = 4;
        //        [startScrollView_ addSubview:_currentPageControl];
        [_startbgView addSubview:startScrollView_];
        [_startbgView addSubview:_currentPageControl];
        [[UIApplication sharedApplication].keyWindow addSubview:_startbgView];
        
    }
    
}

-(void)startapp:(UIButton *)button
{
    [UIView animateWithDuration:1 animations:^{
        _startbgView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [_startbgView removeFromSuperview];
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(!_isScrollView){
        //NSLog(@"%f",scrollView.contentOffset.x);
        
        _currentPageControl.currentPage = scrollView.contentOffset.x/MainScreenWidth;
        
        if(scrollView.contentOffset.x >MainScreenWidth*3 + 10.0){
            _isScrollView =  YES;
            [UIView animateWithDuration:1 animations:^{
                _startbgView.alpha = 0;
                
            } completion:^(BOOL finished) {
                [_startbgView removeFromSuperview];
                
            }];
        }
    }
}


/***********************************************************
 以下是垃圾代码区域，不要删！不要添加！不要动！
 ***********************************************************/

@end
