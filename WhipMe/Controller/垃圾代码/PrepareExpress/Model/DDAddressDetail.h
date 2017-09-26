//
//  DDAddressDetail.h
//  DDExpressClient
//
//  Created by SongGang on 2/23/16.
//  Copyright © 2016 NS. All rights reserved.
//
/**
    地址信息模型
 */
#import <Foundation/Foundation.h>

@interface DDAddressDetail : NSObject

/**< 地址经度 */
@property (nonatomic, assign) float longitude;
/**< 地址纬度 */
@property (nonatomic, assign) float latitude;
/** 地址类型1寄件2收件 */
@property (nonatomic,assign)  NSInteger addressType;
/**< 地址ID */
@property (nonatomic, copy) NSString  * addressID;
/** 地址名 */
@property (nonatomic,copy)  NSString * addressName;
/** 定位地址 */
@property (nonatomic,copy)  NSString * localDetailAddress;
/** 补充地址 */
@property (nonatomic, copy) NSString *supplementAddress;
/**  定位地址+地址名  */
@property (nonatomic, copy) NSString *contentAddress;
/** 姓名 */
@property (nonatomic,copy)  NSString * name;

@property (nonatomic, strong) NSString *nick;
/** 手机号(寄件地址为空) */
@property (nonatomic,copy)  NSString * phone;
/** 标签 */
@property (nonatomic,copy)  NSString * sign;
/**  省ID  */
@property (nonatomic, strong) NSString *provinceId;
/**  省名  */
@property (nonatomic, strong) NSString *provinceName;
/**  市ID  */
@property (nonatomic, strong) NSString *cityId;
/**  市名  */
@property (nonatomic, strong) NSString *cityName;
/**  区ID  */
@property (nonatomic, strong) NSString *districtId;
/**  区名  */
@property (nonatomic, strong) NSString *districtName;
@end
