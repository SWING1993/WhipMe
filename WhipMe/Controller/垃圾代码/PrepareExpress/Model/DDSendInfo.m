//
//  DDSendInfo.m
//  DDExpressClient
//
//  Created by SongGang on 2/23/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDSendInfo.h"
#import "DDAddressDetail.h"

@implementation DDSendInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"selfAddressId" : @"sendAddrId",
             @"targetAddressId" : @"receAddrId",
             @"companyIds" : @"corIdList",
             @"takeTime" : @"getTime",
             @"itemImage" : @"image",
             @"itemWeight" : @"weight",
             @"itemType" : @"type",
             @"itemTip" : @"tip",
             @"itemInsure" : @"insure",
             @"itemTag" : @"tag",
             @"budgetCost" : @"cost",
             @"targetPay" : @"pay"
             };
}

@end
