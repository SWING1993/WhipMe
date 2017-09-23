//
//  DDCompanyModel.m
//  DDExpressClient
//
//  Created by EWPSxx on 3/10/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDCompanyModel.h"

@implementation DDCompanyModel

- (instancetype)initWithDict:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}


+ (instancetype)companyWithDict: (NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
