//
//  HKLocation.h
//  mimihua
//
//  Created by Song on 2017/12/1.
//  Copyright © 2017年 magicblack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HKLocation : NSObject

+ (instancetype)sharedInstance;
- (void)getLocationName:(void(^) (NSError *error,CLLocation *location))block;

@end
