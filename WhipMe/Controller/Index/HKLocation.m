//
//  HKLocation.m
//  mimihua
//
//  Created by Song on 2017/12/1.
//  Copyright © 2017年 magicblack. All rights reserved.
//

#import "HKLocation.h"

@interface HKLocation() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationMgr;
@property (nonatomic, copy) void (^block) (NSError *error,CLLocation *location);

@end

@implementation HKLocation

+ (instancetype)sharedInstance {
    static HKLocation *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[HKLocation alloc] init];
    });
    return location;
}

- (instancetype)init {
    if (self = [super init]) {
        CLLocationManager *locationMgr = [[CLLocationManager alloc] init];
        self.locationMgr = locationMgr;
        [locationMgr requestWhenInUseAuthorization];
        locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        locationMgr.distanceFilter = 10.0;
        locationMgr.delegate = self;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ -dealloc",NSStringFromClass([self class]));
}

- (void)getLocationName:(void (^)(NSError *,  CLLocation*))block {
    if ([CLLocationManager locationServicesEnabled]) {//定位服务开启
        [self.locationMgr startUpdatingLocation];
        self.block = block;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations) {
        CLLocation *location = [locations firstObject];
        self.block(nil,location);
        [self.locationMgr stopUpdatingLocation];
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    self.block(error,nil);
}

@end
