//
//  DDCenterCoordinate.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCenterCoordinate.h"
#import <CoreLocation/CoreLocation.h>
#import "Constant.h"

#define kMath_PI  3.1415926 //圆周率
#define kEARTH_RADIUS 6378137 //赤道半径
#define KRadWithRScale kMath_PI/180.0 //得到弧度

static CLLocationCoordinate2D _centerCoordinate;

static CLLocationCoordinate2D _sendExpressCoordinate;

static CLLocationCoordinate2D _userLocationCoordinate;

static BMKAddressComponent *_addressDetail;

static NSString *_address;

@implementation DDCenterCoordinate


/**
    保存地图中心点坐标 
 */
+ (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
{
    _centerCoordinate = centerCoordinate;
}

/**
    获取地图中心点坐标
 */
+ (CLLocationCoordinate2D)getCenterCoordinate
{
    return _centerCoordinate;
}


/** 保存地图中心点层次化地址信息 - yangg */
+ (void)setCenterAddressComponent:(BMKAddressComponent *)addressDetail
{
    _addressDetail = addressDetail;
}

/** 获取地图中心点层次化地址信息 - yangg */
+ (BMKAddressComponent *)getCenterAddressComponent
{
    return _addressDetail;
}

/** 保存地图中心点地址名称 - yangg */
+ (void)setCenterAddress:(NSString *)address
{
    _address = address;
}

/** 获取地图中心点地址名称 - yangg */
+ (NSString *)getCenterAddress
{
    return _address;
}

/**
 *  得到距离(米)
 */
+ (double)getDistanceWithLon1:(double)lon1 andLat1:(double)lat1 withLon2:(double)lon2 andLat2:(double)lat2
{
    double radLat1 = KRadWithRScale *lat1;
    double radLat2 = KRadWithRScale *lat2;
    double a = radLat1 - radLat2;
    double b = KRadWithRScale * lon1 - KRadWithRScale * lon2;
    double s = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b / 2 ), 2)));
    s = s * kEARTH_RADIUS;
    
    return  round(s * 10000) / 10000;
    
}

+ (void)setSendExpressInfoWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    _sendExpressCoordinate = coordinate;
}

+ (CLLocationCoordinate2D)getSendExpressInfoCoordinate
{
    return _sendExpressCoordinate;
}

+ (void)setUserLocation:(CLLocationCoordinate2D)coordinate
{
    _userLocationCoordinate = coordinate;
}

+ (CLLocationCoordinate2D)getUserLocationCoordinate
{
    return _userLocationCoordinate;
}

@end
