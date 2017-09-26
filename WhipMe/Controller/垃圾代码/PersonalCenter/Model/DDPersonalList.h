//
//  DDPersonalList.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/24.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    个人中心菜单
 */

@interface DDPersonalList : NSObject

/** 个人中心列名 */
@property (nonatomic, copy) NSString *indexName;

/** 个人中心列图标 */
@property (nonatomic, copy) NSString *indexIcon;

/** 个人中心列注解 */
@property (nonatomic, copy) NSString *indexComment;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)personalListWithDict: (NSDictionary *)dict;

@end
