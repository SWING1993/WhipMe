//
//  DDAddressModel.m
//  DDExpressClient
//
//  Created by Jadyn on 16/3/3.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDAddressModel.h"

@implementation DDAddressModel



- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //将字典数据转换成model数据
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}



/**
 *  类方法调用构造方法
 *
 *  @param dict 传入的字典
 */
+ (instancetype)addressWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (BOOL)isEqualTo:(id)obj {
    
    if([[obj addressName] isEqualToString:self.addressName]
       && [[obj addressContent] isEqualToString:self.addressContent]) {
        return YES;
    }
    
    return NO;
}

@end
