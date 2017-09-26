//
//  DDMyExpress.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/1.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDMyExpress.h"

@implementation DDMyExpress

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+ (instancetype)myExpressWithDict: (NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

/** 返回(1已揽收/2已发货/3已签收) */
+ (NSString *)expressForStatu:(NSInteger)index
{
    NSString *statu_str = @"";
    if (index == 1) {
        statu_str = @"已揽收";
    } else if (index == 2) {
        statu_str = @"已发货";
    } else if (index == 3) {
        statu_str = @"已签收";
    }
    return statu_str;
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"expressStatus" : @"status",
             @"companyName" : @"corName",
             @"companyLogo" : @"corId",
             @"companyId" : @"corId",
             @"expressNumber" : @"expNum",
             @"sendName" : @"sName",
             @"revName" : @"rName",
             @"expressDate" : @"date",
             @"companyPhone" : @"corPhone",
             @"courierLon" : @"couLon",
             @"courierLat" : @"couLat",
             @"expressComment" : @"comment",
             @"laLog" : @"laLog",
             @"sended" : @"send",
             @"processList" : @"procList",
             @"htelPhone" : @"htel",
             };
}

- (void)setDetailExpressResult:(NSDictionary *)result
{
    _detailExpressResult = result;
    
    self.expressComment = result[@"comment"] ?: @"";
    self.companyId      = result[@"corId"] ?: @"";
    self.companyName    = result[@"corName"] ?: @"";
    self.companyPhone   = result[@"corPhone"] ?: @"";
    self.expressNumber  = result[@"expNum"] ?: @"";
    self.htelPhone  = result[@"htel"] ?: @"";
    
    self.sendName = result[@"sName"] ?: @"";
    self.revName = result[@"rName"] ?: @"";
    
    if (result[@"status"] != [NSNull null])
    {
        self.expressStatus = [result[@"status"] integerValue];
    } else {
        self.expressStatus = -1;
    }
    
    if (![result[@"couLat"] isKindOfClass:[NSNull class]])
    {
        self.courierLat = [result[@"couLat"] floatValue];
    } else {
        self.courierLat = 0.0f;
    }
    
    if (![result[@"couLon"] isKindOfClass:[NSNull class]])
    {
        self.courierLon = [result[@"couLon"] floatValue];
    } else {
        self.courierLon = 0.0f;
    }
    
    //数组，物流信息列表
    self.processList = [[NSMutableArray alloc] initWithCapacity:0];
    if (![result[@"procList"] isKindOfClass:[NSNull class]])
    {
        for (NSDictionary *item in result[@"procList"])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            
            [dict setValue:item[@"content"] ?: @"" forKey:@"content"];
            [dict setValue:item[@"remark"]  ?: @"" forKey:@"remark"];
            [dict setValue:item[@"status"]  ?: @"" forKey:@"status"];
            [dict setValue:item[@"time"]    ?: @"" forKey:@"time"];
            
            [self.processList insertObject:dict atIndex:0];
        }
    }
    
}

@end
