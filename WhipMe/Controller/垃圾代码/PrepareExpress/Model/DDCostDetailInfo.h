//
//  DDCostDetailInfo.h
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/21.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDCostDetailInfo : NSObject

@property (nonatomic, strong) NSString *firstWeightCost;
@property (nonatomic, strong) NSString *secondWeightCost;
@property (nonatomic, strong) NSString *tipCost;
@property (nonatomic, strong) NSString *couponCost;

@property (nonatomic, strong) NSString *finalCost;

@end
