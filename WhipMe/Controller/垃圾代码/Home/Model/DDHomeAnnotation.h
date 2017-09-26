//
//  DDHomeAnnotation.h
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/6.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKPointAnnotation.h>

@interface DDHomeAnnotation : BMKPointAnnotation

@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *companyLogo;
@property (nonatomic, strong) NSString *courierId;

@property (nonatomic, strong) NSArray *positionArray;
@property (nonatomic, strong) NSArray *locationPositionArray;

@property (nonatomic, readonly) CGFloat rotation;

@property (nonatomic, assign) double courierLatitude;
@property (nonatomic, assign) double courierLongtitude;

@property (nonatomic, assign) BOOL isSendExpressLocation;

@end
