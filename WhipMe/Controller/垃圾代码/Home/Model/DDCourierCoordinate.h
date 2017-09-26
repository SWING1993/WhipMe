//
//  DDCourierAnnotation.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/1.
//  Copyright © 2016年 NS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface DDCourierCoordinate : NSObject

@property (nonatomic, strong) NSArray  *positionList;
@property (nonatomic, copy) NSString *courierID;
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, copy) NSString *companyLogo;

@property (nonatomic, strong) NSArray *appendAllPositionArray;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
