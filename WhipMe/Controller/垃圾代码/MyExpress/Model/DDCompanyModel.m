//
//  DDCompanyModel.m
//  DDExpressClient
//
//  Created by yangg on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCompanyModel.h"

@implementation DDCompanyModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"companyID" : @"corId",
             @"companyName" : @"name"
             };
}

@end
