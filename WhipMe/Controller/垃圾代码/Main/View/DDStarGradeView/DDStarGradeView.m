//
//  DDStarGradeView.m
//  DuDu Courier
//
//  Created by yangg on 16/3/21.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import "DDStarGradeView.h"
#import "Constant.h"

/** 小空星 */
NSString *const KDDStarIconOff = @"StarLevelOff";
/** 小实星 */
NSString *const KDDStarIconOn = @"StarLevelOn";
/** 默认大小 */
NSInteger const KDDStarSize = 11.0f;

@interface DDStarGradeView ()

/** 设置进度条的背景图片 */
@property (nonatomic, readwrite, strong) UIImage *trackImage;
/** 设置进度条上进度的背景图片 */
@property (nonatomic, readwrite, strong) UIImage *progressImage;
/** 设置每个星的大小，默认宽高相等 */
@property (nonatomic, readwrite, assign) CGFloat sizeStar;
@end

@implementation DDStarGradeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setTrackImage:(UIImage *)trackImage
{
    _trackImage = trackImage;
}

- (void)setProgressImage:(UIImage *)progressImage
{
    _progressImage = progressImage;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
}

- (void)setSizeStar:(CGFloat)sizeStar
{
    _sizeStar = sizeStar;
}

- (void)display
{
    for (UILabel *subview in [self subviews])
    {
        [subview removeFromSuperview];
    }
    
    NSMutableArray *arrayStarPath = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<5; i++)
    {
        if (i < (int)_progress) {
            [arrayStarPath addObject:KDDStarIconOn];
        } else {
            [arrayStarPath addObject:KDDStarIconOff];
        }
    }
    
    for (int i=0; i<[arrayStarPath count]; i++)
    {
        UIImageView *imgStar = [[UIImageView alloc] init];
        [imgStar setFrame:CGRectMake(i * (KDDStarSize + 3.0f), MAX(0, floorf(self.height-KDDStarSize)/2.0f), KDDStarSize, KDDStarSize)];
        [imgStar setBackgroundColor:[UIColor clearColor]];
        [imgStar setImage:[UIImage imageNamed:arrayStarPath[i]]];
        [self addSubview:imgStar];
    }
    [self setSize:CGSizeMake(MAX(self.width, arrayStarPath.count*(KDDStarSize + 3.0f)-3.0f), MAX(self.height, KDDStarSize))];
    
}


@end
