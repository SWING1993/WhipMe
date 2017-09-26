//
//  DDProvinceList.h
//  DDExpressCourier
//
//  Created by yoga on 16/3/18.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDProvinceList : NSObject
/**<  省名  */
@property (nonatomic,strong) NSString *provinceName;
/**<  省份Id  */
@property (nonatomic,assign) NSInteger provinceId;
/**<  城市列表  */
@property (nonatomic,strong) NSArray *provinceSub;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)provinceListWithDict: (NSDictionary *)dict;
@end
