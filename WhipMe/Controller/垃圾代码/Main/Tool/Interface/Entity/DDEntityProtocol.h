//
//  DDEntityProtocol.h
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#ifndef DDEntityProtocol_h
#define DDEntityProtocol_h


/**
 *  实体层协议
 */
@protocol DDEntityProtocol <NSObject>

@required

/**
 *  实体层请求
 *
 *  @param param 请求字典
 */
- (void)entityWithParam:(NSDictionary *)param;

@end


/**
 *  实体层代理
 */
@protocol DDEntityDelegate <NSObject>

@optional

/**
 *  实体层代理(实体层需要回调的通过这个代理回调给接口)
 *
 *  @param entity 实体实例
 *  @param result 结果字典
 *  @param error  错误信息 nil 成功
 */
- (void)entity:(id<DDEntityProtocol>)entity result:(NSDictionary *)result error:(NSError *)error;

@end

#endif /* DDEntityProtocol_h */
