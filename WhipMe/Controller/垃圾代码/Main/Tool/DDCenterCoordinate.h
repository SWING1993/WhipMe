//
//  DDCenterCoordinate.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/7.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface DDCenterCoordinate : NSObject


/** 保存地图中心点坐标 */
+ (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate;

/** 获取地图中心点坐标 */
+ (CLLocationCoordinate2D)getCenterCoordinate;

//保存寄件人地址
+ (void)setSendExpressInfoWithCoordinate:(CLLocationCoordinate2D)coordinate;

+ (CLLocationCoordinate2D)getSendExpressInfoCoordinate;

/** 保存地图中心点层次化地址信息 - yangg */
+ (void)setCenterAddressComponent:(BMKAddressComponent *)addressDetail;

/** 获取地图中心点层次化地址信息 - yangg */
+ (BMKAddressComponent *)getCenterAddressComponent;

/** 保存地图中心点地址名称 - yangg */
+ (void)setCenterAddress:(NSString *)address;

/** 获取地图中心点地址名称 - yangg */
+ (NSString *)getCenterAddress;

//保存自身经纬度
+ (void)setUserLocation:(CLLocationCoordinate2D)coordinate;

+ (CLLocationCoordinate2D)getUserLocationCoordinate;

/**
 *  得到距离(米)
 */
+ (double)getDistanceWithLon1:(double)lon1 andLat1:(double)lat1 withLon2:(double)lon2 andLat2:(double)lat2;

@end
