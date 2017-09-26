//
//  DDRadarView.m
//  DDExpressClient
//
//  Created by JiChao on 16/5/5.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDRadarView.h"
#import "Constant.h"

@interface DDRadarView ()

@property (nonatomic,weak) CALayer *animationLayer;

@end

@implementation DDRadarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame thumbnail:(NSString *)thumbnailUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
        self.backgroundColor = [UIColor clearColor];
        self.thumbnailImage = ImageNamed(thumbnailUrl);
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor clearColor] setFill];
    
    UIRectFill(rect);
    
    NSInteger pulsingCount = 2;
    double animationDuration = 5;
    
    CALayer * animationLayer = [[CALayer alloc]init];
    self.animationLayer = animationLayer;
    
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [[CALayer alloc]init];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.backgroundColor = DDRGBAColor(255, 91, 17, 1).CGColor;
        pulsingLayer.borderColor = DDRGBAColor(255, 91, 17, 1).CGColor;
        pulsingLayer.borderWidth = 1.0;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.fillMode = kCAFillModeBoth;
        
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration/(double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE_VAL;
        animationGroup.timingFunction = defaultCurve;
        
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:0.2];
        scaleAnimation.toValue = [NSNumber numberWithDouble:10];
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[[NSNumber numberWithDouble:1.0],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.0]];
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    
    [self.layer addSublayer:self.animationLayer];
    
    CALayer * thumbnailLayer = [[CALayer alloc]init];
    thumbnailLayer.backgroundColor = [UIColor clearColor].CGColor;
    CGRect thumbnailRect = CGRectMake(0, 0, 20, 20);
    thumbnailRect.origin.x = (rect.size.width - thumbnailRect.size.width)/2.0;
    thumbnailRect.origin.y = (rect.size.height - thumbnailRect.size.height)/2.0;
    thumbnailLayer.frame = thumbnailRect;
    thumbnailLayer.cornerRadius = 10;
    thumbnailLayer.borderWidth = 1.0;
    thumbnailLayer.masksToBounds = YES;
    thumbnailLayer.borderColor = [UIColor clearColor].CGColor;
    UIImage * thumbnail = self.thumbnailImage;
    thumbnailLayer.contents = (id)thumbnail.CGImage;
    [self.layer addSublayer:thumbnailLayer];
}

- (void)resume{
    if (self.animationLayer) {
        [self.animationLayer removeFromSuperlayer];
        [self setNeedsDisplay];
    }
}

@end
