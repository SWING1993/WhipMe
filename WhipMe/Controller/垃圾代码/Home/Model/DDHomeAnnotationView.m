//
//  DDHomeAnnotationView.m
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDHomeAnnotationView.h"
#import <MapKit/MapKit.h>

@interface DDHomeAnnotationView ()

@end

static NSString *DDHomeAnnotationTransformsKey = @"TransformsGroupAnimation";

@implementation DDHomeAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.canShowCallout = YES;
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return self;
}

//- (void)setAnnotation:(id <BMKAnnotation>)anAnnotation
//{
//    [super setAnnotation:anAnnotation];
//    
//    if (anAnnotation) {
//        [self updateTransformInfoWithAnnotation:(DDHomeAnnotation *)anAnnotation animate:NO];
//    }
//}

- (void)realTimeUpdateTransformInfoWithAnnotation:(DDHomeAnnotation *)annotation
{
    
}

- (void)updateTransformInfoWithAnnotation:(DDHomeAnnotation *)annotation animate:(BOOL)animate
{
    NSArray *positionArray = annotation.positionArray;
    
    if (positionArray.count > 0) {
        
        NSMutableDictionary *transformDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [transformDic setObject:positionArray forKey:@"coordinate"];
        
        if ([annotation respondsToSelector:@selector(rotation)]) {
            if (annotation.rotation > 0) {
                [transformDic setObject:@(annotation.rotation) forKey:@"rotation"];
            }
        }
        
        [self startAnimationWithTransformInfo:transformDic animate:animate];
    }
}

- (void)startAnimationWithTransformInfo:(NSDictionary *)transformDic animate:(BOOL)animate
{
    NSMutableArray *tempArray = [transformDic objectForKey:@"coordinate"];
    
    NSMutableArray *positionArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tmpDic in tempArray) {
        if ([tmpDic objectForKey:@"latitude"] && [tmpDic objectForKey:@"longtitude"]) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[tmpDic objectForKey:@"latitude"] doubleValue], [[tmpDic objectForKey:@"longtitude"] doubleValue]);
            [positionArray addObject:[NSValue valueWithCGPoint:[self getScreenPointFromCoordinate:coordinate]]];
        }
    }
    
    CGPoint firstPosition = [[positionArray objectAtIndex:0] CGPointValue];
    
    if (animate) {
        
        NSArray *values = positionArray;
        
        CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [keyFrameAnimation setValues:values];
        keyFrameAnimation.delegate = self;
        [keyFrameAnimation setDuration:3];
        [keyFrameAnimation setAutoreverses:NO];
        keyFrameAnimation.removedOnCompletion = NO;
        keyFrameAnimation.fillMode = kCAFillModeForwards;
        keyFrameAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [self.layer addAnimation:keyFrameAnimation forKey:DDHomeAnnotationTransformsKey];
        
    } else {
        [self.layer setAffineTransform:CGAffineTransformMakeRotation([[transformDic objectForKey:@"rotation"] floatValue])];
        self.center = firstPosition;
    }
}

- (CGPoint)getScreenPointFromCoordinate:(CLLocationCoordinate2D)coordinate2D
{
    return [self.mapView convertCoordinate:coordinate2D toPointToView:self.mapView];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSDictionary *tmpDic = ((DDHomeAnnotation *)self.annotation).positionArray.lastObject;
    CGPoint point = [self.mapView convertCoordinate:CLLocationCoordinate2DMake([[tmpDic objectForKey:@"latitude"] doubleValue], [[tmpDic objectForKey:@"longtitude"] doubleValue]) toPointToView:self.mapView];
    self.layer.position = point;
}

#pragma mark - BMKMapDelegate
- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
    CGFloat width = 20;
    if (mapView.zoomLevel <= 16) {
        width = 28;
    } else if (mapView.zoomLevel <= 32) {
        width = 25;
    } else if (mapView.zoomLevel <= 64) {
        width = 20;
    } else if (mapView.zoomLevel <= 128) {
        width = 15;
    } else if (mapView.zoomLevel <= 256) {
        width = 10;
    }
    
    if (width != self.bounds.size.width) {
        [self setBounds:CGRectMake(0, 0, width, width) animated:YES];
    }
}

- (void)setBounds:(CGRect)rect animated :(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bounds = rect;
        }];
    }
    self.bounds = rect;
}



@end
