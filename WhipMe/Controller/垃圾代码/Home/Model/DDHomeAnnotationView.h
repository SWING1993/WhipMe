//
//  DDHomeAnnotationView.h
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "DDHomeAnnotation.h"

@protocol DDHomeAnnotationViewDelegate;

@interface DDHomeAnnotationView : BMKAnnotationView <BMKMapViewDelegate>

@property (nonatomic, assign) id <DDHomeAnnotationViewDelegate> delegate;
@property (nonatomic, strong) BMKMapView *mapView;

- (void)realTimeUpdateTransformInfoWithAnnotation:(DDHomeAnnotation *)annotation;

- (void)updateTransformInfoWithAnnotation:(DDHomeAnnotation *)annotation animate:(BOOL)animate;

@end

@protocol DDHomeAnnotationViewDelegate <NSObject>

@optional
- (void)DDHAVD_resetAnnotationWithAnnotationView:(DDHomeAnnotationView *)annotationView point:(CGPoint)point;

@end
