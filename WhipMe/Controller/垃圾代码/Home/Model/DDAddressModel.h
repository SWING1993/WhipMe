//
//  DDAddressModel.h
//  DDExpressClient
//
//  Created by Jadyn on 16/3/3.
//  Copyright © 2016年 NS. All rights reserved.
//
/**
 *  地址信息模型
 */






#import <Foundation/Foundation.h>

@interface DDAddressModel : NSObject
/**
 *  地址名称
 */
@property (nonatomic, strong) NSString *addressName;
/**
 *  地址所在城市
 */
@property (nonatomic, strong) NSString *addressCity;
/**
 *  地址所在区域
 */
@property (nonatomic, strong) NSString *addressDistrict;
/**
 *  地址经度(nsstring格式)
 */
@property (nonatomic, assign) double addressLatitude;
/**
 *  地址纬度(nsstring格式)
 */
@property (nonatomic, assign) double addressLongitude;
/**
 *  地址所在详细地址
 */
@property (nonatomic, strong) NSString *addressContent;





/**
 *  构造函数
 *
 *  @param dict 传入字典
 */
- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)addressWithDict: (NSDictionary *)dict;




@end
