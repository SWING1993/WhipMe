//
//  DDGoodsTypeListEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/22.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDGoodsTypeListEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"

const NSInteger DDGoodsTypeListIFCode                                   = 1042;                                         /**< 物品类型列表业务码 */
NSString *const DDGoodsTypeListIFVersion                                = @"1.0.0";                                     /**< 物品类型列表版本号 */

@interface DDGoodsTypeListEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                                   *goodsTypeListRequest;                      /**< 物品类型列表 */

@end

@implementation DDGoodsTypeListEntity

DDEntityHeadM(self.goodsTypeListRequest);

- (void)entityWithParam:(NSDictionary *)param {
    NSMutableDictionary *ifParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:DDGoodsTypeListIFCode],CodeKey,
                                    DDGoodsTypeListIFVersion,VersionKey,
                                    nil];

    [ifParam addEntriesFromDictionary:param];


    self.goodsTypeListRequest    = [[DDRequest alloc] initWithDelegate:self];
    [self.goodsTypeListRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:ifParam];
}

@end
