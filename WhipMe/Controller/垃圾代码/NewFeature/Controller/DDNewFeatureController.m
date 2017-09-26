//
//  DDNewFeatureController.m
//  20151228LSWeibo
//
//  Created by Steven.Liu on 15/12/31.
//  Copyright © 2015年 Steven.Liu. All rights reserved.
//

#import "DDNewFeatureController.h"
#import "DDHomeController.h"
#import "Constant.h"

#define DDNewFeatureImageCounts 4
#define DDNewFeatureWidth self.view.width
#define DDNewFeatureHeight self.view.height
#define DDNewFeatureCenterX self.view.centerX

@interface DDNewFeatureController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation DDNewFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //创建滚动页面
    [self createScrollPage];
}

/**
    创建滚动页面
 */
- (void)createScrollPage
{
    //初始化scroll控件
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(DDNewFeatureWidth * DDNewFeatureImageCounts, 0);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < DDNewFeatureImageCounts; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.view.bounds;
        imageView.x = DDNewFeatureWidth * i;
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [scrollView addSubview:imageView];
        
        if (i == DDNewFeatureImageCounts -1) {
            [self addLastPageItems:imageView];
        }
    }
    
    //初始化page控件
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = DDNewFeatureImageCounts;
    pageControl.centerX = DDNewFeatureCenterX;
    pageControl.centerY = DDNewFeatureHeight - 50;
    
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
}

//设置尾页界面
-(void) addLastPageItems: (UIImageView *) imageView
{
    imageView.userInteractionEnabled = YES;
    
    //添加选择框控件
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [checkButton setTitle:@"分享给大家" forState:UIControlStateNormal];
    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    checkButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [imageView addSubview:checkButton];
    
    //添加进入主程序界面按钮
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateHighlighted];
    [startButton setTitle:@"开始快递" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(clickStartBtn) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
    
    startButton.size = startButton.currentBackgroundImage.size;
    checkButton.size = checkButton.currentImage.size;
    checkButton.width = startButton.width + 20;
    
    
    checkButton.centerX = DDNewFeatureCenterX;
    startButton.centerX = DDNewFeatureCenterX;

    
    startButton.y = DDNewFeatureHeight - 150;
    checkButton.y = startButton.y - checkButton.height - 20;
}

//点击选择框
-(void)clickCheckBtn: (UIButton *)btn
{
    btn.selected = !btn.selected;
}

//点击进入程序主页面按钮
-(void)clickStartBtn
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[DDHomeController alloc] init];
}

#pragma mark - scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / self.view.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}
@end
