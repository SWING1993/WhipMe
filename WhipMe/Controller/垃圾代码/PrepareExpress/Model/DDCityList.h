//
//  DDCityList.h
//  DDExpressCourier
//
//  Created by yoga on 16/3/18.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCityList : NSObject


/**<  城市名  */
@property (nonatomic,strong) NSString *cityName;
/**<  城市Id  */
@property (nonatomic,assign) NSInteger cityId;
/**<  区域列表  */
@property (nonatomic,strong) NSArray *citySub;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)cityListWithDict: (NSDictionary *)dict;
@end
