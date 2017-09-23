//
//  DDAddressDetail.m
//  DDExpressClient
//
//  Created by SongGang on 2/23/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDAddressDetail.h"

@implementation DDAddressDetail

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"addressID" : @"addrId",
             @"longitude" : @"addrLon",
             @"latitude" : @"addrLat",
             @"contentAddress" : @"main",
             @"supplementAddress" : @"detail",
             @"sign" : @"tag",
             @"addressType" : @"type",
             @"provinceId" : @"provId",
             @"cityId" : @"townId",
             @"districtId" : @"areaId",
             @"longitude" : @"lat",
             @"latitude" : @"lon"
             };
}


@end
