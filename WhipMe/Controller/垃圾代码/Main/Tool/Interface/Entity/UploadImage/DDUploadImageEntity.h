//
//  DDUploadImageEntity.h
//  DDExpressCourier
//
//  Created by Sxx on 16/4/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDEntityProtocol.h"
#import "InterfaceConstant.h"
#import "DDEntityHeadFile.h"

/**
 *  上传图片
 */
@interface DDUploadImageEntity : NSObject<DDEntityProtocol>

@property (nonatomic, weak)     id<DDEntityDelegate>                             delegate;                              /**< 代理 */

/**
 *  初始化
 *
 *  @param delegate 代理
 *
 *  @return 实体实例
 */
- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate;

@end
