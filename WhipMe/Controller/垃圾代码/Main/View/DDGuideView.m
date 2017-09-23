//
//  DDGuideView.m
//  DDExpressClient
//
//  Created by JiChao on 16/4/30.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDGuideView.h"
#import "Constant.h"

@interface DDGuideView () <UIScrollViewDelegate>
{
    UIPageControl *currentPageControl;
    UIView *startbgView;
    
    BOOL isScrollView;
}

@property (nonatomic, assign) NSInteger pageCount;

@end

@implementation DDGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initGuideViewWithPageCount:(NSInteger)pageCount
{
    self = [super init];
    
    if (self) {
        self.pageCount = pageCount;
        [self addGuideView];
    }
    
    return self;
}

- (void)addGuideView {
    
    currentPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 39 / 2, MainScreenHeight - 52, 39, 37)];
    currentPageControl.currentPageIndicatorTintColor = RGBCOLOR(181, 181, 181);
    currentPageControl.pageIndicatorTintColor = RGBCOLOR(221, 221, 221);
    
    startbgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    startbgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:startbgView];
    
    UIScrollView *startScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    startScrollView.delegate = self;
    startScrollView.bounces = NO;
    startScrollView.showsHorizontalScrollIndicator = NO;
    startScrollView.showsVerticalScrollIndicator = NO;
    
    for (int i = 1; i < self.pageCount + 1; i++) {
        
        UIImageView *startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth * (i - 1) , 0, MainScreenWidth, MainScreenHeight)];
        UIImage *image = [self getImageWithPageIndex:i];
        [startImageView setImage:image];
        
        [startScrollView addSubview:startImageView];
    }
    
    UIButton *startbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    startbtn.backgroundColor = [UIColor clearColor];
    [startbtn addTarget:self action:@selector(startapp) forControlEvents:UIControlEventTouchUpInside];
    startbtn.frame = CGRectMake(MainScreenWidth * (self.pageCount - 1), 0, MainScreenWidth, MainScreenHeight);
    [startScrollView addSubview:startbtn];
    
    currentPageControl.numberOfPages = self.pageCount;
    [startbgView addSubview:startScrollView];
    [startbgView addSubview:currentPageControl];
    
    [startScrollView setContentSize:CGSizeMake(MainScreenWidth * self.pageCount, MainScreenHeight)];
    [startScrollView setPagingEnabled:YES];//分页拖动显示

}

- (UIImage *)getImageWithPageIndex:(int)pageIndex
{
    if (DEVICE_IS_IPHONE4) {
        
        NSString *imageName = [NSString stringWithFormat:@"Launch%dip4.png",pageIndex];
        return ImageNamed(imageName);
        
    } else if (DEVICE_IS_IPHONE5) {
        
        NSString *imageName = [NSString stringWithFormat:@"Launch%dip5.png",pageIndex];
        return ImageNamed(imageName);
        
    } else if (DEVICE_IS_IPHONE6) {
        
        NSString *imageName = [NSString stringWithFormat:@"Launch%dip6.png",pageIndex];
        return ImageNamed(imageName);
        
    } else {
        
        NSString *imageName = [NSString stringWithFormat:@"Launch%dip6Puls.png",pageIndex];
        return ImageNamed(imageName);
    }
}


-(void)startapp
{
    [UIView animateWithDuration:1 animations:^{
        startbgView.alpha = 0;
    } completion:^(BOOL finished) {
        [startbgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!isScrollView) {
    
        currentPageControl.currentPage = scrollView.contentOffset.x/MainScreenWidth;
        
        if(scrollView.contentOffset.x > MainScreenWidth * (self.pageCount - 1) + 10.0){
            isScrollView =  YES;
            [UIView animateWithDuration:1 animations:^{
                
                startbgView.alpha = 0;
                
            } completion:^(BOOL finished) {
                [startbgView removeFromSuperview];
            }];
        }
    }
}


@end
