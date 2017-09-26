//
//  DDSelfIdentity.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/2.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDSelfIdentity : NSObject

/** 姓名 */
@property (nonatomic ,copy) NSString *name;

/** 身份证号码 */
@property (nonatomic ,copy) NSString *identityID;

/** 身份证照片 */
@property (nonatomic ,copy) NSString *identityIDImage;

- (instancetype)initWithDict: (NSDictionary *)dict;

+ (instancetype)selfIdentityWithDict: (NSDictionary *)dict;

@end
