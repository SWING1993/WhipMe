//
//  NSObject+StoreValue.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/23.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (StoreValue)

/**
 *  存储对象
 *
 *  @param key key
 */
- (void)storeValueWithKey:(NSString *)key;

/**
 *  获取对象
 *
 *  @param key key
 *
 *  @return 对象
 */
+ (id)valueByKey:(NSString *)key;

/**
 *  移除对象
 *
 *  @param key key
 */
- (void)removeValueForKey:(NSString *)key;

@end
