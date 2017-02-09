//
//  HKTriangleView.m
//  Deom_2017_02_07
//
//  Created by anve on 17/2/9.
//  Copyright © 2017年 sely. All rights reserved.
//  三角形

#import "HKTriangleView.h"

@interface HKTriangleView ()

@property (nonatomic, strong) UIImageView *imageLogo;
@property (nonatomic, strong) UILabel *lblTime, *lblTitle;

@property (nonatomic, assign) CGFloat kWidth, kHeight;

@end

@implementation HKTriangleView
@synthesize time = _time;
@synthesize logo = _logo;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

+ (HKTriangleView *)viewTriangleWithTip:(NSString *)tip {
    HKTriangleView * viewTriangle = [[HKTriangleView alloc] initWithFrame:CGRectMake(([Define screenWidth] - 200.0)/2.0, ([Define screenHeight]-160.0) - 130.0, 200.0, 160.0)];
    viewTriangle.backgroundColor = [UIColor clearColor];
    viewTriangle.title = tip;
    return viewTriangle;
}

- (void)setup {
    
    self.backgroundColor = [UIColor clearColor];
    _imageLogo = [[UIImageView alloc] init];
    [_imageLogo setBackgroundColor:[UIColor clearColor]];
    [_imageLogo setContentMode:UIViewContentModeScaleAspectFill];
    [_imageLogo setClipsToBounds:YES];
    [_imageLogo setImage:self.logo];
    [self addSubview:self.imageLogo];
    
    _lblTime = [[UILabel alloc] init];
    [_lblTime setBackgroundColor:[UIColor clearColor]];
    [_lblTime setTextColor:[UIColor whiteColor]];
    [_lblTime setFont:[UIFont systemFontOfSize:10.0]];
    [_lblTime setTextAlignment:NSTextAlignmentCenter];
    [_lblTime setText:self.time];
    [self addSubview:self.lblTime];
    
    _lblTitle = [[UILabel alloc] init];
    [_lblTitle setBackgroundColor:[UIColor clearColor]];
    [_lblTitle setTextColor:[UIColor whiteColor]];
    [_lblTitle setFont:[UIFont systemFontOfSize:22.0]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.lblTitle];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat origin_y = 18.0;
    if (self.kHeight < 18.0) {
        origin_y = 0;
    }
    [self.imageLogo setFrame:CGRectMake((self.kWidth-MIN(45.0, self.kWidth))/2.0 - 3.0, origin_y, MIN(45.0, self.kWidth), MIN(58.0, self.kHeight))];
    
    [self.lblTime setFrame:CGRectMake((self.kWidth-[self viewTatio:90.0])/2.0, CGRectGetMaxY(self.imageLogo.frame)+12.0, [self viewTatio:90.0], 12.0)];
    [self.lblTitle setFrame:CGRectMake((self.kWidth-[self viewTatio:120.0])/2.0, CGRectGetMaxY(self.lblTime.frame)+10.0, [self viewTatio:120.0], 24.0)];
}

- (void)setLogo:(UIImage *)logo  {
    _logo = logo;
    [self.imageLogo setImage:logo];
}

- (void)setTime:(NSString *)time {
    _time = time;
    [self.lblTime setText:time];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.lblTitle setText:title];
}

- (void)drawRect:(CGRect)rect {
    
    //设置背景颜色
    [[UIColor clearColor] set];
    UIRectFill([self bounds]);
    
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.kWidth/2.0, 0);//设置起点
    CGContextAddLineToPoint(context, 0, self.kHeight);
    CGContextAddLineToPoint(context, self.kWidth, self.kHeight);
    CGContextClosePath(context);
    
    [self.triangleColor setFill]; //设置填充色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    
    //拿到当前视图准备好的画板
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    CGContextBeginPath(context2);
    CGContextMoveToPoint(context2, self.kWidth/2.0, 13.0);//设置起点
    CGContextAddLineToPoint(context2, 18.0, self.kHeight - 13.0);
    CGContextAddLineToPoint(context2, self.kWidth-18.0, self.kHeight-13.0);
    CGContextClosePath(context2);
    
    [self.internalColor setFill]; //设置填充色
    CGContextDrawPath(context2, kCGPathFillStroke);//绘制路径path
    
}

- (UIColor *)triangleColor {
    if (_triangleColor == nil) {
        _triangleColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _triangleColor;
}

- (UIColor *)internalColor {
    if (_internalColor == nil) {
        _internalColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _internalColor;
}

- (NSString *)time {
    if (_time == nil) {
        NSDate *date = [NSDate date];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        _time = [formater stringFromDate:date];
    }
    return _time;
}

- (UIImage *)logo {
    if (_logo == nil) {
        _logo = [UIImage imageNamed:@"LogoWatermark"];
    }
    return _logo;
}

- (CGFloat)kWidth {
    if (_kWidth <= 0.0) {
        _kWidth = self.bounds.size.width;
    }
    return _kWidth;
}

- (CGFloat)kHeight {
    if (_kHeight <= 0.0) {
        _kHeight = self.bounds.size.height;
    }
    return _kHeight;
}

- (CGFloat)viewTatio:(CGFloat)ratio {
    return (ratio/200.0)*self.kWidth;
}



@end
