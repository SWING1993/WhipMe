//
//  DDBackgroundRectangleView.m
//  DuDu Courier
//
//  Created by yangg on 16/4/1.
//  Copyright © 2016年 yangg. All rights reserved.
//

#define KView_Alpha 0.5f
#define DDSCreenBounds [UIScreen mainScreen].bounds

#import "DDBackgroundRectangleView.h"
#import "Constant.h"

@interface DDBackgroundRectangleView ()
{
    CGSize _sizeScreen;
}
/**地图四周的阴影*/
@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) UIView *viewLeft;
@property (nonatomic, strong) UIView *viewRight;
@property (nonatomic, strong) UIView *viewBottom;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation DDBackgroundRectangleView
@synthesize viewTop;
@synthesize viewLeft;
@synthesize viewRight;
@synthesize viewBottom;

@synthesize contentView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _sizeScreen = frame.size;
        [self setup];
    }
    return self;
}

- (void)setup
{
    contentView = [[UIView alloc] init];
    [contentView setFrame:CGRectMake(_sizeScreen.width/4.0f, _sizeScreen.height/4.0f, _sizeScreen.width/2.0f, _sizeScreen.height/2.0f)];
    [contentView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:contentView];
    
    /** 地图四周的阴影*/
    viewTop = [[UIView alloc] init];
    [viewTop setFrame:CGRectMake(0, 0, _sizeScreen.width, contentView.top)];
    [viewTop setBackgroundColor:[UIColor blackColor]];
    [viewTop setAlpha:KView_Alpha];
    [self addSubview:viewTop];
    
    viewLeft = [[UIView alloc] init];
    [viewLeft setFrame:CGRectMake(0, viewTop.bottom, contentView.left, contentView.bottom - viewTop.bottom)];
    [viewLeft setBackgroundColor:viewTop.backgroundColor];
    [viewLeft setAlpha:KView_Alpha];
    [self addSubview:viewLeft];
    
    viewRight = [[UIView alloc] init];
    [viewRight setFrame:CGRectMake(contentView.right, viewLeft.top, _sizeScreen.width - contentView.right, viewLeft.height)];
    [viewRight setBackgroundColor:viewTop.backgroundColor];
    [viewRight setAlpha:KView_Alpha];
    [self addSubview:viewRight];
    
    viewBottom = [[UIView alloc] init];
    [viewBottom setFrame:CGRectMake(0, contentView.bottom, _sizeScreen.width, _sizeScreen.height - contentView.bottom)];
    [viewBottom setBackgroundColor:viewTop.backgroundColor];
    [viewBottom setAlpha:KView_Alpha];
    [self addSubview:viewBottom];

}

- (void)setAlphaRectangle:(CGFloat)alphaRectangle
{
    [viewTop setAlpha:alphaRectangle];
    [viewLeft setAlpha:alphaRectangle];
    [viewRight setAlpha:alphaRectangle];
    [viewBottom setAlpha:alphaRectangle];
}

- (void)setCurrentFrame:(CGRect)currentFrame
{
    [contentView setFrame:currentFrame];
    
    
    [viewTop setFrame:CGRectMake(0, 0, _sizeScreen.width, contentView.top)];
    [viewLeft setFrame:CGRectMake(0, viewTop.bottom, contentView.left, contentView.bottom - viewTop.bottom)];
    [viewRight setFrame:CGRectMake(contentView.right, viewLeft.top, _sizeScreen.width - contentView.right, viewLeft.height)];
    [viewBottom setFrame:CGRectMake(0, contentView.bottom, _sizeScreen.width, _sizeScreen.height - contentView.bottom)];
}

@end
